//
//  DispatchTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/29.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class DispatchTests: XCTestCase {

    func testMainQueue() {
        XCTAssertEqual(DispatchQueue.re.isMainQueue, true)
        DispatchQueue.global().sync {
            XCTAssertEqual(false, DispatchQueue.re.isMainQueue)
        }
    }
    
    func testCurrentQueue() {
        XCTAssertEqual(true, DispatchQueue.main.re.isCurrentQueue)
        DispatchQueue.global().sync {
            XCTAssertEqual(false, DispatchQueue.re.isMainQueue)
        }
    }

    func testAsyncAfter() {
        let expectation = self.expectation(description: "AsyncAfter")
        let start = Date()
        DispatchQueue.main.re.asyncAfter(delay: 3) {
            XCTAssertEqual((Date().timeIntervalSince(start) - 3) < 0.1, true)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4, handler: nil)
    }
}
