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
        XCTAssertEqual(DispatchQueue.re.isOnMainQueue, true)
        DispatchQueue.global().sync {
            XCTAssertEqual(false, DispatchQueue.re.isOnMainQueue)
        }
    }
    
    func testCurrentQueue() {
        XCTAssertEqual(true, DispatchQueue.main.re.isExecuting)
        DispatchQueue.global().sync {
            XCTAssertEqual(false, DispatchQueue.re.isOnMainQueue)
        }
    }

    func testAsyncAfter() {
        let expectation = self.expectation(description: "AsyncAfter")
        let start = Date()
        DispatchQueue.main.re.asyncAfter(delay: 1) {
            XCTAssertEqual((Date().timeIntervalSince(start) - 1) < 0.1, true)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.5, handler: nil)
    }
}
