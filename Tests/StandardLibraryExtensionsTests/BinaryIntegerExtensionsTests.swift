//
//  BinaryIntegerExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/9/29.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class BinaryIntegerExtensionsTests: XCTestCase {

    func testBytes() {
        let zero = Int32.zero.re.bytes
        XCTAssertEqual(zero, Array(repeating: 0, count: 4))

        let negativeOne = Int8(-1).re.bytes
        XCTAssertEqual(negativeOne, [0xFF])

        let threeHundred = Int16(300).re.bytes
        XCTAssertEqual(threeHundred, [1, 0b0010_1100])

        let uint64Max = UInt64.max.re.bytes
        XCTAssertEqual(uint64Max, Array(repeating: 0xFF, count: 8))
    }

    func testInitBytes() {
        let zero = Int8.re.with(bytes: [0])
        XCTAssertEqual(zero, 0)

        let negativeOne = Int16.re.with(bytes: [0b1111_1111, 0b1111_1111])
        XCTAssertEqual(negativeOne, -1)

        let fortyTwo = Int16.re.with(bytes: [0, 0b0010_1010])
        XCTAssertEqual(fortyTwo, 42)

        let uint64Max = UInt64.re.with(bytes: Array(repeating: 0xFF, count: 8))
        XCTAssertEqual(uint64Max, UInt64.max)
    }

}
