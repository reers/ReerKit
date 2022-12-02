//
//  Copyright © 2020 SwifterSwift
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

#if canImport(Foundation)
import Foundation

#if canImport(CommonCrypto)
import CommonCrypto
#endif

#if canImport(zlib)
import zlib
#endif

// MARK: - Initializer

public extension Data {

    /// ReerKit: Convert hex string to Data.
    static func re(hexString: String) -> Data? {
        var data = Data(capacity: hexString.count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: hexString, options: .reportProgress, range: NSMakeRange(0, hexString.utf16.count)) { match, flags, stop in
            let byteString = hexString.re[safe: (match?.range.lowerBound)!..<(match?.range.upperBound)!]
            var num = UInt8(byteString!, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else {
            return nil
        }
        return data
    }

    /// ReerKit: Create a data from a file in bundle.
    static func re(fileName: String, inBundle bundle: Bundle = .main) -> Data? {
        guard let url = bundle.url(forResource: fileName, withExtension: "") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}

// MARK: - Convert to `String`, `Dictionary`, `Array`

public enum JSONError: Error {
    case invalidDict
    case invalidArray
}

public extension ReerForEquatable where Base == Data {
    /// ReerKit: Return data as an array of bytes.
    var bytes: [UInt8] {
        return [UInt8](base)
    }

    /// ReerKit: Returns string decoded in UTF8.
    var utf8String: String? {
        return String(data: base, encoding: .utf8)
    }

    /// ReerKit: String by encoding Data using the given encoding (if applicable).
    ///
    /// - Parameter encoding: encoding.
    /// - Returns: String by encoding Data using the given encoding (if applicable).
    func string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: base, encoding: encoding)
    }

    /// ReerKit: Returns a lowercase String in hex.
    var hexString: String? {
        return base.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }

    /// ReerKit: Returns an Dictionary or Array for decoded self.
    /// Returns nil if an error occurs.
    /// - Returns: an Dictionary or Array for decoded self.
    var jsonValue: Any? {
        return try? JSONSerialization.jsonObject(with: base, options: [])
    }

    /// ReerKit: Returns a Foundation object from given JSON data.
    ///
    /// - Parameter options: Options for reading the JSON data and creating the Foundation object.
    ///
    ///   For possible values, see `JSONSerialization.ReadingOptions`.
    /// - Throws: An `NSError` if the receiver does not represent a valid JSON object.
    /// - Returns: A Foundation object from the JSON data in the receiver, or `nil` if an error occurs.
    func jsonValue(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: base, options: options)
    }

    /// ReerKit: Returns an Dictionary for decoded self.
    /// Returns nil if an error occurs.
    var dictionary: [AnyHashable: Any]? {
        return try? toDictionary()
    }

    /// ReerKit: Returns [String: String] for decoded self.
    /// Returns nil if an error occurs.
    var stringDictionary: [String: String]? {
        return try? toDictionary() as? [String: String]
    }

    /// ReerKit: Returns an Dictionary for decoded self.
    func toDictionary() throws -> [AnyHashable: Any] {
        if let value = jsonValue, let dictionary = value as? [AnyHashable: Any] {
            return dictionary
        } else {
            throw JSONError.invalidDict
        }
    }

    /// ReerKit: Returns an Array for decoded self.
    /// Returns nil if an error occurs.
    var array: [Any]? {
        return try? toArray()
    }

    /// ReerKit: Returns an Array for decoded self.
    func toArray() throws -> [Any] {
        if let value = jsonValue, let array = value as? [Any] {
            return array
        } else {
            throw JSONError.invalidArray
        }
    }
}

#if canImport(CommonCrypto)

// MARK: - Hash

public extension ReerForEquatable where Base == Data {
    /// ReerKit: Returns an Data for md2 hash.
    var md2Data: Data? {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD2_DIGEST_LENGTH))
        _ = base.withUnsafeBytes { messageBytes in
            CC_MD2(messageBytes.baseAddress, CC_LONG(base.count), &digest)
        }
        return Data(digest)
    }

    /// ReerKit: Returns a lowercase String for md2 hash.
    var md2String: String? {
        return md2Data?.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }

    /// ReerKit: Returns an Data for md4 hash.
    var md4Data: Data? {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD4_DIGEST_LENGTH))
        _ = base.withUnsafeBytes { messageBytes in
            CC_MD4(messageBytes.baseAddress, CC_LONG(base.count), &digest)
        }
        return Data(digest)
    }

    /// ReerKit: Returns a lowercase String for md4 hash.
    var md4String: String? {
        return md4Data?.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }

    /// ReerKit: Returns an Data for md5 hash.
    var md5Data: Data? {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = base.withUnsafeBytes { messageBytes in
            CC_MD5(messageBytes.baseAddress, CC_LONG(base.count), &digest)
        }
        return Data(digest)
    }

    /// ReerKit: Returns a lowercase String for md5 hash.
    var md5String: String? {
        return md5Data?.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }

    /// ReerKit: Returns an Data for sha1 hash.
    var sha1Data: Data? {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        _ = base.withUnsafeBytes { messageBytes in
            CC_SHA1(messageBytes.baseAddress, CC_LONG(base.count), &digest)
        }
        return Data(digest)
    }

    /// ReerKit: Returns a lowercase String for sha1 hash.
    var sha1String: String? {
        return sha1Data?.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }

    /// ReerKit: Returns an Data for sha224 hash.
    var sha224Data: Data? {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH))
        _ = base.withUnsafeBytes { messageBytes in
            CC_SHA224(messageBytes.baseAddress, CC_LONG(base.count), &digest)
        }
        return Data(digest)
    }

    /// ReerKit: Returns a lowercase String for sha224 hash.
    var sha224String: String? {
        return sha224Data?.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }

    /// ReerKit: Returns an Data for sha256 hash.
    var sha256Data: Data? {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = base.withUnsafeBytes { messageBytes in
            CC_SHA256(messageBytes.baseAddress, CC_LONG(base.count), &digest)
        }
        return Data(digest)
    }

    /// ReerKit: Returns a lowercase String for sha256 hash.
    var sha256String: String? {
        return sha256Data?.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }

    /// ReerKit: Returns an Data for sha384 hash.
    var sha384Data: Data? {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH))
        _ = base.withUnsafeBytes { messageBytes in
            CC_SHA384(messageBytes.baseAddress, CC_LONG(base.count), &digest)
        }
        return Data(digest)
    }

    /// ReerKit: Returns a lowercase String for sha384 hash.
    var sha384String: String? {
        return sha384Data?.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }

    /// ReerKit: Returns an Data for sha512 hash.
    var sha512Data: Data? {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        _ = base.withUnsafeBytes { messageBytes in
            CC_SHA512(messageBytes.baseAddress, CC_LONG(base.count), &digest)
        }
        return Data(digest)
    }

    /// ReerKit: Returns a lowercase String for sha512 hash.
    var sha512String: String? {
        return sha512Data?.reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }
}

// MARK: - HMAC (hash-based message authentication code)

public enum HMACAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512

    fileprivate var digestLenght: Int {
        var result: Int32 = 0
        switch self {
        case .md5:      result = CC_MD5_DIGEST_LENGTH
        case .sha1:     result = CC_SHA1_DIGEST_LENGTH
        case .sha224:   result = CC_SHA224_DIGEST_LENGTH
        case .sha256:   result = CC_SHA256_DIGEST_LENGTH
        case .sha384:   result = CC_SHA384_DIGEST_LENGTH
        case .sha512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }

    fileprivate var ccHMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .md5:      result = kCCHmacAlgMD5
        case .sha1:     result = kCCHmacAlgSHA1
        case .sha224:   result = kCCHmacAlgSHA224
        case .sha256:   result = kCCHmacAlgSHA256
        case .sha384:   result = kCCHmacAlgSHA384
        case .sha512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
}

public extension ReerForEquatable where Base == Data {

    /// ReerKit: Returns a lowercase String for hmac using the algorithm with key.
    /// - Parameters:
    ///   - alg: HMAC algorithm.
    ///   - key: The hmac key.
    /// - Returns: HMAC handled string.
    func hmacString(using alg: HMACAlgorithm, key: String) -> String? {
        var digest = [UInt8](repeating: 0, count: alg.digestLenght)
        guard let cKey = key.cString(using: .utf8) else { return nil }
        let keyLength = key.lengthOfBytes(using: .utf8)
        base.withUnsafeBytes { messageBytes in
            CCHmac(alg.ccHMACAlgorithm, cKey, keyLength, messageBytes.baseAddress, base.count, &digest)
        }
        return Data(digest).reduce("") {
            $0 + String(format:"%02x", $1)
        }
    }

    /// ReerKit: Returns a Data for hmac using the algorithm with key.
    /// - Parameters:
    ///   - alg: HMAC algorithm.
    ///   - key: The hmac key.
    /// - Returns: HMAC handled data.
    func hmacData(using alg: HMACAlgorithm, key: String) -> Data? {
        var digest = [UInt8](repeating: 0, count: alg.digestLenght)
        guard let cKey = key.cString(using: .utf8) else { return nil }
        let keyLength = key.lengthOfBytes(using: .utf8)
        base.withUnsafeBytes { messageBytes in
            CCHmac(alg.ccHMACAlgorithm, cKey, keyLength, messageBytes.baseAddress, base.count, &digest)
        }
        return Data(digest)
    }
}

// MARK: - Crypto

public extension ReerForEquatable where Base == Data {
    /// ReerKit: Returns an encrypted Data using AES.
    ///
    /// - Parameters:
    ///   - key: A key length of 16, 24 or 32 (128, 192 or 256bits).
    ///   - iv: An initialization vector length of 16(128bits).
    /// - Returns: A Data encrypted, or nil if an error occurs.
    func aesEncrypt(withKey key: Data, iv: Data = .init()) -> Data? {
        guard key.count == 16 || key.count == 24 || key.count == 32 else {
            return nil
        }
        guard iv.count == 16 || iv.count == 0 else {
            return nil
        }

        let cryptLength  = Int(base.count + kCCBlockSizeAES128)
        var result = Data(count:cryptLength)
        let keyLength = size_t(kCCKeySizeAES128)
        var encryptedSize: size_t = 0

        let cryptStatus = result.withUnsafeMutableBytes { cryptBytes in
            base.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(
                            CCOperation(kCCEncrypt),
                            CCAlgorithm(kCCAlgorithmAES128),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress!,
                            keyLength,
                            ivBytes.baseAddress!,
                            dataBytes.baseAddress!,
                            base.count,
                            cryptBytes.baseAddress!,
                            cryptLength,
                            &encryptedSize
                        )
                    }
                }
            }
        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            result.removeSubrange(encryptedSize..<result.count)
            return result
        } else {
            debugPrint("Error: \(cryptStatus)")
            return nil
        }
    }

    /// ReerKit: Returns an decrypted Data using AES.
    ///
    /// - Parameters:
    ///   - key: A key length of 16, 24 or 32 (128, 192 or 256bits).
    ///   - iv: An initialization vector length of 16(128bits).
    /// - Returns: An Data decrypted, or nil if an error occurs.
    func aesDecrypt(withKey key: Data, iv: Data = .init()) -> Data? {
        guard key.count == 16 || key.count == 24 || key.count == 32 else {
            return nil
        }
        guard iv.count == 16 || iv.count == 0 else {
            return nil
        }

        let cryptLength  = Int(base.count + kCCBlockSizeAES128)
        var result = Data(count:cryptLength)
        let keyLength = size_t(kCCKeySizeAES128)
        var encryptedSize: size_t = 0

        let cryptStatus = result.withUnsafeMutableBytes { cryptBytes in
            base.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(
                            CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES128),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress!,
                            keyLength,
                            ivBytes.baseAddress!,
                            dataBytes.baseAddress!,
                            base.count,
                            cryptBytes.baseAddress!,
                            cryptLength,
                            &encryptedSize
                        )
                    }
                }
            }
        }

        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            result.removeSubrange(encryptedSize..<result.count)
            return result
        } else {
            debugPrint("Error: \(cryptStatus)")
            return nil
        }
    }
}
#endif

#if canImport(zlib)

// MARK: - Compression

// Reference: https://github.com/1024jp/GzipSwift

/// ReerKit: Compression level whose rawValue is based on the zlib's constants.
public struct CompressionLevel: RawRepresentable {

    /// Compression level in the range of `0` (no compression) to `9` (maximum compression).
    public let rawValue: Int32
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }

    public static let noCompression = Self(rawValue: Z_NO_COMPRESSION)
    public static let bestSpeed = Self(rawValue: Z_BEST_SPEED)
    public static let bestCompression = Self(rawValue: Z_BEST_COMPRESSION)
    public static let defaultCompression = Self(rawValue: Z_DEFAULT_COMPRESSION)
}

public extension ReerForEquatable where Base == Data {

    /// ReerKit: Whether the receiver is compressed in gzip format.
    var isGzipped: Bool {
        return base.starts(with: [0x1f, 0x8b])
    }

    /// ReerKit: Whether the receiver is compressed in zlib format.
    var isZlibbed: Bool {
        return base.starts(with: [0x78, 0x9c])
            || base.starts(with: [0x78, 0xda])
            || base.starts(with: [0x78, 0x01])
            || base.starts(with: [0x78, 0x5e])
    }

    private struct DataSize {
        static let chunk = Int(pow(2.0, 14))
        static let stream = MemoryLayout<z_stream>.size
    }

    /// ReerKit: Comperss data to zlib-compressed in default compresssion level.
    ///
    /// - Returns: Compressed data.
    func zlibCompressed(level: CompressionLevel = .defaultCompression) -> Data? {
        guard !base.isEmpty else { return base }

        var stream = z_stream()
        var status: Int32

        status = deflateInit_(&stream, level.rawValue, ZLIB_VERSION, Int32(DataSize.stream))
        guard status == Z_OK else { return nil }

        var data = Data(capacity: DataSize.chunk)

        repeat {
            if Int(stream.total_out) >= data.count {
                data.count += DataSize.chunk
            }

            let inputCount = base.count
            let outputCount = data.count

            base.withUnsafeBytes { (inputPointer: UnsafeRawBufferPointer) in
                stream.next_in = UnsafeMutablePointer<Bytef>(
                    mutating: inputPointer.bindMemory(to: Bytef.self).baseAddress!
                )
                .advanced(by: Int(stream.total_in))

                stream.avail_in = uint(inputCount) - uInt(stream.total_in)
                data.withUnsafeMutableBytes { (outputPointer: UnsafeMutableRawBufferPointer) in
                    stream.next_out = outputPointer
                        .bindMemory(to: Bytef.self).baseAddress!
                        .advanced(by: Int(stream.total_out))
                    stream.avail_out = uInt(outputCount) - uInt(stream.total_out)
                    status = deflate(&stream, Z_FINISH)
                    stream.next_out = nil
                }
                stream.next_in = nil
            }
        } while stream.avail_out == 0

        guard deflateEnd(&stream) == Z_OK, status == Z_STREAM_END else { return nil }

        data.count = Int(stream.total_out)
        return data
    }

    /// ReerKit: Decompress data from zlib-compressed data.
    ///
    /// - Returns: Decompressed data.
    func zlibDecompressed() -> Data? {
        guard !base.isEmpty else { return base }

        var stream = z_stream()
        var status: Int32

        status = inflateInit_(&stream, ZLIB_VERSION, Int32(DataSize.stream))
        guard status == Z_OK else { return nil }

        var data = Data(capacity: base.count * 2)
        repeat {
            if Int(stream.total_out) >= data.count {
                data.count += base.count / 2
            }

            let inputCount = base.count
            let outputCount = data.count

            base.withUnsafeBytes { (inputPointer: UnsafeRawBufferPointer) in
                stream.next_in = UnsafeMutablePointer<Bytef>(
                    mutating: inputPointer.bindMemory(to: Bytef.self).baseAddress!
                )
                .advanced(by: Int(stream.total_in))
                stream.avail_in = uint(inputCount) - uInt(stream.total_in)

                data.withUnsafeMutableBytes { (outputPointer: UnsafeMutableRawBufferPointer) in
                    stream.next_out = outputPointer
                        .bindMemory(to: Bytef.self).baseAddress!
                        .advanced(by: Int(stream.total_out))
                    stream.avail_out = uInt(outputCount) - uInt(stream.total_out)
                    status = inflate(&stream, Z_SYNC_FLUSH)
                    stream.next_out = nil
                }
                stream.next_in = nil
            }

        } while status == Z_OK

        guard inflateEnd(&stream) == Z_OK, status == Z_STREAM_END else { return nil }

        data.count = Int(stream.total_out)
        return data
    }

    /// ReerKit: Compress data to gzip in default compresssion level.
    ///
    /// - Returns: Compressed data.
    func gzipCompressed(level: CompressionLevel = .defaultCompression) -> Data? {
        guard !base.isEmpty else { return base }

        var stream = z_stream()
        var status: Int32
        status = deflateInit2_(
            &stream,
            level.rawValue,
            Z_DEFLATED,
            MAX_WBITS + 16,
            MAX_MEM_LEVEL,
            Z_DEFAULT_STRATEGY,
            ZLIB_VERSION,
            Int32(DataSize.stream)
        )

        guard status == Z_OK else { return nil }

        var data = Data(capacity: DataSize.chunk)

        repeat {
            if Int(stream.total_out) >= data.count {
                data.count += DataSize.chunk
            }

            let inputCount = base.count
            let outputCount = data.count

            base.withUnsafeBytes { (inputPointer: UnsafeRawBufferPointer) in
                stream.next_in = UnsafeMutablePointer<Bytef>(
                    mutating: inputPointer.bindMemory(to: Bytef.self).baseAddress!
                )
                .advanced(by: Int(stream.total_in))
                stream.avail_in = uint(inputCount) - uInt(stream.total_in)
                data.withUnsafeMutableBytes { (outputPointer: UnsafeMutableRawBufferPointer) in
                    stream.next_out = outputPointer
                        .bindMemory(to: Bytef.self).baseAddress!
                        .advanced(by: Int(stream.total_out))
                    stream.avail_out = uInt(outputCount) - uInt(stream.total_out)
                    status = deflate(&stream, Z_FINISH)
                    stream.next_out = nil
                }
                stream.next_in = nil
            }
        } while stream.avail_out == 0

        guard deflateEnd(&stream) == Z_OK, status == Z_STREAM_END else { return nil }

        data.count = Int(stream.total_out)
        return data
    }

    /// ReerKit: Decompress data from gzip data.
    ///
    /// - Returns: Decompressed data.
    func gzipDecompressed() -> Data? {
        guard !base.isEmpty else { return base }

        var stream = z_stream()
        var status: Int32

        status = inflateInit2_(&stream, MAX_WBITS + 32, ZLIB_VERSION, Int32(DataSize.stream))

        guard status == Z_OK else { return nil }

        var data = Data(capacity: base.count * 2)
        repeat {
            if Int(stream.total_out) >= data.count {
                data.count += base.count / 2
            }

            let inputCount = base.count
            let outputCount = data.count

            base.withUnsafeBytes { (inputPointer: UnsafeRawBufferPointer) in
                stream.next_in = UnsafeMutablePointer<Bytef>(
                    mutating: inputPointer.bindMemory(to: Bytef.self).baseAddress!
                )
                .advanced(by: Int(stream.total_in))
                stream.avail_in = uint(inputCount) - uInt(stream.total_in)
                data.withUnsafeMutableBytes { (outputPointer: UnsafeMutableRawBufferPointer) in
                    stream.next_out = outputPointer
                        .bindMemory(to: Bytef.self).baseAddress!
                        .advanced(by: Int(stream.total_out))
                    stream.avail_out = uInt(outputCount) - uInt(stream.total_out)
                    status = inflate(&stream, Z_SYNC_FLUSH)
                    stream.next_out = nil
                }
                stream.next_in = nil
            }

        } while status == Z_OK

        guard inflateEnd(&stream) == Z_OK, status == Z_STREAM_END else { return nil }

        data.count = Int(stream.total_out)
        return data
    }
}
#endif

#endif
