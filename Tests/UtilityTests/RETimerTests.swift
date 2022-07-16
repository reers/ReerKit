//
//  RETimerTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/16.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class RETimerTests: XCTestCase {
    var timer: RETimer?

    func testTimer() {
        let expectation = self.expectation(description: "RETimer")
        var times = 0
        let start = Date()
        timer = RETimer.scheduledTimer(delay: 1, timeInterval: 0.5, repeats: true, queue: .main, firstTimeCallbackMoment: .beforeInterval) { timer in
            times += 1
            if times == 2 {
                XCTAssertEqual((Date().timeIntervalSince(start) - 2) < 0.1, true)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2.5, handler: nil)
    }
    
    func testTimerAfter() {
        let expectation = self.expectation(description: "TimerAfter")
        let start = Date()
        RETimer.after(1) {
            XCTAssertEqual((Date().timeIntervalSince(start) - 1) < 0.1, true)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.5, handler: nil)
    }
}
