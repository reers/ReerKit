//
//  BoolExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/13.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
import ReerKit

class BoolExtensionsTests: XCTestCase {

    func testBool() {
        XCTAssertEqual(true.re.int, 1)
        XCTAssertEqual(false.re.int, 0)
        XCTAssertEqual(true.re.string, "true")
        XCTAssertEqual(false.re.string, "false")
    }
}
