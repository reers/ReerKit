//
//  ThrottlerTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/2/24.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class ThrottlerTests: XCTestCase {

    let throttler = Throttler(queue: .main, performMode: .first)
    func testThrottler() {
        let expectation = self.expectation(description: "Throttler")
        for i in 0...10 {
            throttler.execute(interval: 2) {
                XCTAssertEqual(i, 0)
            }
        }

        DispatchQueue.main.re.asyncAfter(delay: 2) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.5, handler: nil)
    }

    let throttler1 = Throttler(queue: .main, performMode: .last)
    func testThrottler1() {
        let expectation = self.expectation(description: "Throttler1")
        for i in 0...10 {
            throttler1.execute(interval: 2) {
                XCTAssertEqual(i, 10)
            }
        }

        DispatchQueue.main.re.asyncAfter(delay: 2) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.5, handler: nil)
    }
}
