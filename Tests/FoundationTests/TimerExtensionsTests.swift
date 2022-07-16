//
//  TimerExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/17.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class TimerExtensionsTests: XCTestCase {

    var timer: Timer?
    var result = 0
    var startDate: Date?
    var checkDate: Date?

    func testTimer() {
        let expectation = self.expectation(description: "Timer")
        startDate = Date()
        timer = Timer.re.scheduledTimer(timeInterval: 1, weakTarget: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RETimer.after(3.5) {
            XCTAssertEqual((self.checkDate!.timeIntervalSince(self.startDate!) - 3) < 0.1, true)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 4, handler: nil)
    }
    
    @objc
    func timerAction() {
        result += 1
        if result == 1 {
            RETimer.after(0.3) {
                self.timer?.re.suspend()
            }
            RETimer.after(1.3) {
                self.timer?.re.resume()
            }
        }
        if result == 2 {
            checkDate = Date()
        }
    }

}
