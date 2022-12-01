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

    /// ReerKit: Returns a uppercase String in HEX.
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

#endif
