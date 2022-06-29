//
//  UtilsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/29.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class UtilsTests: XCTestCase {
    
    func testQueueLabel() {
        XCTAssertEqual("com.apple.main-thread", currentQueueLabel())
        DispatchQueue.global().sync {
            XCTAssertEqual("com.apple.root.default-qos", currentQueueLabel())
        }
    }
    
    func testAsyncOnMainQueue() {
        DispatchQueue.global().async {
            asyncOnMainQueue {
                XCTAssertEqual(true, DispatchQueue.re.isMainQueue)
            }
        }
    }
    
    func testSyncOnMainQueue() {
        DispatchQueue.global().async {
            syncOnMainQueue {
                XCTAssertEqual(true, DispatchQueue.re.isMainQueue)
            }
        }
    }
}
