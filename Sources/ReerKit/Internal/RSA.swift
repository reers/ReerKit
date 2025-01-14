//
//  Copyright © 2020 TakeScoop
//  Copyright © 2022 reers.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if canImport(CommonCrypto) && canImport(Foundation)
import CommonCrypto
import Foundation

/// https://github.com/TakeScoop/SwiftyRSA/blob/master/Source/Asn1Parser.swift

enum RSA {
    /// Simple data scanner that consumes bytes from a raw data and keeps an updated position.
    private class Scanner {
        
        enum ScannerError: Error {
            case outOfBounds
        }
        
        let data: Data
        var index: Int = 0
        
        /// Returns whether there is no more data to consume
        var isComplete: Bool {
            return index >= data.count
        }
        
        /// Creates a scanner with provided data
        ///
        /// - Parameter data: Data to consume
        init(data: Data) {
            self.data = data
        }
        
        /// Consumes data of provided length and returns it
        ///
        /// - Parameter length: length of the data to consume
        /// - Returns: data consumed
        /// - Throws: ScannerError.outOfBounds error if asked to consume too many bytes
        func consume(length: Int) throws -> Data {
            
            guard length > 0 else {
                return Data()
            }
            
            guard index + length <= data.count else {
                throw ScannerError.outOfBounds
            }
            
            let subdata = data.subdata(in: index..<index + length)
            index += length
            return subdata
        }
        
        /// Consumes a primitive, definite ASN1 length and returns its value.
        ///
        /// See http://luca.ntop.org/Teaching/Appunti/asn1.html,
        ///
        /// - Short form. One octet. Bit 8 has value "0" and bits 7-1 give the length.
        /// - Long form. Two to 127 octets. Bit 8 of first octet has value "1" and
        ///   bits 7-1 give the number of additional length octets.
        ///   Second and following octets give the length, base 256, most significant digit first.
        ///
        /// - Returns: Length that was consumed
        /// - Throws: ScannerError.outOfBounds error if asked to consume too many bytes
        func consumeLength() throws -> Int {
            
            let lengthByte = try consume(length: 1).firstByte
            
            // If the first byte's value is less than 0x80, it directly contains the length
            // so we can return it
            guard lengthByte >= 0x80 else {
                return Int(lengthByte)
            }
            
            // If the first byte's value is more than 0x80, it indicates how many following bytes
            // will describe the length. For instance, 0x85 indicates that 0x85 - 0x80 = 0x05 = 5
            // bytes will describe the length, so we need to read the 5 next bytes and get their integer
            // value to determine the length.
            let nextByteCount = lengthByte - 0x80
            let length = try consume(length: Int(nextByteCount))
            
            return length.integer
        }
    }

    /// A simple ASN1 parser that will recursively iterate over a root node and return a Node tree.
    /// The root node can be any of the supported nodes described in `Node`. If the parser encounters a sequence
    /// it will recursively parse its children.
    enum Asn1Parser {
        
        /// An ASN1 node
        enum Node {
            case sequence(nodes: [Node])
            case integer(data: Data)
            case objectIdentifier(data: Data)
            case null
            case bitString(data: Data)
            case octetString(data: Data)
        }
        
        enum ParserError: Error {
            case noType
            case invalidType(value: UInt8)
        }
        
        /// Parses ASN1 data and returns its root node.
        ///
        /// - Parameter data: ASN1 data to parse
        /// - Returns: Root ASN1 Node
        /// - Throws: A ParserError if anything goes wrong, or if an unknown node was encountered
        static func parse(data: Data) throws -> Node {
            let scanner = Scanner(data: data)
            let node = try parseNode(scanner: scanner)
            return node
        }
        
        /// Parses an ASN1 given an existing scanne.
        /// @warning: this will modify the state (ie: position) of the provided scanner.
        ///
        /// - Parameter scanner: Scanner to use to consume the data
        /// - Returns: Parsed node
        /// - Throws: A ParserError if anything goes wrong, or if an unknown node was encountered
        private static func parseNode(scanner: Scanner) throws -> Node {
            
            let firstByte = try scanner.consume(length: 1).firstByte
            
            // Sequence
            if firstByte == 0x30 {
                let length = try scanner.consumeLength()
                let data = try scanner.consume(length: length)
                let nodes = try parseSequence(data: data)
                return .sequence(nodes: nodes)
            }
            
            // Integer
            if firstByte == 0x02 {
                let length = try scanner.consumeLength()
                let data = try scanner.consume(length: length)
                return .integer(data: data)
            }
            
            // Object identifier
            if firstByte == 0x06 {
                let length = try scanner.consumeLength()
                let data = try scanner.consume(length: length)
                return .objectIdentifier(data: data)
            }
            
            // Null
            if firstByte == 0x05 {
                _ = try scanner.consume(length: 1)
                return .null
            }
            
            // Bit String
            if firstByte == 0x03 {
                let length = try scanner.consumeLength()
                
                // There's an extra byte (0x00) after the bit string length in all the keys I've encountered.
                // I couldn't find a specification that referenced this extra byte, but let's consume it and discard it.
                _ = try scanner.consume(length: 1)
                
                let data = try scanner.consume(length: length - 1)
                return .bitString(data: data)
            }
            
            // Octet String
            if firstByte == 0x04 {
                let length = try scanner.consumeLength()
                let data = try scanner.consume(length: length)
                return .octetString(data: data)
            }
            
            throw ParserError.invalidType(value: firstByte)
        }
        
        /// Parses an ASN1 sequence and returns its child nodes
        ///
        /// - Parameter data: ASN1 data
        /// - Returns: A list of ASN1 nodes
        /// - Throws: A ParserError if anything goes wrong, or if an unknown node was encountered
        private static func parseSequence(data: Data) throws -> [Node] {
            let scanner = Scanner(data: data)
            var nodes: [Node] = []
            while !scanner.isComplete {
                let node = try parseNode(scanner: scanner)
                nodes.append(node)
            }
            return nodes
        }
    }
}

private extension Data {
    
    /// Returns the first byte of the current data
    var firstByte: UInt8 {
        var byte: UInt8 = 0
        copyBytes(to: &byte, count: MemoryLayout<UInt8>.size)
        return byte
    }
    
    /// Returns the integer value of the current data.
    /// @warning: this only supports data up to 4 bytes, as we can only extract 32-bit integers.
    var integer: Int {
        
        guard count > 0 else {
            return 0
        }
        
        var int: UInt32 = 0
        var offset: Int32 = Int32(count - 1)
        forEach { byte in
            let byte32 = UInt32(byte)
            let shifted = byte32 << (UInt32(offset) * 8)
            int = int | shifted
            offset -= 1
        }
        
        return Int(int)
    }
    
    var strippedKeyHeader: Data? {
        guard let node = try? RSA.Asn1Parser.parse(data: self) else { return nil }
        
        // Ensure the raw data is an ASN1 sequence
        guard case .sequence(let nodes) = node else {
            return nil
        }
        
        // Detect whether the sequence only has integers, in which case it's a headerless key
        let onlyHasIntegers = nodes.filter { node -> Bool in
            if case .integer = node {
                return false
            }
            return true
        }.isEmpty
        
        // Headerless key
        if onlyHasIntegers {
            return self
        }
        
        // If last element of the sequence is a bit string, return its data
        if let last = nodes.last, case .bitString(let data) = last {
            return data
        }
        
        // If last element of the sequence is an octet string, return its data
        if let last = nodes.last, case .octetString(let data) = last {
            return data
        }
        
        // Unable to extract bit/octet string or raw integer sequence
        return nil
    }
}

extension String {
    var privateSecKey: SecKey? {
        var key = self
        if let start = key.range(of: "-----BEGIN RSA PRIVATE KEY-----"),
           let end = key.range(of: "-----END RSA PRIVATE KEY-----") {
            key = String(key[start.upperBound..<end.lowerBound])
        } else if let start = key.range(of: "-----BEGIN PRIVATE KEY-----"),
                  let end = key.range(of: "-----END PRIVATE KEY-----") {
            key = String(key[start.upperBound..<end.lowerBound])
        }
        key.removeAll { ["\r", "\n", "\t", " "].contains($0) }
        guard let keyData = Data(base64Encoded: key, options: .ignoreUnknownCharacters),
              let data = keyData.strippedKeyHeader
        else { return nil }

        let options: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits: NSNumber(value: data.count * 8),
            kSecReturnPersistentRef: true
        ]
        return SecKeyCreateWithData(data as CFData, options as CFDictionary, nil)
    }
    
    var publicSecKey: SecKey? {
        var key = self
        if let start = key.range(of: "-----BEGIN PUBLIC KEY-----"),
           let end = key.range(of: "-----END PUBLIC KEY-----") {
            key = String(key[start.upperBound..<end.lowerBound])
        }
        key.removeAll { ["\r", "\n", "\t", " "].contains($0) }
        guard let keyData = Data(base64Encoded: key, options: .ignoreUnknownCharacters),
              let data = keyData.strippedKeyHeader
        else { return nil }

        let options: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: NSNumber(value: data.count * 8),
            kSecReturnPersistentRef: true
        ]
        
        return SecKeyCreateWithData(data as CFData, options as CFDictionary, nil)
    }
}
#endif
