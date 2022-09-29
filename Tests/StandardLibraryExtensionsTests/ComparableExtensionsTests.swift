//
//  ComparableExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/9/29.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
import Foundation

@testable import ReerKit

final class ComparableExtensionsTests: XCTestCase {
    func testIsBetween() {
        XCTAssertFalse(1.re.isBetween(5...7), "number range")
        XCTAssert(7.re.isBetween(6...12), "number range")
        XCTAssert(0.32.re.isBetween(0.31...0.33), "float range")
        XCTAssert("c".re.isBetween("a"..."d"), "string range")

        let date = Date()
        XCTAssert(date.re.isBetween(date...date.addingTimeInterval(1000)), "date range")
    }

    func testClamped() {
        XCTAssertEqual(1.re.clamped(to: 3...8), 3)
        XCTAssertEqual(4.re.clamped(to: 3...7), 4)
        XCTAssertEqual("c".re.clamped(to: "e"..."g"), "e")
        XCTAssertEqual(0.32.re.clamped(to: 0.37...0.42), 0.37)
    }
}

