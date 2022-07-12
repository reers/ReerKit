//
//  CharacterExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/12.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class CharacterExtensionsTests: XCTestCase {

    func testIsEmoji() {
        XCTAssert(Character("😂").re.isEmoji)
        XCTAssertFalse(Character("j").re.isEmoji)
    }

    func testInt() {
        XCTAssertNotNil(Character("1").re.int)
        XCTAssertEqual(Character("1").re.int, 1)
        XCTAssertNil(Character("s").re.int)
    }

    func testString() {
        XCTAssertEqual(Character("s").re.string, String("s"))
    }

    func testUppercased() {
        XCTAssertEqual(Character("s").re.uppercased, Character("S"))
    }

    func testLowercased() {
        XCTAssertEqual(Character("S").re.lowercased, Character("s"))
    }

    func testRandom() {
        var string1 = String()
        var string2 = String()
        for _ in 0..<10 {
            string1.append(Character.re.randomAlphanumeric())
            string2.append(Character.re.randomAlphanumeric())
        }
        XCTAssertNotEqual(string1, string2)
    }

}
