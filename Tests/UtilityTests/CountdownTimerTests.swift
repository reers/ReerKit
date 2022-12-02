//
//  CountdownTimerTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/3.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class CountdownTimerTests: XCTestCase {

    var countdownTimer: CountdownTimer?

    func testCountdown1() {
        let expectation = self.expectation(description: "CountdownTimer")
        let start = Date()
        countdownTimer = CountdownTimer.scheduledTimer(withInterval: 0.5, times: 2) { timer in
            if timer.leftTimes == 1 {
                XCTAssertLessThan(Date().timeIntervalSince(start) - 0.5, 0.1)
            }
            if timer.finished {
                XCTAssertLessThan(Date().timeIntervalSince(start) - 1, 0.1)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1.5, handler: nil)
    }

    func testCountdown2() {
        let expectation = self.expectation(description: "CountdownTimer")
        let start = Date()
        countdownTimer = CountdownTimer.scheduledTimer(withTimes: 2, totalDuration: 1) { timer in
            if timer.leftTimes == 1 {
                XCTAssertLessThan(Date().timeIntervalSince(start) - 0.5, 0.1)
            }
            if timer.finished {
                XCTAssertLessThan(Date().timeIntervalSince(start) - 1, 0.1)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1.5, handler: nil)
    }
}
