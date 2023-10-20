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
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

#if canImport(CommonCrypto)
import CommonCrypto
#endif

// MARK: - Nonmutating

public extension Reer where Base == String {
    #if canImport(Foundation)
    /// ReerKit: Returns an Data using UTF-8 encoding.
    var utf8Data: Data? {
        return base.data(using: .utf8)
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: String decoded from base64 (if applicable).
    ///
    ///        "SGVsbG8gV29ybGQh".re.base64Decoded = Optional("Hello World!")
    ///
    var base64Decoded: String? {
        if let data = Data(base64Encoded: base, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }

        let remainder = base.count % 4

        var padding = ""
        if remainder > 0 {
            padding = String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: base + padding, options: .ignoreUnknownCharacters) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// ReerKit: `Data` decoded from base64 (if applicable).
    var base64DecodedData: Data? {
        if let data = Data(base64Encoded: base, options: .ignoreUnknownCharacters) {
            return data
        }

        let remainder = base.count % 4

        var padding = ""
        if remainder > 0 {
            padding = String(repeating: "=", count: 4 - remainder)
        }

        return Data(base64Encoded: base + padding, options: .ignoreUnknownCharacters)
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: String encoded in base64 (if applicable).
    ///
    ///        "Hello World!".re.base64Encoded -> Optional("SGVsbG8gV29ybGQh")
    ///
    var base64Encoded: String? {
        let plainData = base.data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    #endif

    /// ReerKit: Array of characters of a string.
    var characters: [Character] {
        return Array(base)
    }

    #if canImport(Foundation)
    /// ReerKit: CamelCase of string.
    ///
    ///        "sOme vAriable naMe".re.camelCased -> "someVariableName"
    ///
    var camelCased: String {
        let source = base.lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }
    #endif

    /// ReerKit: Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".re.containEmoji -> true
    ///
    var containEmoji: Bool {
        for scalar in base.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF, // Transport and Map
                 0x1F1E6...0x1F1FF, // Regional country flags
                 0x2600...0x26FF, // Misc symbols
                 0x2700...0x27BF, // Dingbats
                 0xE0020...0xE007F, // Tags
                 0xFE00...0xFE0F, // Variation Selectors
                 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                 127_000...127_600, // Various asian characters
                 65024...65039, // Variation selector
                 9100...9300, // Misc items
                 8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    #if canImport(Foundation)
    /// ReerKit: Check if string contains one or more letters.
    ///
    ///        "123abc".re.hasLetters -> true
    ///        "123".re.hasLetters -> false
    ///
    var hasLetters: Bool {
        return base.rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Check if string contains one or more digits.
    ///
    ///        "abcd".re.hasDigits -> false
    ///        "123abc".re.hasDigits -> true
    ///
    var hasDigits: Bool {
        return base.rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Check if string only contains letters.
    ///
    ///     "abc".re.hasLettersOnly -> true
    ///     "123abc".re.hasLettersOnly -> false
    ///
    var hasLettersOnly: Bool {
        return !base.isEmpty && CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: base))
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Check if string only contains digits.
    ///
    ///     "123".re.hasDigitsOnly -> true
    ///     "1.3".re.hasDigitsOnly -> false
    ///     "abc".re.hasDigitsOnly -> false
    ///
    var hasDigitsOnly: Bool {
        return !base.isEmpty && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: base))
    }
    #endif

    /// ReerKit: Check if string is palindrome.
    ///
    ///     "abcdcba".re.isPalindrome -> true
    ///     "Mom".re.isPalindrome -> true
    ///     "A man a plan a canal, Panama!".re.isPalindrome -> true
    ///     "Mama".re.isPalindrome -> false
    ///
    var isPalindrome: Bool {
        let letters = base.filter { $0.isLetter }
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex..<midIndex]
        let secondHalf = letters[midIndex..<letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }

    #if canImport(Foundation)
    /// ReerKit: Check if string is valid email format.
    ///
    /// - Note: Note that this property does not validate the email address against an email server. It merely attempts to determine whether its format is suitable     for an email address.
    ///
    ///        "john@doe.com".re.isValidEmail -> true
    ///
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return base.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Check if string is a valid URL.
    ///
    ///        "https://google.com".re.isValidUrl -> true
    ///
    var isValidUrl: Bool {
        return URL.re(string: base) != nil
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Check if string is a valid schemed URL.
    ///
    ///        "https://google.com".re.isValidSchemedUrl -> true
    ///        "google.com".re.isValidSchemedUrl -> false
    ///
    var isValidSchemedUrl: Bool {
        guard let url = URL.re(string: base) else { return false }
        return url.scheme != nil
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Check if string is a valid https URL.
    ///
    ///        "https://google.com".re.isValidHttpsUrl -> true
    ///
    var isValidHttpsUrl: Bool {
        guard let url = URL.re(string: base) else { return false }
        return url.scheme == "https"
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Check if string is a valid http URL.
    ///
    ///        "http://google.com".re.isValidHttpUrl -> true
    ///
    var isValidHttpUrl: Bool {
        guard let url = URL.re(string: base) else { return false }
        return url.scheme == "http"
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Check if string is a valid file URL.
    ///
    ///        "file://Documents/file.txt".re.isValidFileUrl -> true
    ///
    var isValidFileUrl: Bool {
        return URL.re(string: base)?.isFileURL ?? false
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Latinized string.
    ///
    ///        "Hèllö Wórld!".re.latinized -> "Hello World!"
    ///
    var latinized: String {
        return base.folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    #endif

    /// ReerKit: First character of string (if applicable).
    ///
    ///        "Hello".re.firstCharacterAsString -> Optional("H")
    ///        "".re.firstCharacterAsString -> nil
    ///
    var firstCharacterAsString: String? {
        guard let first = base.first else { return nil }
        return String(first)
    }

    /// ReerKit: Last character of string (if applicable).
    ///
    ///        "Hello".re.lastCharacterAsString -> Optional("o")
    ///        "".re.lastCharacterAsString -> nil
    ///
    var lastCharacterAsString: String? {
        guard let last = base.last else { return nil }
        return String(last)
    }

    /// ReerKit: Bool value from string (if applicable).
    ///
    ///        "1".re.bool -> true
    ///        "False".re.bool -> false
    ///        "Hello".re.bool = nil
    ///
    var bool: Bool? {
        return base~!.re.bool
    }

    /// ReerKit: Integer value from string (if applicable).
    ///
    ///        "101".re.int -> 101
    ///
    var int: Int? {
        return Int(base)
    }

    #if canImport(Foundation)
    /// ReerKit: Float value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Float value from given string.
    func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: base)?.floatValue
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Double value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Double value from given string.
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: base)?.doubleValue
    }
    #endif

    #if canImport(CoreGraphics) && canImport(Foundation)
    /// ReerKit: CGFloat value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional CGFloat value from given string.
    func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: base) as? CGFloat
    }
    #endif

    #if canImport(Foundation)
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    /// ReerKit: Date object from "yyyy-MM-dd" formatted string.
    ///
    ///        "2007-06-29".re.date -> Optional(Date)
    ///
    var date: Date? {
        let selfLowercased = base.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return Self.dateFormatter.date(from: selfLowercased)
    }
    #endif

    #if canImport(Foundation)
    private static var dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    /// ReerKit: Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
    ///
    ///        "2007-06-29 14:23:09".re.dateTime -> Optional(Date)
    ///
    var dateTime: Date? {
        let selfLowercased = base.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return Self.dateTimeFormatter.date(from: selfLowercased)
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: URL from string (if applicable).
    ///
    ///        "https://google.com".re.url -> URL(string: "https://google.com")
    ///        "not url".re.url -> nil
    ///
    var url: URL? {
        return URL.re(string: base)
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: String with no spaces or new lines in beginning and end.
    ///
    ///        "   hello  \n".re.trimmed -> "hello"
    ///
    var trimmed: String {
        return base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Readable string from a URL string.
    ///
    ///        "it's%20easy%20to%20decode%20strings".re.urlDecoded -> "it's easy to decode strings"
    ///
    var urlDecoded: String {
        return base.removingPercentEncoding ?? base
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: URL escaped string.
    ///
    ///        "it's easy to encode strings".re.urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    var urlEncoded: String {
        return base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Escaped string for inclusion in a regular expression pattern.
    ///
    /// "hello ^$ there" -> "hello \\^\\$ there"
    ///
    var regexEscaped: String {
        return NSRegularExpression.escapedPattern(for: base)
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: String without spaces and new lines.
    ///
    ///        "   \n Swifter   \n  Swift  ".re.withoutSpacesAndNewLines -> "SwifterSwift"
    ///
    var withoutSpacesAndNewLines: String {
        return base.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Check if the given string contains only white spaces.
    var isWhitespace: Bool {
        return base.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    #endif

    #if canImport(Foundation) && canImport(UIKit) && !os(watchOS)
    /// ReerKit: Check if the given string spelled correctly.
    var isSpelledCorrectly: Bool {
        let checker = UITextChecker()
        let range = NSRange(base.startIndex..<base.endIndex, in: base)

        let misspelledRange = checker.rangeOfMisspelledWord(
            in: base,
            range: range,
            startingAt: 0,
            wrap: false,
            language: Locale.preferredLanguages.first ?? "en")
        return misspelledRange.location == NSNotFound
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Array of strings separated by new lines.
    ///
    ///        "Hello\ntest".re.lines() -> ["Hello", "test"]
    ///
    /// - Returns: Strings separated by new lines.
    func lines() -> [String] {
        var result = [String]()
        base.enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".re.localized -> Hallo Welt
    ///
    func localized(comment: String = "") -> String {
        return NSLocalizedString(base, comment: comment)
    }
    #endif

    /// ReerKit: Array with unicodes for all characters in a string.
    ///
    ///        "SwifterSwift".re.unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    /// - Returns: The unicodes for all characters in a string.
    func unicodeArray() -> [Int] {
        return base.unicodeScalars.map { Int($0.value) }
    }

    #if canImport(Foundation)
    /// ReerKit: an array of all words in a string.
    ///
    ///        "Swift is amazing".re.words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: The words contained in a string.
    func words() -> [String] {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = base.components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Count of words in a string.
    ///
    ///        "Swift is amazing".re.wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    func wordCount() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = base.components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Transforms the string into a slug string.
    ///
    ///        "Swift is amazing".re.toSlug() -> "swift-is-amazing"
    ///
    /// - Returns: The string in slug format.
    func toSlug() -> String {
        let lowercased = base.lowercased()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.re.lastCharacterAsString == "-" {
            filtered = String(filtered.dropLast())
        }

        while filtered.re.firstCharacterAsString == "-" {
            filtered = String(filtered.dropFirst())
        }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }
    #endif

    /// ReerKit: Safely subscript string with index.
    ///
    ///        "Hello World!".re[3] -> "l"
    ///        "Hello World!".re[20] -> nil
    ///
    /// - Parameter index: index.
    subscript(index: Int) -> Character? {
        guard index >= 0, index < base.count else { return nil }
        return base[base.index(base.startIndex, offsetBy: index)]
    }

    /// ReerKit: Safely subscript string within a given range.
    ///
    ///        "Hello World!".re[safe: 6..<11] -> "World"
    ///        "Hello World!".re[safe: 21..<110] -> nil
    ///
    ///        "Hello World!".re[safe: 6...11] -> "World!"
    ///        "Hello World!".re[safe: 21...110] -> nil
    ///
    /// - Parameter range: Range expression.
    subscript<R>(range: R) -> String? where R: RangeExpression, R.Bound == Int {
        var base = base
        return base.re[range]
    }

    #if os(iOS) || os(macOS)
    /// ReerKit: Copy string to global pasteboard.
    ///
    ///        "SomeText".re.copyToPasteboard() // copies "SomeText" to pasteboard
    ///
    func copyToPasteboard() {
        #if os(iOS)
        UIPasteboard.general.string = base
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(base, forType: .string)
        #endif
    }
    #endif

    /// ReerKit: Check if string contains only unique characters.
    ///
    func hasUniqueCharacters() -> Bool {
        guard base.count > 0 else { return false }
        var uniqueChars = Set<String>()
        for char in base {
            if uniqueChars.contains(String(char)) { return false }
            uniqueChars.insert(String(char))
        }
        return true
    }

    #if canImport(Foundation)
    /// ReerKit: Check if string contains one or more instance of substring.
    ///
    ///        "Hello World!".re.contain("O") -> false
    ///        "Hello World!".re.contain("o", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return base.range(of: string, options: .caseInsensitive) != nil
        }
        return base.range(of: string) != nil
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Count of substring in string.
    ///
    ///        "Hello World!".re.count(of: "o") -> 2
    ///        "Hello World!".re.count(of: "L", caseSensitive: false) -> 3
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: count of appearance of substring in string.
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return base.lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return base.components(separatedBy: string).count - 1
    }
    #endif

    /// ReerKit: Check if string starts with substring.
    ///
    ///        "hello World".re.starts(with: "h") -> true
    ///        "hello World".re.starts(with: "H", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return base.lowercased().hasPrefix(prefix.lowercased())
        }
        return base.hasPrefix(prefix)
    }

    /// ReerKit: Check if string ends with substring.
    ///
    ///        "Hello World!".re.ends(with: "!") -> true
    ///        "Hello World!".re.ends(with: "WoRld!", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return base.lowercased().hasSuffix(suffix.lowercased())
        }
        return base.hasSuffix(suffix)
    }

    /// ReerKit: Random string of given length.
    ///
    ///        String.re.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    ///
    /// - Parameter length: number of characters in string.
    /// - Returns: random string of given length.
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }

    /// ReerKit: Sliced string from a start index with length.
    ///
    ///        "Hello World".re.slicing(from: 6, length: 5) -> "World"
    ///
    /// - Parameters:
    ///   - index: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World").
    func slicing(from index: Int, length: Int) -> String? {
        var base = base
        guard length >= 0, index >= 0, index < base.count else { return nil }
        guard index.advanced(by: length) <= base.count else {
            return base.re[index..<base.count]
        }
        guard length > 0 else { return "" }
        return base.re[index..<index.advanced(by: length)]
    }

    #if canImport(Foundation)
    /// ReerKit: Date object from string of date format.
    ///
    ///        "2017-01-15".re.date(withFormat: "yyyy-MM-dd") -> Date set to Jan 15, 2017
    ///        "not date string".re.date(withFormat: "yyyy-MM-dd") -> nil
    ///
    /// - Parameter format: date format.
    /// - Returns: Date object from string (if applicable).
    func date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: base)
    }
    #endif

    /// ReerKit: Truncated string (limited to a given number of characters).
    ///
    ///        "This is a very long sentence".re.truncated(toLength: 14) -> "This is a very..."
    ///        "Short sentence".re.truncated(toLength: 14) -> "Short sentence"
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string.
    /// - Returns: truncated string (this is an extr...).
    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 0..<base.count ~= length else { return base }
        return base[base.startIndex..<base.index(base.startIndex, offsetBy: length)] + (trailing ?? "")
    }

    #if canImport(Foundation)
    /// ReerKit: Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: `true` if string matches the pattern.
    func matches(pattern: String) -> Bool {
        return base.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Verify if string matches the regex.
    ///
    /// - Parameters:
    ///   - regex: Regex to verify.
    ///   - options: The matching options to use.
    /// - Returns: `true` if string matches the regex.
    func matches(regex: NSRegularExpression, options: NSRegularExpression.MatchingOptions = []) -> Bool {
        let range = NSRange(base.startIndex..<base.endIndex, in: base)
        return regex.firstMatch(in: base, options: options, range: range) != nil
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Returns a new string in which all occurrences of a regex in a specified range of the receiver are replaced by the template.
    /// - Parameters:
    ///   - regex Regex to replace.
    ///   - template: The template to replace the regex.
    ///   - options: The matching options to use
    ///   - searchRange: The range in the receiver in which to search.
    /// - Returns: A new string in which all occurrences of regex in searchRange of the receiver are replaced by template.
    func replacingOccurrences(
        of regex: NSRegularExpression,
        with template: String,
        options: NSRegularExpression.MatchingOptions = [],
        range searchRange: Range<String.Index>? = nil
    ) -> String {
        let range = NSRange(searchRange ?? base.startIndex..<base.endIndex, in: base)
        return regex.stringByReplacingMatches(in: base, options: options, range: range, withTemplate: template)
    }
    #endif

    /// ReerKit: Returns a string by padding to fit the length parameter size with another string in the start.
    ///
    ///     "hue".re.paddingStart(10) -> "       hue"
    ///     "hue".re.paddingStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameters:
    ///   - length: The target length to pad.
    ///   - string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the start.
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        guard base.count < length else { return base }

        let padLength = length - base.count
        if padLength < string.count {
            return string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)] + base
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)] + base
        }
    }

    /// ReerKit: Returns a string by padding to fit the length parameter size with another string in the end.
    ///
    ///     "hue".re.paddingEnd(10) -> "hue       "
    ///     "hue".re.paddingEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameters:
    ///   - length: The target length to pad.
    ///   - string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the end.
    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard base.count < length else { return base }

        let padLength = length - base.count
        if padLength < string.count {
            return base + string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return base + padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }

    /// ReerKit: Removes given prefix from the string.
    ///
    ///     "Hello, World!".re.removingPrefix("Hello, ") -> "World!"
    ///
    /// - Parameter prefix: Prefix to remove from the string.
    /// - Returns: The string after prefix removing.
    func removingPrefix(_ prefix: String) -> String {
        guard base.hasPrefix(prefix) else { return base }
        return String(base.dropFirst(prefix.count))
    }

    /// ReerKit: Removes given suffix from the string.
    ///
    ///     "Hello, World!".re.removingSuffix(", World!") -> "Hello"
    ///
    /// - Parameter suffix: Suffix to remove from the string.
    /// - Returns: The string after suffix removing.
    func removingSuffix(_ suffix: String) -> String {
        guard base.hasSuffix(suffix) else { return base }
        return String(base.dropLast(suffix.count))
    }

    /// ReerKit: Adds prefix to the string.
    ///
    ///     "www.apple.com".re.withPrefix("https://") -> "https://www.apple.com"
    ///
    /// - Parameter prefix: Prefix to add to the string.
    /// - Returns: The string with the prefix prepended.
    func withPrefix(_ prefix: String) -> String {
        // https://www.hackingwithswift.com/articles/141/8-useful-swift-extensions
        guard !base.hasPrefix(prefix) else { return base }
        return prefix + base
    }
}

// MARK: - Mutating
extension String: ReerReferenceCompatible {}
extension ReerReference where Base == String {

    /// ReerKit: Converts string format to CamelCase.
    ///
    ///        var str = "sOme vaRiabLe Name"
    ///        str.re.camelize()
    ///        print(str) // prints "someVariableName"
    ///
    @discardableResult
    mutating func camelize() -> String {
        let source = base.pointee.lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            base.pointee = first + rest
            return base.pointee
        }
        let rest = String(source.dropFirst())

        base.pointee = first + rest
        return base.pointee
    }

    /// ReerKit: First character of string uppercased(if applicable) while keeping the original string.
    ///
    ///        "hello world".re.firstCharacterUppercased() -> "Hello world"
    ///        "".re.firstCharacterUppercased() -> ""
    ///
    mutating func firstCharacterUppercased() {
        guard let first = base.pointee.first else { return }
        base.pointee = String(first).uppercased() + base.pointee.dropFirst()
    }

    #if canImport(Foundation)
    /// ReerKit: Latinize string.
    ///
    ///        var str = "Hèllö Wórld!"
    ///        str.re.latinize()
    ///        print(str) // prints "Hello World!"
    ///
    @discardableResult
    mutating func latinize() -> String {
        base.pointee = base.pointee.folding(options: .diacriticInsensitive, locale: Locale.current)
        return base.pointee
    }
    #endif

    /// ReerKit: Reverse string.
    @discardableResult
    mutating func reverse() -> String {
        let chars: [Character] = base.pointee.reversed()
        base.pointee = String(chars)
        return base.pointee
    }

    /// ReerKit: Slice given string from a start index with length (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.re.slice(from: 6, length: 5)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - index: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    @discardableResult
    mutating func slice(from index: Int, length: Int) -> String {
        if let str = base.pointee.re.slicing(from: index, length: length) {
            base.pointee = String(str)
        }
        return base.pointee
    }

    /// ReerKit: Slice given string from a start index to an end index (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.re.slice(from: 6, to: 11)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - start: string index the slicing should start from.
    ///   - end: string index the slicing should end at.
    @discardableResult
    mutating func slice(from start: Int, to end: Int) -> String {
        guard end >= start else { return base.pointee }
        if let str = base.pointee.re[start..<end] {
            base.pointee = str
        }
        return base.pointee
    }

    /// ReerKit: Slice given string from a start index (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.re.slice(at: 6)
    ///        print(str) // prints "World"
    ///
    /// - Parameter index: string index the slicing should start from.
    @discardableResult
    mutating func slice(at index: Int) -> String {
        guard index < base.pointee.count else { return base.pointee }
        if let str = base.pointee.re[index..<base.pointee.count] {
            base.pointee = str
        }
        return base.pointee
    }

    #if canImport(Foundation)
    /// ReerKit: Removes spaces and new lines in beginning and end of string.
    ///
    ///        var str = "  \n Hello World \n\n\n"
    ///        str.re.trim()
    ///        print(str) // prints "Hello World"
    ///
    @discardableResult
    mutating func trim() -> String {
        base.pointee = base.pointee.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return base.pointee
    }
    #endif

    /// ReerKit: Truncate string (cut it to a given number of characters).
    ///
    ///        var str = "This is a very long sentence"
    ///        str.re.truncate(toLength: 14)
    ///        print(str) // prints "This is a very..."
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string (default is "...").
    @discardableResult
    mutating func truncate(toLength length: Int, trailing: String? = "...") -> String {
        guard length > 0 else { return base.pointee }
        if base.pointee.count > length {
            let start = base.pointee.startIndex
            base.pointee = base.pointee[start..<base.pointee.index(start, offsetBy: length)] + (trailing ?? "")
        }
        return base.pointee
    }

    #if canImport(Foundation)
    /// ReerKit: Convert URL string to readable string.
    ///
    ///        var str = "it's%20easy%20to%20decode%20strings"
    ///        str.re.urlDecode()
    ///        print(str) // prints "it's easy to decode strings"
    ///
    @discardableResult
    mutating func urlDecode() -> String {
        if let decoded = base.pointee.removingPercentEncoding {
            base.pointee = decoded
        }
        return base.pointee
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Escape string.
    ///
    ///        var str = "it's easy to encode strings"
    ///        str.re.urlEncode()
    ///        print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    @discardableResult
    mutating func urlEncode() -> String {
        if let encoded = base.pointee.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            base.pointee = encoded
        }
        return base.pointee
    }
    #endif

    /// ReerKit: Pad string to fit the length parameter size with another string in the start.
    ///
    ///     "hue".re.padStart(10) -> "       hue"
    ///     "hue".re.padStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameters:
    ///   - length: The target length to pad.
    ///   - string: Pad string. Default is " ".
    @discardableResult
    mutating func padStart(_ length: Int, with string: String = " ") -> String {
        base.pointee = base.pointee.re.paddingStart(length, with: string)
        return base.pointee
    }

    /// ReerKit: Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".padEnd(10) -> "hue       "
    ///   "hue".padEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameters:
    ///   - length: The target length to pad.
    ///   - string: Pad string. Default is " ".
    @discardableResult
    mutating func padEnd(_ length: Int, with string: String = " ") -> String {
        base.pointee = base.pointee.re.paddingEnd(length, with: string)
        return base.pointee
    }
}

// MARK: - Operators

public extension String {
    #if canImport(Foundation)
    /// ReerKit: Overload Swift's 'contains' operator for matching regex pattern.
    ///
    /// - Parameters:
    ///   - lhs: String to check on regex pattern.
    ///   - rhs: Regex pattern to match against.
    /// - Returns: true if string matches the pattern.
    static func ~= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs, options: .regularExpression) != nil
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: Overload Swift's 'contains' operator for matching regex.
    ///
    /// - Parameters:
    ///   - lhs: String to check on regex.
    ///   - rhs: Regex to match against.
    /// - Returns: `true` if there is at least one match for the regex in the string.
    static func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
        let range = NSRange(lhs.startIndex..<lhs.endIndex, in: lhs)
        return rhs.firstMatch(in: lhs, range: range) != nil
    }
    #endif

    /// ReerKit: Repeat string multiple times.
    ///
    ///        'bar' * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: string to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// ReerKit: Repeat string multiple times.
    ///
    ///        3 * 'bar' -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: string to repeat.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}

// MARK: - NSString extensions

#if canImport(Foundation)

public extension Reer where Base == String {
    /// ReerKit: NSString from a string.
    var nsString: NSString {
        return NSString(string: base)
    }

    /// ReerKit: The full `NSRange` of the string.
    var fullNSRange: NSRange { NSRange(base.startIndex..<base.endIndex, in: base) }

    /// ReerKit: NSString lastPathComponent.
    var lastPathComponent: String {
        return (base as NSString).lastPathComponent
    }

    /// ReerKit: NSString pathExtension.
    var pathExtension: String {
        return (base as NSString).pathExtension
    }

    /// ReerKit: NSString deletingLastPathComponent.
    var deletingLastPathComponent: String {
        return (base as NSString).deletingLastPathComponent
    }

    /// ReerKit: NSString deletingPathExtension.
    var deletingPathExtension: String {
        return (base as NSString).deletingPathExtension
    }

    /// ReerKit: NSString pathComponents.
    var pathComponents: [String] {
        return (base as NSString).pathComponents
    }

    /// ReerKit: Convert an `NSRange` into `Range<String.Index>`.
    /// - Parameter nsRange: The `NSRange` within the receiver.
    /// - Returns: The equivalent `Range<String.Index>` of `nsRange` found within the receiving string.
    func range(from nsRange: NSRange) -> Range<Base.Index> {
        guard let range = Range(nsRange, in: base) else { fatalError("Failed to find range \(nsRange) in \(base)") }
        return range
    }

    /// ReerKit: Convert a `Range<String.Index>` into `NSRange`.
    /// - Parameter range: The `Range<String.Index>` within the receiver.
    /// - Returns: The equivalent `NSRange` of `range` found within the receiving string.
    func nsRange(from range: Range<Base.Index>) -> NSRange {
        return NSRange(range, in: base)
    }

    /// ReerKit: NSString appendingPathComponent(str: String).
    ///
    /// - Note: This method only works with file paths (not, for example, string representations of URLs.
    ///   See NSString [appendingPathComponent(_:)](https://developer.apple.com/documentation/foundation/nsstring/1417069-appendingpathcomponent)
    /// - Parameter str: the path component to append to the receiver.
    /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    func appendingPathComponent(_ str: String) -> String {
        return (base as NSString).appendingPathComponent(str)
    }

    /// ReerKit: NSString appendingPathExtension(str: String).
    ///
    /// - Parameter str: The extension to append to the receiver.
    /// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
    func appendingPathExtension(_ str: String) -> String? {
        return (base as NSString).appendingPathExtension(str)
    }

    /// ReerKit: Accesses a contiguous subrange of the collection’s elements.
    /// - Parameter nsRange: A range of the collection’s indices. The bounds of the range must be valid indices of the collection.
    /// - Returns: A slice of the receiving string.
    subscript(bounds: NSRange) -> Substring {
        guard let range = Range(bounds, in: base) else { fatalError("Failed to find range \(bounds) in \(base)") }
        return base[range]
    }
}

#endif

// MARK: - NSAttributedString

#if !os(Linux)

public extension Reer where Base == String {
    
    #if canImport(Foundation)
    /// ReerKit: Add attributes to string.
    /// - Parameter attributes: The attributes for the new attributed string. For a list of attributes that you can include in this dictionary, see NSAttributedString.Key.
    /// - Returns: A attributed string.
    func with(attributes: [NSAttributedString.Key : Any]?) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: base, attributes: attributes)
    }
    #endif
}
#endif

// MARK: - Crypto

#if canImport(CommonCrypto)

public extension Reer where Base == String {
    /// ReerKit: Returns a lowercase String for md2 hash.
    var md2String: String? {
        return utf8Data?.re.md2String
    }

    /// ReerKit: Returns a lowercase String for md4 hash.
    var md4String: String? {
        return utf8Data?.re.md4String
    }

    /// ReerKit: Returns a lowercase String for md5 hash.
    var md5String: String? {
        return utf8Data?.re.md5String
    }

    /// ReerKit: Returns a lowercase String for sha1 hash.
    var sha1String: String? {
        return utf8Data?.re.sha1String
    }

    /// ReerKit: Returns a lowercase String for sha224 hash.
    var sha224String: String? {
        return utf8Data?.re.sha224String
    }

    /// ReerKit: Returns a lowercase String for sha256 hash.
    var sha256String: String? {
        return utf8Data?.re.sha256String
    }

    /// ReerKit: Returns a lowercase String for sha384 hash.
    var sha384String: String? {
        return utf8Data?.re.sha384String
    }

    /// ReerKit: Returns a lowercase String for sha512 hash.
    var sha512String: String? {
        return utf8Data?.re.sha512String
    }
    
    /// ReerKit: Returns a base64 encoded string of the encrypted Data using AES.
    ///
    /// - Parameters:
    ///   - key: A key with a length of 16(AES128), 24(AES192) or 32(AES256) after conversion to data
    ///   - iv: An initialization vector with a length of 16(CBC) after conversion to data, or use the default data that length of 0(EBC)
    /// - Returns: A base64 encoded string of the encrypted Data encrypted, or nil if an error occurs.
    func aesEncrypt(withKey key: String, iv: String = "") -> String? {
        guard let data = base.re.utf8Data,
              let keyData = key.re.utf8Data,
              let ivData = iv.re.utf8Data
        else { return nil }
        let resultData = data.re.aesEncrypt(withKey: keyData, iv: ivData)
        return resultData?.base64EncodedString()
    }
    
    /// ReerKit: Returns an decrypted `String` using AES.
    ///
    /// - Parameters:
    ///   - key: A key with a length of 16(AES128), 24(AES192) or 32(AES256) after conversion to data
    ///   - iv: An initialization vector with a length of 16(CBC) after conversion to data, or use the default data that length of 0(EBC)
    /// - Returns: A decrypted string, or nil if an error occurs.
    func aesDecrypt(withKey key: String, iv: String = "") -> String? {
        guard let data = Data(base64Encoded: base, options: .ignoreUnknownCharacters),
              let keyData = key.re.utf8Data,
              let ivData = iv.re.utf8Data
        else { return nil }
        guard let resultData = data.re.aesDecrypt(withKey: keyData, iv: ivData) else { return nil }
        return resultData.re.utf8String
    }
    
    /// ReerKit: Returns an RSA encrypted data string.
    /// - Parameter publicKey: RSA public key.
    /// - Returns: A base64 string represent the ecrypted data, or nil if an error occurs.
    func rsaEncrypt(withPublicKey publicKey: String) -> String? {
        guard let data = base.re.utf8Data else { return nil }
        return data.re.rsaEncrypt(withPublicKey: publicKey)?.base64EncodedString()
    }
    
    /// ReerKit: Returns an RSA decrypted data string.
    /// - Parameter publicKey: RSA private key.
    /// - Returns: A `String` decrypted, or nil if an error occurs.
    func rsaDecrypt(withPrivateKey privateKey: String) -> String? {
        guard let data = base.re.base64DecodedData else { return nil }
        return data.re.rsaDecrypt(withPrivateKey: privateKey)?.re.utf8String
    }
    
    /// ReerKit: Returns an RSA encrypted data string.
    /// - Parameter privateKey: RSA private key.
    /// - Returns: A base64 string represent the ecrypted data, or nil if an error occurs.
    func rsaEncrypt(withPrivateKey privateKey: String) -> String? {
        guard let data = base.re.utf8Data else { return nil }
        return data.re.rsaEncrypt(withPrivateKey: privateKey)?.base64EncodedString()
    }
    
    /// ReerKit: Returns an RSA decrypted data string.
    /// - Parameter publicKey: RSA public key.
    /// - Returns: A `String` decrypted, or nil if an error occurs.
    func rsaDecrypt(withPublicKey publicKey: String) -> String? {
        guard let data = base.re.base64DecodedData else { return nil }
        return data.re.rsaDecrypt(withPublicKey: publicKey)?.re.utf8String
    }
}
#endif
