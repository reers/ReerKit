//
//  Copyright © 2024 gumob
//  Copyright © 2024 reers.
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

/// Puny class provides methods to encode and decode strings using Punycode (RFC 3492).
/// It allows for the conversion of Unicode strings into ASCII-compatible encoding,
/// which is essential for domain names and other applications that require ASCII representation.
///
/// - Note: This implementation follows the specifications outlined in RFC 3492.
/// - Usage: Create an instance of Puny and call the appropriate methods for encoding or decoding.
class Puny {

    /// Punycode RFC 3492
    /// See https://www.ietf.org/rfc/rfc3492.txt for standard details

    /// Base value for Punycode encoding, representing the number of valid characters.
    private let base: Int = 36

    /// Minimum threshold for the number of characters to be encoded.
    private let tMin: Int = 1

    /// Maximum threshold for the number of characters to be encoded.
    private let tMax: Int = 26

    /// Skew value used in the adaptation of the bias.
    private let skew: Int = 38

    /// Damping factor used in the adaptation of the bias.
    private let damp: Int = 700

    /// Initial bias value for the encoding process.
    private let initialBias: Int = 72

    /// Initial value for the encoded characters.
    private let initialN: Int = 128

    /// Delimiter used in Punycode encoding to separate encoded segments. (RFC 3492 specific)
    private let delimiter: Character = "-"

    /// Range of lowercase letters used in Punycode encoding.
    private let lowercase: ClosedRange<Character> = "a"..."z"

    /// Range of digits used in Punycode encoding.
    private let digits: ClosedRange<Character> = "0"..."9"

    /// Base value for lowercase letters in Unicode scalar representation.
    private let lettersBase: UInt32 = Character("a").unicodeScalars.first!.value

    /// Base value for digits in Unicode scalar representation.
    private let digitsBase: UInt32 = Character("0").unicodeScalars.first!.value

    /// IDNA
    private let ace: String = "xn--"

    /// Adjusts the bias for Punycode encoding based on the given delta and number of points.
    /// This function is used to adapt the bias during the encoding process to ensure proper
    /// distribution of encoded characters.
    ///
    /// - Parameters:
    ///   - delta: The value to be adjusted.
    ///   - numberOfPoints: The number of points to consider for the adjustment.
    ///   - firstTime: A boolean indicating if this is the first adjustment.
    /// - Returns: The adjusted bias value as an integer.
    private func adaptBias(_ delta: Int, _ numberOfPoints: Int, _ firstTime: Bool) -> Int {
        var delta: Int = delta
        if firstTime {
            delta /= damp
        } else {
            delta /= 2
        }
        delta += delta / numberOfPoints
        var k: Int = 0
        while delta > ((base - tMin) * tMax) / 2 {
            delta /= base - tMin
            k += base
        }
        return k + ((base - tMin + 1) * delta) / (delta + skew)
    }

    /// Maps a punycode character to its corresponding index.
    ///
    /// - Parameter character: The punycode character to be mapped.
    /// - Returns: The index of the character if it is a valid punycode character; otherwise, nil.
    private func punycodeIndex(for character: Character) -> Int? {
        if lowercase.contains(character) {
            return Int(character.unicodeScalars.first!.value - lettersBase)
        } else if digits.contains(character) {
            return Int(character.unicodeScalars.first!.value - digitsBase) + 26/// count of lowercase letters range
        } else {
            return nil
        }
    }

    /// Maps an index to its corresponding punycode character.
    ///
    /// - Parameter digit: The integer digit to be mapped.
    /// - Returns: The corresponding punycode character if the digit is valid; otherwise, nil.
    private func punycodeValue(for digit: Int) -> Character? {
        guard digit < base else { return nil }
        if digit < 26 {
            return Character(UnicodeScalar(lettersBase.advanced(by: digit))!)
        } else {
            return Character(UnicodeScalar(digitsBase.advanced(by: digit - 26))!)
        }
    }

    /// Decodes a punycode encoded string to its original representation.
    ///
    /// - Parameter punycode: A substring containing the punycode encoding (RFC 3492).
    /// - Returns: The decoded original string or nil if the input cannot be decoded due to invalid formatting.
    func decodePunycode(_ punycode: Substring) -> String? {
        var n: Int = initialN
        var i: Int = 0
        var bias: Int = initialBias
        var output: [Character] = []
        var inputPosition: Substring.Index = punycode.startIndex

        let delimiterPosition: Substring.Index = punycode.lastIndex(of: delimiter) ?? punycode.startIndex
        if delimiterPosition > punycode.startIndex {
            output.append(contentsOf: punycode[..<delimiterPosition])
            inputPosition = punycode.index(after: delimiterPosition)
        }
        var punycodeInput: Substring = punycode[inputPosition..<punycode.endIndex]
        while !punycodeInput.isEmpty {
            let oldI: Int = i
            var w: Int = 1
            var k: Int = base
            repeat {
                let character: Character = punycodeInput.removeFirst()
                guard let digit: Int = punycodeIndex(for: character) else {
                    return nil/// Failing on badly formatted punycode
                }
                i += digit * w
                let t: Int = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias)
                if digit < t {
                    break
                }
                w *= base - t
                k += base
            } while !punycodeInput.isEmpty
            bias = adaptBias(i - oldI, output.count + 1, oldI == 0)
            n += i / (output.count + 1)
            i %= (output.count + 1)
            guard n >= 0x80, let scalar: Unicode.Scalar = UnicodeScalar(n) else {
                return nil
            }
            output.insert(Character(scalar), at: i)
            i += 1
        }

        return String(output)
    }

    /// Encodes a substring to punycode (RFC 3492).
    ///
    /// - Parameter input: A substring to be encoded in punycode.
    /// - Returns: A punycode encoded string or nil if the input contains invalid characters.
    func encodePunycode(_ input: Substring) -> String? {
        var n: Int = initialN
        var delta: Int = 0
        var bias: Int = initialBias
        var output: String = ""
        for scalar: Substring.UnicodeScalarView.Element in input.unicodeScalars {
            if scalar.isASCII {
                let char: Character = Character(scalar)
                output.append(char)
            } else if !scalar.isValid {
                return nil/// Encountered a scalar out of acceptable range
            }
        }
        var handled: Int = output.count
        let basic: Int = handled
        if basic > 0 {
            output.append(delimiter)
        }
        while handled < input.unicodeScalars.count {
            var minimumCodepoint: Int = 0x10FFFF
            for scalar: Unicode.Scalar in input.unicodeScalars {
                if scalar.value < minimumCodepoint && scalar.value >= n {
                    minimumCodepoint = Int(scalar.value)
                }
            }
            delta += (minimumCodepoint - n) * (handled + 1)
            n = minimumCodepoint
            for scalar: Unicode.Scalar in input.unicodeScalars {
                if scalar.value < n {
                    delta += 1
                } else if scalar.value == n {
                    var q: Int = delta
                    var k: Int = base
                    while true {
                        let t: Int = k <= bias ? tMin : (k >= bias + tMax ? tMax : k - bias)
                        if q < t {
                            break
                        }
                        guard let character: Character = punycodeValue(for: t + ((q - t) % (base - t))) else { return nil }
                        output.append(character)
                        q = (q - t) / (base - t)
                        k += base
                    }
                    guard let character: Character = punycodeValue(for: q) else { return nil }
                    output.append(character)
                    bias = adaptBias(delta, handled + 1, handled == basic)
                    delta = 0
                    handled += 1
                }
            }
            delta += 1
            n += 1
        }

        return output
    }

    /// Returns new string containing IDNA-encoded hostname.
    ///
    /// - Parameter input: The Substring to be encoded.
    /// - Returns: An IDNA encoded hostname or nil if the string can't be encoded.
    func encodeIDNA(_ input: Substring) -> String? {
        let parts: [Substring] = input.split(separator: ".")
        var output: String = ""
        for part: Substring in parts {
            if output.count > 0 {
                output.append(".")
            }
            if part.rangeOfCharacter(from: CharacterSet.urlHostAllowed.inverted) != nil {
                guard let encoded: String = part.lowercased().re.punycodeEncoded else { return nil }
                output += ace + encoded
            } else {
                output += part
            }
        }
        return output
    }

    /// Returns a new string containing the hostname decoded from IDNA representation.
    ///
    /// - Parameter input: The Substring to be decoded.
    /// - Returns: The original hostname or nil if the string doesn't contain correct encoding.
    func decodedIDNA(_ input: Substring) -> String? {
        let parts: [Substring] = input.split(separator: ".")
        var output: String = ""
        for part: Substring in parts {
            if output.count > 0 {
                output.append(".")
            }
            if part.hasPrefix(ace) {
                guard let decoded: String = Puny().decodePunycode(part.dropFirst(ace.count)) else { return nil }
                output += decoded
            } else {
                output += part
            }
        }
        return output
    }
}

/// Returns the last index of the specified element in the substring.
///
/// - Parameter element: The character to search for.
/// - Returns: The index of the last occurrence of the character, or nil if the character is not found.
extension Substring {
    internal func lastIndex(of element: Character) -> String.Index? {
        var position: Index = endIndex
        while position > startIndex {
            position = self.index(before: position)
            if self[position] == element {
                return position
            }
        }
        return nil
    }
}

/// A computed property that checks if the Unicode scalar is valid.
///
/// - Returns: A boolean value indicating whether the Unicode scalar is valid.
///   A Unicode scalar is considered valid if its value is less than 0xD880
///   or within the range of 0xE000 to 0x1FFFFF.
extension UnicodeScalar {
    internal var isValid: Bool {
        return value < 0xD880 || (value >= 0xE000 && value <= 0x1FFFFF)
    }
}
#endif
