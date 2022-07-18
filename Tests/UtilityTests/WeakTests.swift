//
//  WeakTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/19.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class WeakTests: XCTestCase {

    func testWeakSet() {
        var aa: NSObject? = NSObject()
        let bb: NSObject? = NSObject()
        let set = WeakSet([aa!, bb!])
        for _ in set {
            
        }
        XCTAssertEqual(set.count, 2)
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            aa = nil
            XCTAssertEqual(set.count, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

}
