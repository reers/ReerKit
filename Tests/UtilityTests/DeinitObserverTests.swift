//
//  DeinitObserverTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/18.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class DeinitObserverTests: XCTestCase {
    class Foo {}
    
    func testDeinitObserver() {
        let expectation = self.expectation(description: "testDeinitObserver")
        var result = 0
        var foo: Foo? = Foo()
        observeDeinit(for: foo!) {
            result = 1
        }

        RETimer.after(0.5) {
            foo = nil
        }
        
        RETimer.after(1) {
            XCTAssertEqual(result, 1)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.5, handler: nil)
    }
}
