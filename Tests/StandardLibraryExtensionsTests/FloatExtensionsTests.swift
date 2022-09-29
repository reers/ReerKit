//
//  FloatExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/9/29.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

final class FloatExtensionsTests: XCTestCase {
    func testInt() {
        XCTAssertEqual(Float(-1).re.int, -1)
        XCTAssertEqual(Float(2).re.int, 2)
        XCTAssertEqual(Float(4.3).re.int, 4)
    }

    func testDouble() {
        XCTAssertEqual(Float(-1).re.double, Double(-1))
        XCTAssertEqual(Float(2).re.double, Double(2))
        XCTAssertEqual(Float(4.3).re.double, Double(4.3), accuracy: 0.00001)
    }

    func testCGFloat() {
        #if canImport(CoreGraphics)
        XCTAssertEqual(Float(4.3).re.cgFloat, CGFloat(4.3), accuracy: 0.00001)
        #endif
    }

    func testOperators() {
        XCTAssertEqual(Float(5.0) ** Float(2.0), Float(25.0))
    }
}
