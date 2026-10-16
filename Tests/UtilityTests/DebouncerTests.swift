//
//  DebouncerTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/2/17.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
import OSLog
@testable import ReerKit

final class DebouncerTests: XCTestCase {
    var expectation: XCTestExpectation?
    let debouncer = Debouncer()
    var timer: RETimer?

    var intervalCount = 0

    func testDebouncer() {
        start = Date()
        expectation = self.expectation(description: "Debouncer")
        timer = RETimer.scheduledTimer(timeInterval: 1) { [weak self] timer in
            os_log("timer action")
            self?.intervalTest()
            self?.intervalCount += 1
            if self?.intervalCount == 2 {
                timer.invalidate()
            }

        }
        // Timers and main-queue dispatch can lag on a busy simulator, so leave headroom over the ideal 4s.
        waitForExpectations(timeout: 8, handler: nil)
    }

    var start: Date?
    var lastCall: Date?

    func intervalTest() {
        lastCall = Date()
        debouncer.execute(interval: 2) {
            os_log("debouncer action")
            // The action must wait the full interval after the *last* call; firing late is fine, early is not.
            XCTAssertGreaterThanOrEqual(Date().timeIntervalSince(self.lastCall!), 2 - 0.05)
            XCTAssertGreaterThanOrEqual(Date().timeIntervalSince(self.start!), 4 - 0.05)
            self.expectation?.fulfill()
        }
    }

}
