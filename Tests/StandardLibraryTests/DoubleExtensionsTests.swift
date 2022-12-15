//
//  DoubleExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/9/29.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

final class DoubleExtensionsTests: XCTestCase {
    func testInt() {
        XCTAssertEqual(Double(-1).re.int, -1)
        XCTAssertEqual(Double(2).re.int, 2)
        XCTAssertEqual(Double(4.3).re.int, 4)
    }

    func testFloat() {
        XCTAssertEqual(Double(-1).re.float, Float(-1))
        XCTAssertEqual(Double(2).re.float, Float(2))
        XCTAssertEqual(Double(4.3).re.float, Float(4.3))
    }

    func testCGFloat() {
        #if canImport(CoreGraphics)
        XCTAssertEqual(Double(4.3).re.cgFloat, CGFloat(4.3))
        #endif
    }

    func testOperators() {
        XCTAssertEqual(Double(5.0) ** Double(2.0), Double(25.0))
    }
}
