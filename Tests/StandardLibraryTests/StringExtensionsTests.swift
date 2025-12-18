//
//  StringExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/11/9.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

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

    func testDate() {
        let dateFromStr = "2015-06-01".re.date
        XCTAssertNotNil(dateFromStr)
        XCTAssertEqual(dateFromStr?.re.year, 2015)
        XCTAssertEqual(dateFromStr?.re.month, 6)
        XCTAssertEqual(dateFromStr?.re.day, 1)
    }

    func testDateTime() {
        let dateFromStr = "2015-06-01 14:23:09".re.dateTime
        XCTAssertNotNil(dateFromStr)
        XCTAssertEqual(dateFromStr?.re.year, 2015)
        XCTAssertEqual(dateFromStr?.re.month, 6)
        XCTAssertEqual(dateFromStr?.re.day, 1)
        XCTAssertEqual(dateFromStr?.re.hour, 14)
        XCTAssertEqual(dateFromStr?.re.minute, 23)
        XCTAssertEqual(dateFromStr?.re.second, 9)
    }

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

        XCTAssertEqual(str.re[-5..<5], "Hello")
        XCTAssertEqual(str.re[-5...5], "Hello ")

        XCTAssertEqual(str.re[0..<0], "")
        XCTAssertEqual(str.re[0..<4], "Hell")
        XCTAssertEqual(str.re[1..<5], "ello")
        XCTAssertEqual(str.re[7..<7], "")
        XCTAssertEqual(str.re[10..<18], "d!")
        XCTAssertEqual(str.re[11..<12], "!")
        XCTAssertEqual(str.re[0...0], "H")
        XCTAssertEqual(str.re[0...4], "Hello")
        XCTAssertEqual(str.re[1...5], "ello ")
        XCTAssertEqual(str.re[7...7], "o")
        XCTAssertEqual(str.re[10...18], "d!")
        XCTAssertEqual(str.re[11...11], "!")
        XCTAssertEqual(str.re[11...12], "!")

        let oneCharStr = "a"
        XCTAssertEqual(oneCharStr.re[0..<0], "")
        XCTAssertEqual(oneCharStr.re[0..<1], "a")
        XCTAssertEqual(oneCharStr.re[0..<2], "a")
        XCTAssertEqual(oneCharStr.re[1..<1], nil)
        XCTAssertEqual(oneCharStr.re[1..<2], nil)

        XCTAssertEqual(oneCharStr.re[0...0], "a")
        XCTAssertEqual(oneCharStr.re[0...1], "a")
        XCTAssertEqual(oneCharStr.re[0...2], "a")
        XCTAssertEqual(oneCharStr.re[1...1], nil)
        XCTAssertEqual(oneCharStr.re[1...2], nil)

        // Empty string
        XCTAssertEqual("".re[0..<0], nil)
        XCTAssertEqual("".re[0..<1], nil)
        XCTAssertNil("".re[1..<1])
        XCTAssertNil("".re[1..<2])
        XCTAssertNil("".re[2..<3])

        XCTAssertEqual("".re[0...0], nil)
        XCTAssertEqual("".re[0...1], nil)
        XCTAssertNil("".re[1..<1])
        XCTAssertNil("".re[1...2])
        XCTAssertNil("".re[2...3])
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
        let str3 = String.re.random(ofLength: 3, from: "1234567890")
        XCTAssertEqual(str3.count, 3)
        XCTAssertTrue(str3.re.hasDigitsOnly)
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
    
    func testHash() {
        let string = "123"
        
        // https://www.tools4noobs.com/online_tools/hash/
        XCTAssertEqual(string.re.md2String, "ef1fedf5d32ead6b7aaf687de4ed1b71")
        XCTAssertEqual(string.re.md4String, "c58cda49f00748a3bc0fcfa511d516cb")
        XCTAssertEqual(string.re.md5String, "202cb962ac59075b964b07152d234b70")
        XCTAssertEqual(string.re.sha1String, "40bd001563085fc35165329ea1ff5c5ecbdbbeef")
        XCTAssertEqual(string.re.sha224String, "78d8045d684abd2eece923758f3cd781489df3a48e1278982466017f")
        XCTAssertEqual(string.re.sha256String, "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3")
        XCTAssertEqual(string.re.sha384String, "9a0a82f0c0cf31470d7affede3406cc9aa8410671520b727044eda15b4c25532a9b5cd8aaf9cec4919d76255b6bfb00f")
        XCTAssertEqual(string.re.sha512String, "3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2")
    }
    
    func testAes() {
        /// AES 128
        XCTAssertEqual("123".re.aesEncrypt(withKey: "abcdefghijklmnop")!.re.aesDecrypt(withKey: "abcdefghijklmnop"), "123")
        
        /// AES 192
        XCTAssertEqual("123".re.aesEncrypt(withKey: "abcdefghijklmnopqrstuvwx")!.re.aesDecrypt(withKey: "abcdefghijklmnopqrstuvwx"), "123")
        
        /// AES 256
        XCTAssertEqual("123".re.aesEncrypt(withKey: "abcdefghijklmnopabcdefghijklmnop")!.re.aesDecrypt(withKey: "abcdefghijklmnopabcdefghijklmnop"), "123")
        
        /// AES 256 with iv
        XCTAssertEqual("123".re.aesEncrypt(withKey: "abcdefghijklmnopabcdefghijklmnop", iv: "0123456789abcdef")!.re.aesDecrypt(withKey: "abcdefghijklmnopabcdefghijklmnop", iv: "0123456789abcdef"), "123")
    }
    
    func testRSA() {
        // 512 bit
        do {
            let publicKey = """
            -----BEGIN PUBLIC KEY-----
            MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAOp23au8FSO6GoU6WL7XJOKX6FzME5VR
            5GZfy9cdDxaixJTiYE+yqPVPuvuT7np9/uVAPNS5fhMcQ+irU+44SVECAwEAAQ==
            -----END PUBLIC KEY-----
            """
            let privateKey = """
            -----BEGIN RSA PRIVATE KEY-----
            MIIBOwIBAAJBAOp23au8FSO6GoU6WL7XJOKX6FzME5VR5GZfy9cdDxaixJTiYE+y
            qPVPuvuT7np9/uVAPNS5fhMcQ+irU+44SVECAwEAAQJAJ5bukyLtBt1TwQ87EO5P
            AhvYVmL3I41yXX7rcmUruQxsHGF+BiqQRs9wC+YAFnPo6Mg6VTr+Bom56ZJb+JXN
            KQIhAPQ68HoPCFjBLF+8B2Ixxa+khp2cVn06V3oorRj4si9vAiEA9cNx3e6qQbx+
            /kPlqQGDiGCrfAXguvJoJkFxubYMsz8CIQClKba21LOwUfLQSzgzD7XAsmLW84MJ
            7Qp7ckadPJJDwQIgQRazOJD2HJTcmWDIGVuiR2M654zy+PAsbz1T7lhtwqcCIQCf
            /gVQunFsqciQXZFrC3STSjn+tpcR5BqSjL5oxHtVgA==
            -----END RSA PRIVATE KEY-----
            """
            let original = String.re.random(ofLength: Int.random(in: 1...100))
            let encrypted1 = original.re.rsaEncrypt(with: publicKey)
            let ret1 = encrypted1!.re.rsaDecrypt(with: privateKey)
            XCTAssertEqual(original, ret1)
            
            let encrypted2 = original.re.rsaSigned(with: privateKey)
            let ret2 = encrypted2!.re.rsaVerified(with: publicKey)
            XCTAssertEqual(original, ret2)
        }
        // 2048 bit
        do {
            let publicKey = """
            -----BEGIN PUBLIC KEY-----
            MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm0bdWFyPZiY/zqV8sYB+
            7j4tYzacgKs2pI10s0gw730dxYuqIUzLvobWT9KzbYcSwuodw8wNHrUazakJ7Va6
            J/FSBgrUldpnnoW2CjUwrqrz5vaThKeHhIwKvQBTcik4kIXQxYtfO+jkSzo+ix/0
            KxZLGV282awg7U0Ny0H7lnCqTBQ0vkf3k9UkEruyTq7FdXwMH9o7sfDNJYWzfugv
            MQIEVUxxQJSg0R35fxtZKNrp57u1ALx9VS6MsdudL73cQ7vK/U+6XfiBOfeoZYv7
            jFYX9kjeRX0AERv6IYR7fynTpYj6ybuTODTRH1ye967Ga5YPZX7mV8VyxdX7ulAH
            0QIDAQAB
            -----END PUBLIC KEY-----
            """
            let privateKey = """
            -----BEGIN RSA PRIVATE KEY-----
            MIIEogIBAAKCAQEAm0bdWFyPZiY/zqV8sYB+7j4tYzacgKs2pI10s0gw730dxYuq
            IUzLvobWT9KzbYcSwuodw8wNHrUazakJ7Va6J/FSBgrUldpnnoW2CjUwrqrz5vaT
            hKeHhIwKvQBTcik4kIXQxYtfO+jkSzo+ix/0KxZLGV282awg7U0Ny0H7lnCqTBQ0
            vkf3k9UkEruyTq7FdXwMH9o7sfDNJYWzfugvMQIEVUxxQJSg0R35fxtZKNrp57u1
            ALx9VS6MsdudL73cQ7vK/U+6XfiBOfeoZYv7jFYX9kjeRX0AERv6IYR7fynTpYj6
            ybuTODTRH1ye967Ga5YPZX7mV8VyxdX7ulAH0QIDAQABAoIBADP33bDrGZtIheZ1
            gGwv40t9R9eCuZJeuyULqtkt+iLNLx+khMYsW6ximGuSyzaHFIJjtJ6JNoLmfhgC
            0S277wXbQGaBTXDx7egiPDDiaG6tDIBqWij1oOd9r0JeT49PuHy2LI9Q/AijA3Ui
            Aziw8xlQlsXgl4oKj+Kb/Vfft4I7ngFmfRjsxBtwlfX64k9z4uEf/guOFvQIe7Nf
            zapKLbtDyGJXWfBFlwfIpDeL5fmpt2ecnJ2aSqs6Cgsa13qDto8soOeRKITCqzg7
            ytBx8gCFKLaNbk6ytTufiwxt/53jjyLaHQOxonSvk3rKTIMYWsbzir6aeIjMa03n
            LboN0lkCgYEAnweocIAs6IfkCjK/FSqa6vA2PjCfbW90AT27zopVwfck9x9NKvJz
            aXdNQpUTSdMeu5Hwie4lFaXVzopxlLgiq9U2PFUrS5CqmSUnzZwvTwW+Ch2OO+6K
            hR2eiMw+Gz3otmtjh7YRNa5k/w5U0x3/ex2Wt49pPL+Y6N32lhy//4sCgYEA+fVa
            cMCd3ApStEHgXZ8ReACbCdxSDJVcYGPuY+pffhYDwgu5/XT0SiAvlFdkFScBqPBq
            dOFB8atqs67co6JPPh+h9uc8r1h7uodvt4lG+7joSsZJXXQjGqKTMLh+JCwFpfDb
            2fNZ/pl/bRrWRWczpimsITZn7rKQQfujaQ5KQZMCgYAAiAsFDTiZMlMNwauny3On
            E1RrEsiFmhi+JFGrWAT/V+8UsFMWsKa4FID6lvrwhTcWE1/FZjlTgDFdtlK414Cu
            KFE9FF/Hqd0YE+q1Ii96SR+gcwbVpm9qEHZGKMCQYL2VVniHrJEUJ9gIjii0Z+ZB
            qBCn3l/QpydAp/U5/TCbDwKBgFCnnd5CGO32msc1dotfF4jsURq2b/dFfsBPno25
            A8Uwn1fO5t3lDiqZBiFMrauxoXR81y0NvnSXxl9ibimS5xT5qg58gPVnjM0chKzp
            a/EvsizmnKe+INGoYexXq8RKPCxWcup5/rELoLV48mkEqwLT8Ynp/1FjZu8Tnp/4
            j3dnAoGAYXZ3vZPMC4Ky1rTnbkxHaW2NFfeEI5qYHyrsFbtAbTADWsG+c9olbiNE
            AeG3kQ5Ujw/eRQnlx6nsk540daRv96keDd1uYI/TrouMiOlLYWGoRCQa5vWG36bR
            XXo/5+87g2ye/govr7AuKODitG+Brq6d5SH5n/OMfz0rzVNuSIA=
            -----END RSA PRIVATE KEY-----
            """
            let original = String.re.random(ofLength: Int.random(in: 1...100))
            let encrypted1 = original.re.rsaEncrypt(with: publicKey)
            let ret1 = encrypted1!.re.rsaDecrypt(with: privateKey)
            XCTAssertEqual(original, ret1)
            
            let encrypted2 = original.re.rsaSigned(with: privateKey)
            let ret2 = encrypted2!.re.rsaVerified(with: publicKey)
            XCTAssertEqual(original, ret2)
        }
        
        // 4096 bit
        do {
            let publicKey = """
            -----BEGIN PUBLIC KEY-----
            MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAyIGqMNKBhWZ+8QsH0Cvf
            R2WhN4l07yFj1VTYYy+mm1tPJ9Nt0UK31TWRdNlMDdkRiD/bBpOtwS7eQmyLdd/G
            Rj7VM7YwgOSCqhlNBqT49zCjrY5rq6ikVTKEuuwpD6z5LURqBduNwynkauf7eJKC
            Wy4BL45agFqJEDC/cQIoTi3G+03PWo+ig2zF2fpLt/9mm/vx06hAka2zOSJmfcJr
            l8RYj5NCaTztur1/cRNYNwrStdam0T1i0IE7ZF9Zegsbzs58kk18kOabGA3yAOox
            5QoYP2qt/JORfi6fZ3PsQ+ORJqWanF8ruvatwgrKSfZ0rEpDmN7R9nY+vPLKlP8P
            VF8HVkNjTqSdBBVweYUmD245WRVmV7yI2FwDEbsL+Nt/8Z1gwGxgUSsFYDolycch
            NdE65MGpJpClxL+XA+xhspTSaJ39ajW409IPoL4C3dIpFamb1+aYCRLtnQUvZIZg
            DmHWRffUG11g3RwoGPqnBxE+JlsdI0Cwiq7DuyX6x+00M5uh2UoANzG7K25Mlq+9
            arazr0uu/szTnXvIUH7IffIvPMUBuzVUeTAt8sjoZ7JXJ7pzC5RGb4p54WQNCJqH
            ++Waie/lQ/TcOq1Kl/2/qyN91vMvTdfuJBwex6d5pze1ez64nNclkmOUSLWfYBdl
            1VaeURrWoJPkSYQvb52Qf1MCAwEAAQ==
            -----END PUBLIC KEY-----
            """
            let privateKey = """
            -----BEGIN RSA PRIVATE KEY-----
            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
            -----END RSA PRIVATE KEY-----
            """
            let original = String.re.random(ofLength: Int.random(in: 1...100))
            let encrypted1 = original.re.rsaEncrypt(with: publicKey)
            let ret1 = encrypted1!.re.rsaDecrypt(with: privateKey)
            XCTAssertEqual(original, ret1)
            
            let encrypted2 = original.re.rsaSigned(with: privateKey)
            let ret2 = encrypted2!.re.rsaVerified(with: publicKey)
            XCTAssertEqual(original, ret2)
        }
        
        do {
            let publicKey = """
            -----BEGIN PUBLIC KEY-----
            MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2m+iao4xD1QjU1nro17E
            HbYQNmOE3DMniv7uXsz5SLIYOhnMAeV65JQ1J/QD0iUXxbuCnyahu/EYRgmSvw3K
            f1dlNESVVSCsH1CkJtd+Q3wWxSEtcy+PT050mcNqPqLPmZp1n0YY3xMIWabILQTZ
            niby13kW9CmdtYS9+DmyunvR/QpQIk5OmQYx8feZ1KDuRE/UcW3YtcfTIPbLypFl
            vQska9B+DId0KGDCfUdfUmKqhlcryBgoyeSfVVK4FfeqedCgCVl3hOaaw0+WwwFU
            mqIiPO/1Kg/cAsfkvOiLFY7SxjAHslNEu7932p07cBefIAre/6r2PdnPzv/VJJNi
            PwIDAQAB
            -----END PUBLIC KEY-----
            """
            let privateKey = """
            -----BEGIN PRIVATE KEY-----
            MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDab6JqjjEPVCNT
            WeujXsQdthA2Y4TcMyeK/u5ezPlIshg6GcwB5XrklDUn9APSJRfFu4KfJqG78RhG
            CZK/Dcp/V2U0RJVVIKwfUKQm135DfBbFIS1zL49PTnSZw2o+os+ZmnWfRhjfEwhZ
            psgtBNmeJvLXeRb0KZ21hL34ObK6e9H9ClAiTk6ZBjHx95nUoO5ET9Rxbdi1x9Mg
            9svKkWW9CyRr0H4Mh3QoYMJ9R19SYqqGVyvIGCjJ5J9VUrgV96p50KAJWXeE5prD
            T5bDAVSaoiI87/UqD9wCx+S86IsVjtLGMAeyU0S7v3fanTtwF58gCt7/qvY92c/O
            /9Ukk2I/AgMBAAECggEAfXRwS9KuyqcAQvb6JzJeYNIYLaSqwe1/YI1aSohfBCmF
            UJlQWiZ6lp2oifHT3/X92UsAkneVnGO0FUWaSrCZBNok/ggF3IaPVMzz+nr5wbib
            O0z61ZUTMfFVdpqNgrvvj8DunTOdRUGhIhxwC6slcXfdMXQSgtkEAyTiFpbM190F
            4w/TBtwPiQUCnPHkDbtaoAOPpKPpxeHvyOoPjtOvCaERBnjtM9X/DJMh+dXO18XL
            pIUgN5Thdfd/SWuVBWqyXjp/XEdvd4mTtPPerrBBUkJkmRkR9aJB1o/N3nViHCqd
            NPUO5cZ3omDaRJKy/j2BOg5W5n4rK1wUPKAIFF+AwQKBgQDxvDM4TkhJRM6YJhoo
            YsLiW20ZDKN/9dsuulJNk0BRZl4NN/AlS5zoExddsufG2qRB+0XcrfbwdwN/2CnH
            AFmL7WBknHBNO81AFtSBtehnbfuVDZu917neRz1MlkCsoVCJBgJ+xETUGKKtap5N
            QvhjRMAUcD2bCyV/pADo/yxkCwKBgQDnU3bMzjU0k67X3XaZ38euduicUvleLbLt
            x+paPrHH6RfhOxmBvxlSAo4DzDmO6HM+obJwljRrczFJtHnAYWm5SO/JOguiwbgn
            z2o+qFY/J0sKk59x0kevUmjiYNo/up40NQkbtZi2xCLaZa2y6srm0QL2mYNTn+kl
            8NtOYYdHHQKBgQDcTRWoxL7f9xMIWgEQuSC+RW/hmkEPBrJfnXIQPJgrFs2z4jy6
            4HP4lB2BSOAtu2hisWpzuR8I+o133zoDn+/7s7NbPa6i1FMzixrTs0I/sF3M8v/y
            PT2osufMekoqiUDp/04a1Sec2261+CqYYuYXIbqjZb7fI4NjFcW2kYaVDQKBgGUE
            Oq3HIs7Z6xFTIbaiVWWngX66cTEiTa+ujHVqSWJeNNJjZ4kUNW9ttCyOY1g3xBPG
            stCdlziQ7iYcjMpo/60s36GFGo2xgMTJu8Cu7DLZ6tgsjQU8aZdzKmApIUWRLgLo
            YhjanVy6m+m5Wzf1djODdILRmNrMyxiJbIt25Yc1AoGBAMexoq6M1bUltc6v/LZ9
            qgUhKgUOTiueWvL4JKdRQsvpecYdPolWtw2A+pHxjAsKD+PT2ps/afOVcvvSEoeu
            EN0dU90buZCht0Gzf2fhdGtgJfE9WitXMrCkqYHmrwF6FXJCt9BWYwdcycofcwLB
            jaJHumiFMlHeFuxrmDpXd9tu
            -----END PRIVATE KEY-----
            """
            let original = String.re.random(ofLength: Int.random(in: 1...100))
            let encrypted1 = original.re.rsaEncrypt(with: publicKey)
            let ret1 = encrypted1!.re.rsaDecrypt(with: privateKey)
            XCTAssertEqual(original, ret1)
            
            let encrypted2 = original.re.rsaSigned(with: privateKey)
            let ret2 = encrypted2!.re.rsaVerified(with: publicKey)
            XCTAssertEqual(original, ret2)
        }
    }
    
    func testPunycode() {
        var hello = "你好"
        XCTAssertEqual(hello.re.punycodeEncoded?.re.punycodeDecoded, hello)
        XCTAssertEqual(hello.re.idnaEncoded?.re.idnaDecoded, hello)
        
        XCTAssertEqual("寿司".re.punycodeEncoded, "sprr0q")
        XCTAssertEqual("寿司".re.idnaEncoded, "xn--sprr0q")
    }
    
    func testStringChainableMethods() {
#if !os(Linux) && canImport(UIKit)
        let testString = "Hello World!"
        
        // Test font method
        let withFont = testString.re.font(.systemFont(ofSize: 16))
        XCTAssertEqual(withFont.string, testString)
        var attributes = withFont.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.font])
        XCTAssertEqual(attributes[.font] as! UIFont, UIFont.systemFont(ofSize: 16))
        
        // Test fontSize method
        let withFontSize = testString.re.fontSize(18)
        XCTAssertEqual(withFontSize.string, testString)
        attributes = withFontSize.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.font])
        XCTAssertEqual(attributes[.font] as! UIFont, UIFont.systemFont(ofSize: 18))
        
        // Test color method
        let withColor = testString.re.color(.red)
        XCTAssertEqual(withColor.string, testString)
        attributes = withColor.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.foregroundColor])
        XCTAssertEqual(attributes[.foregroundColor] as! UIColor, .red)
        
        // Test backgroundColor method
        let withBackgroundColor = testString.re.backgroundColor(.blue)
        XCTAssertEqual(withBackgroundColor.string, testString)
        attributes = withBackgroundColor.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.backgroundColor])
        XCTAssertEqual(attributes[.backgroundColor] as! UIColor, .blue)
        
        // Test paragraphStyle method
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let withParagraphStyle = testString.re.paragraphStyle(paragraphStyle)
        XCTAssertEqual(withParagraphStyle.string, testString)
        attributes = withParagraphStyle.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.paragraphStyle])
        XCTAssertEqual((attributes[.paragraphStyle] as! NSParagraphStyle).alignment, .center)
        
        // Test paragraphStyle with configure method
        let withParagraphStyleConfigure = testString.re.paragraphStyle { style in
            style.alignment = .right
        }
        XCTAssertEqual(withParagraphStyleConfigure.string, testString)
        attributes = withParagraphStyleConfigure.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.paragraphStyle])
        XCTAssertEqual((attributes[.paragraphStyle] as! NSParagraphStyle).alignment, .right)
        
        // Test underline method
        let withUnderline = testString.re.underline(.single)
        XCTAssertEqual(withUnderline.string, testString)
        attributes = withUnderline.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.underlineStyle])
        XCTAssertEqual(attributes[.underlineStyle] as! Int, NSUnderlineStyle.single.rawValue)
        
        // Test strikethrough method
        let withStrikethrough = testString.re.strikethrough(.single)
        XCTAssertEqual(withStrikethrough.string, testString)
        attributes = withStrikethrough.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.strikethroughStyle])
        XCTAssertEqual(attributes[.strikethroughStyle] as! Int, NSUnderlineStyle.single.rawValue)
        
        // Test kern method
        let withKern = testString.re.kern(2.0)
        XCTAssertEqual(withKern.string, testString)
        attributes = withKern.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.kern])
        XCTAssertEqual(attributes[.kern] as! CGFloat, 2.0, accuracy: 0.01)
        
        // Test baselineOffset method
        let withBaselineOffset = testString.re.baselineOffset(3.0)
        XCTAssertEqual(withBaselineOffset.string, testString)
        attributes = withBaselineOffset.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.baselineOffset])
        XCTAssertEqual(attributes[.baselineOffset] as! CGFloat, 3.0, accuracy: 0.01)
        
        // Test shadow method
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 2.0
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        let withShadow = testString.re.shadow(shadow)
        XCTAssertEqual(withShadow.string, testString)
        attributes = withShadow.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.shadow])
        let retrievedShadow = attributes[.shadow] as! NSShadow
        XCTAssertEqual(retrievedShadow.shadowBlurRadius, 2.0, accuracy: 0.01)
        XCTAssertEqual(retrievedShadow.shadowOffset, CGSize(width: 1, height: 1))
        
        // Test strokeWidth method
        let withStrokeWidth = testString.re.strokeWidth(1.5)
        XCTAssertEqual(withStrokeWidth.string, testString)
        attributes = withStrokeWidth.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.strokeWidth])
        XCTAssertEqual(attributes[.strokeWidth] as! CGFloat, 1.5, accuracy: 0.01)
        
        // Test strokeColor method
        let withStrokeColor = testString.re.strokeColor(.green)
        XCTAssertEqual(withStrokeColor.string, testString)
        attributes = withStrokeColor.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.strokeColor])
        XCTAssertEqual(attributes[.strokeColor] as! UIColor, .green)
        #endif
    }
    
    func testStringChainableMethodsCombined() {
        #if !os(Linux) && canImport(UIKit)
        let testString = "Chained Methods Test"
        
        // Test chaining multiple methods
        let chained = testString.re
            .fontSize(20)
            .re.color(.red)
            .re.backgroundColor(.yellow)
            .re.kern(1.0)
            .re.underline(.single)
        
        XCTAssertEqual(chained.string, testString)
        let attributes = chained.attributes(at: 0, effectiveRange: nil)
        
        // Verify all attributes are applied
        XCTAssertNotNil(attributes[.font])
        XCTAssertEqual(attributes[.font] as! UIFont, UIFont.systemFont(ofSize: 20))
        XCTAssertEqual(attributes[.foregroundColor] as! UIColor, .red)
        XCTAssertEqual(attributes[.backgroundColor] as! UIColor, .yellow)
        XCTAssertEqual(attributes[.kern] as! CGFloat, 1.0, accuracy: 0.01)
        XCTAssertEqual(attributes[.underlineStyle] as! Int, NSUnderlineStyle.single.rawValue)
        #endif
    }
    
    func testStringChainableMethodsEmptyString() {
        #if !os(Linux) && canImport(UIKit)
        let emptyString = ""
        
        // Test that chainable methods work with empty strings
        let withFont = emptyString.re.font(.systemFont(ofSize: 12))
        XCTAssertEqual(withFont.string, "")
        let attributes = withFont.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes.count, 0) // Empty string should have no attributes
        #endif
    }
    
    func testStringWithAttributesCompatibility() {
        #if !os(Linux) && canImport(UIKit)
        let testString = "Compatibility Test"
        
        // Test that new chainable methods work with existing with(attributes:) method
        let withAttributes = testString.re.with(attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.blue
        ])
        
        // Apply additional attributes using chainable methods
        let extended = withAttributes.re.backgroundColor(.yellow).re.kern(2.0)
        
        let attributes = extended.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes[.font] as! UIFont, UIFont.systemFont(ofSize: 14))
        XCTAssertEqual(attributes[.foregroundColor] as! UIColor, .blue)
        XCTAssertEqual(attributes[.backgroundColor] as! UIColor, .yellow)
        XCTAssertEqual(attributes[.kern] as! CGFloat, 2.0, accuracy: 0.01)
        #endif
    }
}
