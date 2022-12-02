//
//  StringExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/11/9.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

// swiftlint:disable:next type_body_length
final class StringExtensionsTests: XCTestCase {
    let helloWorld = "Hello World!"
    let flower = "💐" // for testing multi-byte characters

    override func setUp() {
        super.setUp()
        NSTimeZone.default = NSTimeZone.system
    }

    func testUTF8Data() {
        XCTAssertEqual("123".re.utf8Data?.re.utf8String, "123")
    }

    func testBase64Decoded() {
        XCTAssertEqual("SGVsbG8gV29ybGQh".re.base64Decoded, helloWorld)
        XCTAssertEqual("http://example.com/xxx", "aHR0cDovL2V4YW1wbGUuY29tL3h4eA".re.base64Decoded)
        XCTAssertEqual(helloWorld, "SGVsbG\n8gV29ybGQh".re.base64Decoded)
        XCTAssertEqual(helloWorld, "SGVsbG8gV29ybGQh\n".re.base64Decoded)
        XCTAssertNil(helloWorld.re.base64Decoded)
    }

    func testBase64Encoded() {
        XCTAssertEqual(helloWorld.re.base64Encoded, "SGVsbG8gV29ybGQh")
    }

    func testCharactersArray() {
        let str = "Swift"
        let chars = [Character("S"), Character("w"), Character("i"), Character("f"), Character("t")]
        XCTAssertEqual(str.re.characters, chars)
    }

    func testCamelCased() {
        XCTAssertEqual("Hello test".re.camelCased, "helloTest")
        XCTAssertEqual("Hellotest".re.camelCased, "hellotest")
    }

    func testContainEmoji() {
        XCTAssert("Hello 😂".re.containEmoji)
        XCTAssertFalse("Hello ;)".re.containEmoji)
    }

    func testFirstCharacter() {
        XCTAssertNil("".re.firstCharacterAsString)
        XCTAssertNotNil("Hello".re.firstCharacterAsString)
        XCTAssertEqual("Hello".re.firstCharacterAsString, "H")
    }

    func testHasLetters() {
        XCTAssert("hsj 1 wq3".re.hasLetters)
        XCTAssertFalse("123".re.hasLetters)
        XCTAssert("Hello test".re.hasLetters)
        XCTAssertFalse("".re.hasLetters)
    }

    func testHasNumbers() {
        XCTAssert("hsj 1 wq3".re.hasDigits)
        XCTAssert("123".re.hasDigits)
        XCTAssertFalse("Hello test".re.hasDigits)
        XCTAssertFalse("".re.hasDigits)
    }

    func testIsAlphabetic() {
        XCTAssert("abc".re.hasLettersOnly)
        XCTAssertFalse("123abc".re.hasLettersOnly)
        XCTAssertFalse("123".re.hasLettersOnly)
        XCTAssertFalse("".re.hasLettersOnly)
    }

    func testIsPalindrome() {
        XCTAssert("abcdcba".re.isPalindrome)
        XCTAssert("Mom".re.isPalindrome)
        XCTAssert("A man a plan a canal, Panama!".re.isPalindrome)
        XCTAssertFalse("Mama".re.isPalindrome)
        XCTAssertFalse("".re.isPalindrome)
    }

    func testisValidEmail() {
        // https://blogs.msdn.microsoft.com/testing123/2009/02/06/email-address-test-cases/

        XCTAssert("email@domain.com".re.isValidEmail)
        XCTAssert("firstname.lastname@domain.com".re.isValidEmail)
        XCTAssert("email@subdomain.domain.com".re.isValidEmail)
        XCTAssert("firstname+lastname@domain.com".re.isValidEmail)
        XCTAssert("email@123.123.123.123".re.isValidEmail)
        XCTAssert("email@[123.123.123.123]".re.isValidEmail)
        XCTAssert("\"email\"@domain.com".re.isValidEmail)
        XCTAssert("1234567890@domain.com".re.isValidEmail)
        XCTAssert("email@domain-one.com".re.isValidEmail)
        XCTAssert("_______@domain.com".re.isValidEmail)
        XCTAssert("email@domain.name".re.isValidEmail)
        XCTAssert("email@domain.co.jp".re.isValidEmail)
        XCTAssert("firstname-lastname@domain.com".re.isValidEmail)

        XCTAssertFalse("".re.isValidEmail)
        XCTAssertFalse("plainaddress".re.isValidEmail)
        XCTAssertFalse("#@%^%#$@#$@#.com".re.isValidEmail)
        XCTAssertFalse("@domain.com".re.isValidEmail)
        XCTAssertFalse("Joe Smith <email@domain.com>".re.isValidEmail)
        XCTAssertFalse("email.domain.com".re.isValidEmail)
        XCTAssertFalse("email@domain@domain.com".re.isValidEmail)
        XCTAssertFalse(".email@domain.com".re.isValidEmail)
        XCTAssertFalse("email.@domain.com".re.isValidEmail)
        XCTAssertFalse("email..email@domain.com".re.isValidEmail)
        XCTAssertFalse("email@domain.com (Joe Smith)".re.isValidEmail)
        XCTAssertFalse("email@domain".re.isValidEmail)
        XCTAssertFalse("email@-domain.com".re.isValidEmail)
        XCTAssertFalse(" email@domain.com".re.isValidEmail)
        XCTAssertFalse("email@domain.com ".re.isValidEmail)
        XCTAssertFalse("\nemail@domain.com".re.isValidEmail)
        XCTAssertFalse("nemail@domain.com   \n\n".re.isValidEmail)
    }

    func testIsValidUrl() {
        XCTAssert("https://google.com".re.isValidUrl)
        XCTAssert("http://google.com".re.isValidUrl)
        XCTAssert("ftp://google.com".re.isValidUrl)
    }

    func testIsValidSchemedUrl() {
        XCTAssertFalse("Hello world!".re.isValidSchemedUrl)
        XCTAssert("https://google.com".re.isValidSchemedUrl)
        XCTAssert("ftp://google.com".re.isValidSchemedUrl)
        XCTAssertFalse("google.com".re.isValidSchemedUrl)
    }

    func testIsValidHttpsUrl() {
        XCTAssertFalse("Hello world!".re.isValidHttpsUrl)
        XCTAssert("https://google.com".re.isValidHttpsUrl)
        XCTAssertFalse("http://google.com".re.isValidHttpsUrl)
        XCTAssertFalse("google.com".re.isValidHttpsUrl)
    }

    func testIsValidHttpUrl() {
        XCTAssertFalse("Hello world!".re.isValidHttpUrl)
        XCTAssert("http://google.com".re.isValidHttpUrl)
        XCTAssertFalse("google.com".re.isValidHttpUrl)
    }

    func testIsValidFileURL() {
        XCTAssertFalse("Hello world!".re.isValidFileUrl)
        XCTAssert("file://var/folder/file.txt".re.isValidFileUrl)
        XCTAssertFalse("google.com".re.isValidFileUrl)
    }

    func testIsDigits() {
        XCTAssert("123".re.hasDigitsOnly)
        XCTAssert("987654321".re.hasDigitsOnly)
        XCTAssertFalse("123.4".re.hasDigitsOnly)
        XCTAssertFalse("1.25e2".re.hasDigitsOnly)
        XCTAssertFalse("123abc".re.hasDigitsOnly)
        XCTAssertFalse("".re.hasDigitsOnly)
    }

    func testLastCharacter() {
        XCTAssertNotNil("Hello".re.lastCharacterAsString)
        XCTAssertEqual("Hello".re.lastCharacterAsString, "o")
        XCTAssertNil("".re.lastCharacterAsString)
    }

    func testLatinized() {
        XCTAssertEqual("Hëllô Teśt".re.latinized, "Hello Test")
    }

    func testBool() {
        XCTAssertNotNil("1".re.bool)
        XCTAssert("1".re.bool!)

        XCTAssertNotNil("false".re.bool)
        XCTAssertFalse("false".re.bool!)
        XCTAssertNil("8s".re.bool)
    }

//    func testDate() {
//        let dateFromStr = "2015-06-01".re.date
//        XCTAssertNotNil(dateFromStr)
//        XCTAssertEqual(dateFromStr?.year, 2015)
//        XCTAssertEqual(dateFromStr?.month, 6)
//        XCTAssertEqual(dateFromStr?.day, 1)
//    }
//
//    func testDateTime() {
//        let dateFromStr = "2015-06-01 14:23:09".re.dateTime
//        XCTAssertNotNil(dateFromStr)
//        XCTAssertEqual(dateFromStr?.year, 2015)
//        XCTAssertEqual(dateFromStr?.month, 6)
//        XCTAssertEqual(dateFromStr?.day, 1)
//        XCTAssertEqual(dateFromStr?.hour, 14)
//        XCTAssertEqual(dateFromStr?.minute, 23)
//        XCTAssertEqual(dateFromStr?.second, 9)
//    }

    func testInt() {
        XCTAssertNotNil("8".re.int)
        XCTAssertEqual("8".re.int, 8)

        XCTAssertNil("8s".re.int)
    }

    func testUrl() {
        XCTAssertNil("hello world".re.url)

        let google = "https://www.google.com"
        XCTAssertEqual(google.re.url, URL(string: google))
    }

    func testTrimmed() {
        XCTAssertEqual("\n Hello \n ".re.trimmed, "Hello")
    }

    func testUrlDecoded() {
        XCTAssertEqual("it's%20easy%20to%20encode%20strings".re.urlDecoded, "it's easy to encode strings")
        XCTAssertEqual("%%".re.urlDecoded, "%%")
    }

    func testUrlEncoded() {
        XCTAssertEqual("it's easy to encode strings".re.urlEncoded, "it's%20easy%20to%20encode%20strings")
    }

    func testRegexEscaped() {
        XCTAssertEqual("hello ^$ there".re.regexEscaped, "hello \\^\\$ there")
    }

    func testWithoutSpacesAndNewLines() {
        XCTAssertEqual("Hello \n Test".re.withoutSpacesAndNewLines, "HelloTest")
    }

    func testIsWhiteSpaces() {
        var str = "test string"
        XCTAssertEqual(str.re.isWhitespace, false)

        str = "     "
        XCTAssertEqual(str.re.isWhitespace, true)

        str = "   \n \n  "
        XCTAssertEqual(str.re.isWhitespace, true)
    }

    func testFloat() {
        XCTAssertNotNil("8".re.float())
        XCTAssertEqual("8".re.float(), 8)

        XCTAssertNotNil("8.23".re.float(locale: Locale(identifier: "en_US_POSIX")))
        XCTAssertEqual("8.23".re.float(locale: Locale(identifier: "en_US_POSIX")), Float(8.23))

        #if os(Linux)
        XCTAssertEqual("8s".re.float(), 8)
        #else
        XCTAssertNil("8s".re.float())
        #endif
    }

    func testDouble() {
        XCTAssertNotNil("8".re.double())
        XCTAssertEqual("8".re.double(), 8)

        XCTAssertNotNil("8.23".re.double(locale: Locale(identifier: "en_US_POSIX")))
        XCTAssertEqual("8.23".re.double(locale: Locale(identifier: "en_US_POSIX")), 8.23)

        #if os(Linux)
        XCTAssertEqual("8s".re.double(), 8)
        #else
        XCTAssertNil("8s".re.double())
        #endif
    }

    func testCgFloat() {
        #if !os(Linux)
        XCTAssertNotNil("8".re.cgFloat())
        XCTAssertEqual("8".re.cgFloat(), 8)

        XCTAssertNotNil("8.23".re.cgFloat(locale: Locale(identifier: "en_US_POSIX")))
        XCTAssertEqual("8.23".re.cgFloat(locale: Locale(identifier: "en_US_POSIX")), CGFloat(8.23))

        XCTAssertNil("8s".re.cgFloat())
        #endif
    }

    func testLines() {
        #if !os(Linux)
        XCTAssertEqual("Hello\ntest".re.lines(), ["Hello", "test"])
        #endif
    }

    func testLocalized() {
        XCTAssertEqual(helloWorld.re.localized(), NSLocalizedString(helloWorld, comment: ""))
        XCTAssertEqual(helloWorld.re.localized(comment: "comment"), NSLocalizedString(helloWorld, comment: "comment"))
    }

    func testUnicodeArray() {
        XCTAssertEqual("Hello".re.unicodeArray(), [72, 101, 108, 108, 111])
    }

    func testWords() {
        XCTAssertEqual("Swift is amazing".re.words(), ["Swift", "is", "amazing"])
    }

    func testWordsCount() {
        XCTAssertEqual("Swift is amazing".re.wordCount(), 3)
    }

    func testToSlug() {
        let str = "  A nice & hög _ Str    "
        XCTAssertEqual(str.re.toSlug(), "a-nice-&-hog-str")
        XCTAssertEqual("Swift is amazing".re.toSlug(), "swift-is-amazing")
    }

    func testSubscript() {
        let str = "Hello world!"
        XCTAssertEqual(str.re[1], "e")
        XCTAssertNil(str.re[18])

        XCTAssertEqual(str.re[safe: -5..<5], "Hello")
        XCTAssertEqual(str.re[safe: -5...5], "Hello ")

        XCTAssertEqual(str.re[safe: 0..<0], "")
        XCTAssertEqual(str.re[safe: 0..<4], "Hell")
        XCTAssertEqual(str.re[safe: 1..<5], "ello")
        XCTAssertEqual(str.re[safe: 7..<7], "")
        XCTAssertEqual(str.re[safe: 10..<18], "d!")
        XCTAssertEqual(str.re[safe: 11..<12], "!")

        XCTAssertEqual(str.re[safe: 0...0], "H")
        XCTAssertEqual(str.re[safe: 0...4], "Hello")
        XCTAssertEqual(str.re[safe: 1...5], "ello ")
        XCTAssertEqual(str.re[safe: 7...7], "o")
        XCTAssertEqual(str.re[safe: 10...18], "d!")
        XCTAssertEqual(str.re[safe: 11...11], "!")
        XCTAssertEqual(str.re[safe: 11...12], "!")

        let oneCharStr = "a"
        XCTAssertEqual(oneCharStr.re[safe: 0..<0], "")
        XCTAssertEqual(oneCharStr.re[safe: 0..<1], "a")
        XCTAssertEqual(oneCharStr.re[safe: 0..<2], "a")
        XCTAssertEqual(oneCharStr.re[safe: 1..<1], "")
        XCTAssertEqual(oneCharStr.re[safe: 1..<2], "")

        XCTAssertEqual(oneCharStr.re[safe: 0...0], "a")
        XCTAssertEqual(oneCharStr.re[safe: 0...1], "a")
        XCTAssertEqual(oneCharStr.re[safe: 0...2], "a")
        XCTAssertEqual(oneCharStr.re[safe: 1...1], "")
        XCTAssertEqual(oneCharStr.re[safe: 1...2], "")

        // Empty string
        XCTAssertEqual("".re[safe: 0..<0], "")
        XCTAssertEqual("".re[safe: 0..<1], "")
        XCTAssertNil("".re[safe: 1..<1])
        XCTAssertNil("".re[safe: 1..<2])
        XCTAssertNil("".re[safe: 2..<3])

        XCTAssertEqual("".re[safe: 0...0], "")
        XCTAssertEqual("".re[safe: 0...1], "")
        XCTAssertNil("".re[safe: 1..<1])
        XCTAssertNil("".re[safe: 1...2])
        XCTAssertNil("".re[safe: 2...3])
    }

    func testCopyToPasteboard() {
//        let str = "Hello world!"
//        #if os(iOS)
//        str.re.copyToPasteboard()
//        let strFromPasteboard = UIPasteboard.general.string
//        XCTAssertEqual(strFromPasteboard, str)
//
//        #elseif os(macOS)
//        str.re.copyToPasteboard()
//        let strFromPasteboard = NSPasteboard.general.string(forType: .string)
//        XCTAssertEqual(strFromPasteboard, str)
//        #endif
    }

    func testCamelize() {
        var str = "Hello test"
        str.re.camelize()
        XCTAssertEqual(str, "helloTest")

        str = "helloWorld"
        str.re.camelize()
        XCTAssertEqual(str, "helloworld")
    }

    func testFirstCharacterUppercased() {
        var str = "hello test"
        str.re.firstCharacterUppercased()
        XCTAssertEqual(str, "Hello test")

        str = "helloworld"
        str.re.firstCharacterUppercased()
        XCTAssertEqual(str, "Helloworld")

        str = ""
        str.re.firstCharacterUppercased()
        XCTAssertEqual(str, "")
    }

    func testHasUniqueCharacters() {
        XCTAssert("swift".re.hasUniqueCharacters())
        XCTAssertFalse("language".re.hasUniqueCharacters())
        XCTAssertFalse("".re.hasUniqueCharacters())
    }

    func testContain() {
        XCTAssert("Hello Tests".re.contains("Hello", caseSensitive: true))
        XCTAssert("Hello Tests".re.contains("hello", caseSensitive: false))
    }

    func testCount() {
        XCTAssertEqual("Hello This Tests".re.count(of: "T"), 2)
        XCTAssertEqual("Hello This Tests".re.count(of: "t"), 1)
        XCTAssertEqual("Hello This Tests".re.count(of: "T", caseSensitive: false), 3)
        XCTAssertEqual("Hello This Tests".re.count(of: "t", caseSensitive: false), 3)
    }

    func testEnd() {
        XCTAssert("Hello Test".re.ends(with: "test", caseSensitive: false))
        XCTAssert("Hello Tests".re.ends(with: "sts"))
    }

    func testLatinize() {
        var str = "Hëllô Teśt"
        str.re.latinize()
        XCTAssertEqual(str, "Hello Test")
    }

    func testRandom() {
        let str1 = String.re.random(ofLength: 10)
        XCTAssertEqual(str1.count, 10)

        let str2 = String.re.random(ofLength: 10)
        XCTAssertEqual(str2.count, 10)

        XCTAssertNotEqual(str1, str2)

        XCTAssertEqual(String.re.random(ofLength: 0), "")
    }

    func testReverse() {
        var str = "Hello"
        str.re.reverse()
        XCTAssertEqual(str, "olleH")
    }

    func testSlice() {
        XCTAssertEqual("12345678".re.slicing(from: 2, length: 3), "345")
        XCTAssertEqual("12345678".re.slicing(from: 2, length: 0), "")
        XCTAssertNil("12345678".re.slicing(from: 12, length: 0))
        XCTAssertEqual("12345678".re.slicing(from: 2, length: 100), "345678")

        var str = "12345678"
        str.re.slice(from: 2, length: 3)
        XCTAssertEqual(str, "345")

        str = "12345678"
        str.re.slice(from: 2, length: 0)
        print(str)
        XCTAssertEqual(str, "")

        str = "12345678"
        str.re.slice(from: 12, length: 0)
        XCTAssertEqual(str, "12345678")

        str = "12345678"
        str.re.slice(from: 2, length: 100)
        XCTAssertEqual(str, "345678")

        str = "12345678"
        str.re.slice(from: 2, to: 5)
        XCTAssertEqual(str, "345")

        str = "12345678"
        str.re.slice(from: 2, to: 1)
        XCTAssertEqual(str, "12345678")

        str = "12345678"
        str.re.slice(at: 2)
        XCTAssertEqual(str, "345678")

        str = "12345678"
        str.re.slice(at: 20)
        XCTAssertEqual(str, "12345678")
    }

    func testStart() {
        XCTAssert("Hello Test".re.starts(with: "hello", caseSensitive: false))
        XCTAssert("Hello Tests".re.starts(with: "He"))
    }

    func testDateWithFormat() {
        let dateString = "2012-12-08 17:00:00.0"
        let date = dateString.re.date(withFormat: "yyyy-dd-MM HH:mm:ss.S")
        XCTAssertNotNil(date)
        XCTAssertNil(dateString.re.date(withFormat: "Hello world!"))
    }

    func testTrim() {
        var str = "\n Hello \n "
        str.re.trim()
        XCTAssertEqual(str, "Hello")
    }

    func testTruncate() {
        var str = "This is a very long sentence"
        str.re.truncate(toLength: 14)
        XCTAssertEqual(str, "This is a very...")

        str = "This is a very long sentence"
        str.re.truncate(toLength: 14, trailing: nil)
        XCTAssertEqual(str, "This is a very")

        str = "This is a short sentence"
        str.re.truncate(toLength: 100)
        XCTAssertEqual(str, "This is a short sentence")

        str.re.truncate(toLength: -1)
        XCTAssertEqual(str, "This is a short sentence")
    }

    func testTruncated() {
        XCTAssertEqual("".re.truncated(toLength: 5, trailing: nil), "")
        XCTAssertEqual("This is a short sentence".re.truncated(toLength: -1, trailing: nil), "This is a short sentence")
        XCTAssertEqual("This is a very long sentence".re.truncated(toLength: 14), "This is a very...")

        XCTAssertEqual("This is a very long sentence".re.truncated(toLength: 14, trailing: nil), "This is a very")
        XCTAssertEqual("This is a short sentence".re.truncated(toLength: 100), "This is a short sentence")
    }

    func testUrlDecode() {
        var url = "it's%20easy%20to%20encode%20strings"
        url.re.urlDecode()
        XCTAssertEqual(url, "it's easy to encode strings")
    }

    func testUrlEncode() {
        var url = "it's easy to encode strings"
        url.re.urlEncode()
        XCTAssertEqual(url, "it's%20easy%20to%20encode%20strings")
    }

    let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

    func testPatternMatches() {
        XCTAssertTrue("123".re.matches(pattern: "\\d{3}"))
        XCTAssertFalse("dasda".re.matches(pattern: "\\d{3}"))
        XCTAssertFalse("notanemail.com".re.matches(pattern: emailPattern))
        XCTAssertTrue("email@mail.com".re.matches(pattern: emailPattern))
    }

    func testRegexMatches() throws {
        XCTAssertTrue("123".re.matches(regex: try NSRegularExpression(pattern: "\\d{3}")))
        XCTAssertFalse("dasda".re.matches(regex: try NSRegularExpression(pattern: "\\d{3}")))
        XCTAssertFalse("notanemail.com".re.matches(regex: try NSRegularExpression(pattern: emailPattern)))
        XCTAssertTrue("email@mail.com".re.matches(regex: try NSRegularExpression(pattern: emailPattern)))
    }

    #if canImport(Foundation)
    func testPatternMatchOperator() {
        XCTAssert("123" ~= "\\d{3}")
        XCTAssertFalse("dasda" ~= "\\d{3}")
        XCTAssertFalse("notanemail.com" ~= emailPattern)
        XCTAssert("email@mail.com" ~= emailPattern)
        XCTAssert("hat" ~= "[a-z]at")
        XCTAssertFalse("" ~= "[a-z]at")
        XCTAssert("" ~= "[a-z]*")
        XCTAssertFalse("" ~= "[0-9]+")
    }
    #endif

    func testRegexMatchOperator() throws {
        let regex = try NSRegularExpression(pattern: "\\d{3}")
        XCTAssert("123" ~= regex)
        XCTAssertFalse("abc" ~= regex)
    }

    func testPadStart() {
        var str: String = "str"
        str.re.padStart(10)
        XCTAssertEqual(str, "       str")

        str = "str"
        str.re.padStart(10, with: "br")
        XCTAssertEqual(str, "brbrbrbstr")

        str = "str"
        str.re.padStart(5, with: "brazil")
        XCTAssertEqual(str, "brstr")

        str = "str"
        str.re.padStart(6, with: "a")
        XCTAssertEqual(str, "aaastr")

        str = "str"
        str.re.padStart(6, with: "abc")
        XCTAssertEqual(str, "abcstr")

        str = "str"
        str.re.padStart(2)
        XCTAssertEqual(str, "str")
    }

    func testPaddingStart() {
        XCTAssertEqual("str".re.paddingStart(10), "       str")
        XCTAssertEqual("str".re.paddingStart(10, with: "br"), "brbrbrbstr")
        XCTAssertEqual("str".re.paddingStart(5, with: "brazil"), "brstr")
        XCTAssertEqual("str".re.paddingStart(6, with: "a"), "aaastr")
        XCTAssertEqual("str".re.paddingStart(6, with: "abc"), "abcstr")
        XCTAssertEqual("str".re.paddingStart(2), "str")
    }

    func testPadEnd() {
        var str: String = "str"
        str.re.padEnd(10)
        XCTAssertEqual(str, "str       ")

        str = "str"
        str.re.padEnd(10, with: "br")
        XCTAssertEqual(str, "strbrbrbrb")

        str = "str"
        str.re.padEnd(5, with: "brazil")
        XCTAssertEqual(str, "strbr")

        str = "str"
        str.re.padEnd(6, with: "a")
        XCTAssertEqual(str, "straaa")

        str = "str"
        str.re.padEnd(6, with: "abc")
        XCTAssertEqual(str, "strabc")

        str = "str"
        str.re.padEnd(2)
        XCTAssertEqual(str, "str")
    }

    func testPaddingEnd() {
        XCTAssertEqual("str".re.paddingEnd(10), "str       ")
        XCTAssertEqual("str".re.paddingEnd(10, with: "br"), "strbrbrbrb")
        XCTAssertEqual("str".re.paddingEnd(5, with: "brazil"), "strbr")
        XCTAssertEqual("str".re.paddingEnd(6, with: "a"), "straaa")
        XCTAssertEqual("str".re.paddingEnd(6, with: "abc"), "strabc")
        XCTAssertEqual("str".re.paddingEnd(2), "str")
    }

    func testIsSpelledCorrectly() {
        #if os(iOS) || os(tvOS)
        let strCorrect = "Hello, World!"

        XCTAssert(strCorrect.re.isSpelledCorrectly)

        let strNonCorrect = "Helol, Wrold!"
        XCTAssertFalse(strNonCorrect.re.isSpelledCorrectly)
        #endif
    }

    func testRemovingPrefix() {
        let inputStr = "Hello, World!"
        XCTAssertEqual(inputStr.re.removingPrefix("Hello, "), "World!")
    }

    func testRemovingSuffix() {
        let inputStr = "Hello, World!"
        XCTAssertEqual(inputStr.re.removingSuffix(", World!"), "Hello")
    }

    func testWithPrefix() {
        XCTAssertEqual("www.apple.com".re.withPrefix("https://"), "https://www.apple.com")
        XCTAssertEqual("https://www.apple.com".re.withPrefix("https://"), "https://www.apple.com")
    }

    func testBold() {
        #if canImport(Foundation) && os(macOS)
        let boldString = "hello".re.bold
        let attrs = boldString.attributes(
            at: 0,
            longestEffectiveRange: nil,
            in: NSRange(location: 0, length: boldString.length))
        XCTAssertNotNil(attrs[NSAttributedString.Key.font])

        #if os(macOS)
        guard let font = attrs[.font] as? NSFont else {
            XCTFail("Unable to find font in testBold")
            return
        }
        XCTAssertEqual(font, NSFont.boldSystemFont(ofSize: NSFont.systemFontSize))
        #elseif os(iOS)
        guard let font = attrs[NSAttributedString.Key.font] as? UIFont else {
            XCTFail("Unable to find font in testBold")
            return
        }
        XCTAssertEqual(font, UIFont.boldSystemFont(ofSize: UIFont.systemFontSize))
        #endif
        #endif
    }

    func testUnderline() {
        #if !os(Linux)
        let underlinedString = "hello".re.underline
        let attrs = underlinedString.attributes(
            at: 0,
            longestEffectiveRange: nil,
            in: NSRange(location: 0, length: underlinedString.length))
        XCTAssertNotNil(attrs[NSAttributedString.Key.underlineStyle])
        guard let style = attrs[NSAttributedString.Key.underlineStyle] as? Int else {
            XCTFail("Unable to find style in testUnderline")
            return
        }
        XCTAssertEqual(style, NSUnderlineStyle.single.rawValue)
        #endif
    }

    func testStrikethrough() {
        #if !os(Linux)
        let strikedthroughString = "hello".re.strikethrough
        let attrs = strikedthroughString.attributes(
            at: 0,
            longestEffectiveRange: nil,
            in: NSRange(location: 0, length: strikedthroughString.length))
        XCTAssertNotNil(attrs[NSAttributedString.Key.strikethroughStyle])
        guard let style = attrs[NSAttributedString.Key.strikethroughStyle] as? NSNumber else {
            XCTFail("Unable to find style in testStrikethrough")
            return
        }
        XCTAssertEqual(style, NSNumber(value: NSUnderlineStyle.single.rawValue as Int))
        #endif
    }

    func testItalic() {
        #if os(iOS)
        let italicString = "hello".re.italic
        let attrs = italicString.attributes(
            at: 0,
            longestEffectiveRange: nil,
            in: NSRange(location: 0, length: italicString.length))
        XCTAssertNotNil(attrs[NSAttributedString.Key.font])
        guard let font = attrs[NSAttributedString.Key.font] as? UIFont else {
            XCTFail("Unable to find font in testItalic")
            return
        }
        XCTAssertEqual(font, UIFont.italicSystemFont(ofSize: UIFont.systemFontSize))
        #endif
    }

    func testColored() {
        #if canImport(AppKit) || canImport(UIKit)
        let coloredString = "hello".re.colored(with: .orange)
        let attrs = coloredString.attributes(
            at: 0,
            longestEffectiveRange: nil,
            in: NSRange(location: 0, length: coloredString.length))
        XCTAssertNotNil(attrs[NSAttributedString.Key.foregroundColor])

        guard let color = attrs[.foregroundColor] as? Color else {
            XCTFail("Unable to find color in testColored")
            return
        }
        XCTAssertEqual(color, .orange)
        #endif
    }

    func testNSString() {
        XCTAssertEqual("Hello".re.nsString, NSString(string: "Hello"))
    }

    func testFullNSRange() {
        XCTAssertEqual("".re.fullNSRange, NSRange(location: 0, length: 0))
        XCTAssertEqual(helloWorld.re.fullNSRange, NSRange(location: 0, length: 12))
        XCTAssertEqual(flower.re.fullNSRange, NSRange(location: 0, length: 2))
    }

    func testLastPathComponent() {
        let string = "hello"
        let nsString = NSString(string: "hello")
        XCTAssertEqual(string.re.lastPathComponent, nsString.lastPathComponent)
    }

    func testLastPathExtension() {
        let string = "hello"
        let nsString = NSString(string: "hello")
        XCTAssertEqual(string.re.pathExtension, nsString.pathExtension)
    }

    func testLastDeletingLastPathComponent() {
        let string = "hello"
        let nsString = NSString(string: "hello")
        XCTAssertEqual(string.re.deletingLastPathComponent, nsString.deletingLastPathComponent)
    }

    func testLastDeletingPathExtension() {
        let string = "hello"
        let nsString = NSString(string: "hello")
        XCTAssertEqual(string.re.deletingPathExtension, nsString.deletingPathExtension)
    }

    func testLastPathComponents() {
        let string = "hello"
        let nsString = NSString(string: "hello")
        XCTAssertEqual(string.re.pathComponents, nsString.pathComponents)
    }

    func testRange() {
        let fullRange = helloWorld.re.range(from: NSRange(location: 0, length: 12))
        XCTAssertEqual(String(helloWorld[fullRange]), helloWorld)

        let range = helloWorld.re.range(from: NSRange(location: 6, length: 6))
        XCTAssertEqual(helloWorld[range], "World!")

        let emptyRange = helloWorld.re.range(from: NSRange(location: 0, length: 0))
        XCTAssertEqual(helloWorld[emptyRange], "")

        let flowerRange = flower.re.range(from: NSRange(location: 0, length: 2))
        XCTAssertEqual(String(flower[flowerRange]), flower)
    }

    func testNSRange() {
        let startIndex = helloWorld.startIndex
        let endIndex = helloWorld.endIndex
        XCTAssertEqual(helloWorld.re.nsRange(from: startIndex..<endIndex), NSRange(location: 0, length: 12))

        XCTAssertEqual(
            helloWorld.re.nsRange(from: helloWorld.index(startIndex, offsetBy: 6)..<endIndex),
            NSRange(location: 6, length: 6))

        XCTAssertEqual(helloWorld.re.nsRange(from: startIndex..<startIndex), NSRange(location: 0, length: 0))

        XCTAssertEqual(flower.re.nsRange(from: flower.startIndex..<flower.endIndex), NSRange(location: 0, length: 2))
    }

    func testAppendingPathComponent() {
        let string = "hello".re.appendingPathComponent("world")
        let nsString = NSString(string: "hello").appendingPathComponent("world")
        XCTAssertEqual(string, nsString)
    }

    func testAppendingPathExtension() {
        let string = "hello".re.appendingPathExtension("world")
        let nsString = NSString(string: "hello").appendingPathExtension("world")
        XCTAssertEqual(string, nsString)
    }

    func testOperators() {
        let testString = "sa"

        XCTAssertEqual(testString * 5, "sasasasasa")
        XCTAssertEqual(5 * testString, "sasasasasa")

        XCTAssertEqual(testString * 0, "")
        XCTAssertEqual(0 * testString, "")

        XCTAssertEqual(testString * -5, "")
        XCTAssertEqual(-5 * testString, "")
    }

    func testIntSpellOut() {
        let num = 12.32
        XCTAssertNotNil(num.re.spelledOutString(locale: Locale(identifier: "en_US")))
        XCTAssertEqual(num.re.spelledOutString(locale: Locale(identifier: "en_US")), "twelve point three two")
    }

    @available(macOS 10.11, *)
    func testIntOrdinal() {
        let num = 12
        XCTAssertNotNil(num.re.ordinalString())
        XCTAssertEqual(num.re.ordinalString(), "12th")
    }

    func testReplacingOccurrencesRegex() throws {
        let re1 = try NSRegularExpression(pattern: "empty")
        XCTAssertEqual("", "".re.replacingOccurrences(of: re1, with: "case"))

        let string = "hello"

        let re2 = try NSRegularExpression(pattern: "not")
        XCTAssertEqual("hello", string.re.replacingOccurrences(of: re2, with: "found"))
        let re3 = try NSRegularExpression(pattern: "l+")
        XCTAssertEqual("hexo", string.re.replacingOccurrences(of: re3, with: "x"))
        let re4 = try NSRegularExpression(pattern: "(ll)")
        XCTAssertEqual("hellxo", string.re.replacingOccurrences(of: re4, with: "$1x"))

        let re5 = try NSRegularExpression(pattern: "ell")
        let options: NSRegularExpression.MatchingOptions = [.anchored]
        XCTAssertEqual("hello", string.re.replacingOccurrences(of: re5, with: "not found", options: options))

        let re6 = try NSRegularExpression(pattern: "l")
        let range = string.startIndex..<string.index(string.startIndex, offsetBy: 3)
        XCTAssertEqual("hexlo", string.re.replacingOccurrences(of: re6, with: "x", range: range))
    }

    func testNSRangeSubscript() {
        XCTAssertEqual(helloWorld.re[NSRange(location: 0, length: 0)], "")
        XCTAssertEqual(String(helloWorld.re[NSRange(location: 0, length: 12)]), helloWorld)
        XCTAssertEqual(String(helloWorld.re[NSRange(location: 6, length: 6)]), "World!")
        XCTAssertEqual(String(flower.re[NSRange(location: 0, length: 2)]), flower)
    }
}
