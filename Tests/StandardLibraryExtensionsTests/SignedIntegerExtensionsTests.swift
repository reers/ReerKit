//
//  SignedIntegerExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/14.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
import ReerKit

class SignedIntegerExtensionsTests: XCTestCase {

    func testAbs() {
        XCTAssertEqual((-9).re.abs, 9)
    }

    func testIsPositive() {
        XCTAssert(1.re.isPositive)
        XCTAssertFalse(0.re.isPositive)
        XCTAssertFalse((-1).re.isPositive)
    }

    func testIsNegative() {
        XCTAssert((-1).re.isNegative)
        XCTAssertFalse(0.re.isNegative)
        XCTAssertFalse(1.re.isNegative)
    }

    func testIsEven() {
        XCTAssert(2.re.isEven)
        XCTAssertFalse(3.re.isEven)
    }

    func testIsOdd() {
        XCTAssert(3.re.isOdd)
        XCTAssertFalse(2.re.isOdd)
    }

    func testTimeString() {
        XCTAssertEqual((-1).re.timeString, "0 sec")
        XCTAssertEqual(45.re.timeString, "45 sec")
        XCTAssertEqual(120.re.timeString, "2 min")
        XCTAssertEqual(3600.re.timeString, "1h")
        XCTAssertEqual(3660.re.timeString, "1h 1m")
    }

    func testGcd() {
        XCTAssertEqual(8.re.gcd(with: 20), 4)
    }

    func testLcm() {
        XCTAssertEqual(4.re.lcm(with: 3), 12)
    }
    
    func testOrdinalString() {
        XCTAssertEqual(1.re.ordinalString(), "1st")
        XCTAssertEqual(2.re.ordinalString(), "2nd")
        XCTAssertEqual(11.re.ordinalString(), "11th")
    }
}
