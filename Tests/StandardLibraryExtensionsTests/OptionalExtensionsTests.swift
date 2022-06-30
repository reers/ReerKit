//
//  OptionalExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/1.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest

class OptionalExtensionsTests: XCTestCase {

    func testOptional() {
        var s: String? = nil
        XCTAssertEqual(s.re.isNil, true)
        XCTAssertEqual(s.re.isValid, false)
        var temp = ""
        s.re.run { _ in temp = "sss" }
        XCTAssertNotEqual(temp, "sss")
        
        s = ""
        XCTAssertEqual(s.re.isNil, false)
        XCTAssertEqual(s.re.isValid, true)
        
        XCTAssertEqual(s.re.value(default: "111"), "")
        s = nil
        XCTAssertEqual(s.re.value(default: "111"), "111")
        
        s = "222"
        XCTAssertEqual(try s.re.value(throw: NSError()), "222")
        
        s.re.run { XCTAssertEqual($0, "222") }
        
        
        XCTAssertFalse(s.re.isEmpty)
        s = nil
        XCTAssertTrue(s.re.isEmpty)
        s = ""
        XCTAssertTrue(s.re.isEmpty)
    }

}
