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
        timer = RETimer.scheduledTimer(delay: 1, timeInterval: 0.5, repeats: true, queue: .main, callbackImmediatelyWhenFired: true) { timer in
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

    /// A timer that is created but never scheduled must be released safely.
    /// Releasing a suspended dispatch source traps in libdispatch.
    func testReleaseUnscheduledTimer() {
        var timer: RETimer? = RETimer(timeInterval: 1) { _ in
            XCTFail("An unscheduled timer should never fire.")
        }
        XCTAssertEqual(timer?.state, .initial)
        timer = nil
    }

    /// Invalidating a timer before scheduling must also release safely.
    func testInvalidateUnscheduledTimer() {
        var timer: RETimer? = RETimer(timeInterval: 1) { _ in
            XCTFail("An invalidated timer should never fire.")
        }
        timer?.invalidate()
        XCTAssertEqual(timer?.state, .invalidated)
        timer = nil
    }

    func testStateTransitions() {
        let timer = RETimer(timeInterval: 10) { _ in }

        XCTAssertEqual(timer.state, .initial)
        XCTAssertTrue(timer.schedule())
        XCTAssertEqual(timer.state, .running)

        timer.suspend()
        XCTAssertEqual(timer.state, .suspended)

        timer.resume()
        XCTAssertEqual(timer.state, .running)

        timer.invalidate()
        XCTAssertEqual(timer.state, .invalidated)
        XCTAssertFalse(timer.schedule())
    }

    func testTotalElapsedTimeExcludesSuspendedDuration() {
        let timer = RETimer.scheduledTimer(timeInterval: 10) { _ in }

        Thread.sleep(forTimeInterval: 0.15)
        timer.suspend()

        let elapsedBeforeSuspend = timer.totalElapsedTime
        XCTAssertGreaterThan(elapsedBeforeSuspend, 0.1)

        Thread.sleep(forTimeInterval: 0.2)
        XCTAssertEqual(timer.totalElapsedTime, elapsedBeforeSuspend, accuracy: 0.03)

        timer.resume()
        Thread.sleep(forTimeInterval: 0.15)
        XCTAssertGreaterThan(timer.totalElapsedTime, elapsedBeforeSuspend + 0.1)

        timer.invalidate()
    }

    func testScheduledTimerEverySecondTicks() {
        let expectation = self.expectation(description: "every second")
        var observedSeconds: [Int] = []

        let timer = RETimer.scheduledTimerEverySecond { timer, displaySeconds, _ in
            observedSeconds.append(displaySeconds)
            if displaySeconds >= 1 {
                timer.invalidate()
                expectation.fulfill()
            }
        }
        _ = timer

        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertEqual(observedSeconds, [0, 1])
    }

    func testScheduledTimerEverySecondSkipsInitialCallbackWhenSuspendedOrInvalidated() {
        var suspendedCallbacks = 0
        let suspendedTimer = RETimer.scheduledTimerEverySecond { _, _, _ in
            suspendedCallbacks += 1
        }
        suspendedTimer.suspend()

        var invalidatedCallbacks = 0
        let invalidatedTimer = RETimer.scheduledTimerEverySecond { _, _, _ in
            invalidatedCallbacks += 1
        }
        invalidatedTimer.invalidate()

        RunLoop.current.run(until: Date().addingTimeInterval(0.15))

        XCTAssertEqual(suspendedCallbacks, 0)
        XCTAssertEqual(invalidatedCallbacks, 0)
        suspendedTimer.invalidate()
    }

    func testInvalidateReleasesCapturedObject() {
        final class Token {}
        weak var weakToken: Token?

        let timer: RETimer = {
            let token = Token()
            weakToken = token
            return RETimer.scheduledTimer(timeInterval: 10) { _ in
                _ = token
            }
        }()

        XCTAssertNotNil(weakToken)
        timer.invalidate()
        XCTAssertNil(weakToken)
    }
}
