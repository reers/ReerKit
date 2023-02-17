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
        waitForExpectations(timeout: 4.5, handler: nil)
    }

    var start: Date?

    func intervalTest() {
        debouncer.execute(interval: 2) {
            os_log("debouncer action")
            XCTAssertEqual((Date().timeIntervalSince(self.start!) - 4) < 0.1, true)
            self.expectation?.fulfill()
        }
    }

}
