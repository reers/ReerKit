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

    /// Calling `fire()` repeatedly must not create multiple underlying timers
    /// and deliver duplicated callbacks.
    func testDoubleFireDoesNotDuplicateCallbacks() {
        let expectation = self.expectation(description: "finished")
        var callbacks = 0

        let timer = CountdownTimer(interval: 0.1, times: 3) { timer in
            callbacks += 1
            if timer.finished {
                expectation.fulfill()
            }
        }

        timer.fire()
        timer.fire()
        timer.fire()

        waitForExpectations(timeout: 1.5, handler: nil)
        XCTAssertEqual(callbacks, 3)
    }

    func testZeroTimesDoesNotFire() {
        var callbacks = 0
        let timer = CountdownTimer(interval: 0.05, times: 0) { _ in
            callbacks += 1
        }

        timer.fire()
        runRunLoop(for: 0.3)

        XCTAssertEqual(callbacks, 0)
        XCTAssertTrue(timer.finished)
        XCTAssertEqual(timer.leftTimes, 0)
        XCTAssertEqual(timer.leftDuration, 0)
    }

    func testNegativeTimesAndDurationAreClamped() {
        let timer = CountdownTimer(interval: -0.1, times: -3) { _ in
            XCTFail("A countdown with no ticks should not fire.")
        }

        XCTAssertEqual(timer.interval, 0)
        XCTAssertEqual(timer.times, 0)
        XCTAssertEqual(timer.totalDuration, 0)
        XCTAssertEqual(timer.leftTimes, 0)
        XCTAssertEqual(timer.leftDuration, 0)
        XCTAssertTrue(timer.finished)

        timer.fire()
        runRunLoop(for: 0.2)
    }

    func testZeroTotalDurationDoesNotProduceNaNAndDoesNotFire() {
        var callbacks = 0
        let timer = CountdownTimer(times: 0, totalDuration: 10) { _ in
            callbacks += 1
        }

        XCTAssertFalse(timer.interval.isNaN)
        XCTAssertEqual(timer.interval, 0)
        XCTAssertEqual(timer.totalDuration, 0)
        XCTAssertEqual(timer.leftTimes, 0)
        XCTAssertTrue(timer.finished)

        timer.fire()
        runRunLoop(for: 0.2)
        XCTAssertEqual(callbacks, 0)
    }

    func testResetAndFireAgain() {
        let first = expectation(description: "first round")
        let second = expectation(description: "second round")
        var callbacks = 0

        let timer = CountdownTimer(interval: 0.05, times: 2) { _ in
            callbacks += 1
            if callbacks == 2 {
                first.fulfill()
            } else if callbacks == 4 {
                second.fulfill()
            }
        }

        timer.fire()
        wait(for: [first], timeout: 1)

        XCTAssertEqual(timer.leftTimes, 0)
        timer.reset()
        XCTAssertEqual(timer.leftTimes, 2)

        timer.fire()
        wait(for: [second], timeout: 1)
        XCTAssertEqual(callbacks, 4)
    }

    func testSuspendAndResume() {
        let finished = expectation(description: "resumed countdown finished")
        var callbacks = 0
        let timer = CountdownTimer(interval: 0.15, times: 3) { timer in
            callbacks += 1
            if timer.finished {
                finished.fulfill()
            }
        }

        timer.fire()
        timer.suspend()
        runRunLoop(for: 0.3)
        XCTAssertEqual(callbacks, 0)

        timer.resume()
        wait(for: [finished], timeout: 1.5)
        XCTAssertEqual(callbacks, 3)
    }

    func testScheduledTimerWithTotalSeconds() {
        let finished = expectation(description: "totalSeconds finished")
        var observedDisplaySeconds: [Int] = []

        let timer = CountdownTimer.scheduledTimer(withTotalSeconds: 2) { displaySeconds, leftDuration, passedDuration in
            observedDisplaySeconds.append(displaySeconds)
            XCTAssertGreaterThanOrEqual(leftDuration, 0)
            XCTAssertGreaterThanOrEqual(passedDuration, 0)
            if displaySeconds == 0 {
                finished.fulfill()
            }
        }

        wait(for: [finished], timeout: 3.0)
        XCTAssertEqual(observedDisplaySeconds, [1, 0])
        XCTAssertTrue(timer.finished)
        XCTAssertEqual(timer.leftTimes, 0)
    }

    func testConcurrentOperationsSafety() {
        let timer = CountdownTimer(interval: 0.005, times: 20) { _ in }
        let group = DispatchGroup()

        for index in 0..<40 {
            group.enter()
            DispatchQueue.global().async {
                switch index % 5 {
                case 0: timer.fire()
                case 1: timer.suspend()
                case 2: timer.resume()
                case 3: timer.reset()
                default: timer.invalidate()
                }
                XCTAssertGreaterThanOrEqual(timer.leftTimes, 0)
                group.leave()
            }
        }

        XCTAssertEqual(group.wait(timeout: .now() + 3), .success)
        runRunLoop(for: 0.05)
        timer.invalidate()
        XCTAssertGreaterThanOrEqual(timer.leftTimes, 0)
    }

    private func runRunLoop(for interval: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(interval))
    }
}
