//
//  FloatingPointExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/9/29.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

final class FloatingPointExtensionsTests: XCTestCase {
    func testAbs() {
        XCTAssertEqual(Float(-9.3).re.abs, Float(9.3))
        XCTAssertEqual(Double(-9.3).re.abs, Double(9.3))
    }

    func testIsPositive() {
        XCTAssert(Float(1).re.isPositive)
        XCTAssertFalse(Float(0).re.isPositive)
        XCTAssertFalse(Float(-1).re.isPositive)

        XCTAssert(Double(1).re.isPositive)
        XCTAssertFalse(Double(0).re.isPositive)
        XCTAssertFalse(Double(-1).re.isPositive)
    }

    func testIsNegative() {
        XCTAssert(Float(-1).re.isNegative)
        XCTAssertFalse(Float(0).re.isNegative)
        XCTAssertFalse(Float(1).re.isNegative)

        XCTAssert(Double(-1).re.isNegative)
        XCTAssertFalse(Double(0).re.isNegative)
        XCTAssertFalse(Double(1).re.isNegative)
    }

    func testCeil() {
        XCTAssertEqual(Float(9.3).re.ceil, Float(10.0))
        XCTAssertEqual(Double(9.3).re.ceil, Double(10.0))
    }

    func testDegreesToRadians() {
        XCTAssertEqual(Float(180).re.degreesToRadians, Float.pi)
        XCTAssertEqual(Double(180).re.degreesToRadians, Double.pi)
    }

    func testFloor() {
        XCTAssertEqual(Float(9.3).re.floor, Float(9.0))
        XCTAssertEqual(Double(9.3).re.floor, Double(9.0))
    }

    func testRadiansToDegrees() {
        XCTAssertEqual(Float.pi.re.radiansToDegrees, Float(180))
        XCTAssertEqual(Double.pi.re.radiansToDegrees, Double(180))
    }

    func testOperators() {
        XCTAssert((Float(5.0) ± Float(2.0)) == (Float(3.0), Float(7.0)) || (Float(5.0) ± Float(2.0)) ==
            (Float(7.0), Float(3.0)))
        XCTAssert((±Float(2.0)) == (Float(2.0), Float(-2.0)) || (±Float(2.0)) == (Float(-2.0), Float(2.0)))
        XCTAssertEqual(√Float(25.0), Float(5.0))

        XCTAssert((Double(5.0) ± Double(2.0)) == (Double(3.0), Double(7.0)) || (Double(5.0) ± Double(2.0)) ==
            (Double(7.0), Double(3.0)))
        XCTAssert((±Double(2.0)) == (Double(2.0), Double(-2.0)) || (±Double(2.0)) == (Double(-2.0), Double(2.0)))
        XCTAssertEqual(√Double(25.0), Double(5.0))
    }
}
