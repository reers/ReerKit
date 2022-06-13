//
//  IntExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/14.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class IntExtensionsTests: XCTestCase {

    func testDegreesToRadians() {
        XCTAssertEqual(180.re.degreesToRadians, Double.pi)
    }

    func testRadiansToDegrees() {
        XCTAssertEqual(Int(3.re.radiansToDegrees), 171)
    }

    func testUInt() {
        XCTAssertEqual(Int(10).re.uInt, UInt(10))
    }

    func testDouble() {
        XCTAssertEqual((-1).re.double, Double(-1))
        XCTAssertEqual(2.re.double, Double(2))
    }

    func testFloat() {
        XCTAssertEqual((-1).re.float, Float(-1))
        XCTAssertEqual(2.re.float, Float(2))
    }

    func testCGFloat() {
        #if canImport(CoreGraphics)
        XCTAssertEqual(1.re.cgFloat, CGFloat(1))
        #endif
    }

    func testKFormatted() {
        XCTAssertEqual(10.re.metricFormatted, "0k")
        XCTAssertEqual((-10).re.metricFormatted, "0k")

        XCTAssertEqual(0.re.metricFormatted, "0k")

        XCTAssertEqual(1000.re.metricFormatted, "1k")
        XCTAssertEqual((-1000).re.metricFormatted, "-1k")

        XCTAssertEqual(100_000.re.metricFormatted, "100k")
        XCTAssertEqual((-100_000).re.metricFormatted, "-100k")

        XCTAssertEqual(1_000_000.re.metricFormatted, "1m")
        XCTAssertEqual(2_000_000_000.re.metricFormatted, "2g")
        XCTAssertEqual(3_000_000_000_000.re.metricFormatted, "3t")
    }

    func testDigits() {
        let number = -123
        XCTAssertEqual(number.re.digits, [1, 2, 3])
        XCTAssertEqual(123.re.digits, [1, 2, 3])
        XCTAssertEqual(0.re.digits, [0])
    }

    func testDigitsCount() {
        let number = -123
        XCTAssertEqual(number.re.digitsCount, 3)
        XCTAssertEqual(180.re.digitsCount, 3)
        XCTAssertEqual(0.re.digitsCount, 1)
        XCTAssertEqual(1.re.digitsCount, 1)
    }

    func testIsPrime() {
        // Prime number
        XCTAssert(2.re.isPrime())
        XCTAssert(3.re.isPrime())
        XCTAssert(7.re.isPrime())
        XCTAssert(19.re.isPrime())
        XCTAssert(577.re.isPrime())
        XCTAssert(1999.re.isPrime())

        // Composite number
        XCTAssertFalse(4.re.isPrime())
        XCTAssertFalse(21.re.isPrime())
        XCTAssertFalse(81.re.isPrime())
        XCTAssertFalse(121.re.isPrime())
        XCTAssertFalse(9409.re.isPrime())

        // Others
        XCTAssertFalse((-1).re.isPrime())
        XCTAssertFalse(0.re.isPrime())
        XCTAssertFalse(1.re.isPrime())
    }

    func testRomanNumeral() {
        XCTAssertEqual(10.re.romanNumeral(), "X")
        XCTAssertEqual(2784.re.romanNumeral(), "MMDCCLXXXIV")
        XCTAssertNil((-1).re.romanNumeral())
    }

    func testOperators() {
        XCTAssertEqual(5 ** 2, 25)
        XCTAssert((5 ± 2) == (3, 7) || (5 ± 2) == (7, 3))
        XCTAssert((±(-2)) == (2, -2) || (±2) == (-2, 2))
        XCTAssertEqual(√25, 5.0)
    }

}
