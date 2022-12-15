//
//  CGFloatExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/15.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(CoreGraphics)
import CoreGraphics

final class CGFloatExtensionsTests: XCTestCase {
    func testAbs() {
        XCTAssertEqual(CGFloat(-9.3).re.abs, CGFloat(9.3))
    }

    func testCeil() {
        XCTAssertEqual(CGFloat(9.3).re.ceil, CGFloat(10.0))
    }

    func testDegreesToRadians() {
        XCTAssertEqual(CGFloat(180).re.degreesToRadians, CGFloat.pi)
    }

    func testIsPositive() {
        XCTAssert(CGFloat(9.3).re.isPositive)
        XCTAssertFalse(CGFloat(0).re.isPositive)
        XCTAssertFalse(CGFloat(-9.2).re.isPositive)
    }

    func testIsNegative() {
        XCTAssert(CGFloat(-9.3).re.isNegative)
        XCTAssertFalse(CGFloat(0).re.isNegative)
        XCTAssertFalse(CGFloat(9.3).re.isNegative)
    }

    func testInt() {
        XCTAssertEqual(CGFloat(9.3).re.int, Int(9))
    }

    func testDouble() {
        XCTAssertEqual(CGFloat(9.3).re.double, Double(9.3))
    }

    func testFloat() {
        XCTAssertEqual(CGFloat(9.3).re.float, Float(9.3))
    }

    func testFloor() {
        XCTAssertEqual(CGFloat(9.3).re.floor, CGFloat(9.0))
    }

    func testRadiansToDegrees() {
        XCTAssertEqual(CGFloat.pi.re.radiansToDegrees, CGFloat(180))
    }
}

#endif
