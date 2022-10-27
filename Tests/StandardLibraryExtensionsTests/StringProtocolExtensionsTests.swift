//
//  StringProtocolExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/10/27.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

final class StringProtocolExtensionsTests: XCTestCase {
    func testCommonSuffix() {
        let string1 = "Hello world!"

        XCTAssert("".re.commonSuffix(with: "It's cold!").isEmpty)
        XCTAssert(string1.re.commonSuffix(with: "").isEmpty)

        XCTAssertEqual(string1.re.commonSuffix(with: "It's cold!"), "ld!")
        XCTAssertEqual(string1.re.commonSuffix(with: "ld!"), "ld!")
        XCTAssertEqual(string1.re.commonSuffix(with: "Not Common"), "")
        XCTAssertEqual(string1.re.commonSuffix(with: "It's colD!"), "!")
        XCTAssertEqual(string1.re.commonSuffix(with: "Hello world!"), "Hello world!")
        XCTAssertEqual(string1.re.commonSuffix(with: "It's colD!", options: .caseInsensitive), "ld!")
        XCTAssertEqual(string1.re.commonSuffix(with: "It's cold!", options: .literal), "ld!")
        XCTAssertEqual("Pelé".re.commonSuffix(with: "ele"), "")
        XCTAssertEqual("Pelé".re.commonSuffix(with: "ele", options: .diacriticInsensitive), "elé")

        XCTAssertEqual("huea\u{308}hue".re.commonSuffix(with: "hue\u{E4}hue"), "huea\u{308}hue")
        XCTAssertEqual("hue\u{308}hue".re.commonSuffix(with: "hue\u{E4}hue", options: .literal), "hue")
        XCTAssertEqual("hue\u{308}hue".re.commonSuffix(with: "hue\u{E4}hUe", options: [.caseInsensitive, .literal]), "hue")

        XCTAssertEqual(string1.re.commonSuffix(with: "你好世界"), "")
    }
}
