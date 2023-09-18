//
//  GlobalFunctions.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/29.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class GlobalFunctions: XCTestCase {
    
    func testQueueLabel() {
        XCTAssertEqual("com.apple.main-thread", currentQueueLabel())
        DispatchQueue.global().sync {
            XCTAssertEqual("com.apple.root.default-qos", currentQueueLabel())
        }
    }
    
    func testAsyncOnMainQueue() {
        DispatchQueue.global().async {
            asyncOnMainQueue {
                XCTAssertEqual(true, DispatchQueue.re.isOnMainQueue)
            }
        }
    }
    
    func testSyncOnMainQueue() {
        DispatchQueue.global().async {
            syncOnMainQueue {
                XCTAssertEqual(true, DispatchQueue.re.isOnMainQueue)
            }
        }
    }
    
    func testAsyncOnGlobalQueue() {
        asyncOnGlobalQueue {
            XCTAssertEqual(false, DispatchQueue.re.isOnMainQueue)
            asyncOnMainQueue {
                XCTAssertEqual(true, DispatchQueue.re.isOnMainQueue)
            }
        }
    }
    
    func testsyncOnGlobalQueue() {
        syncOnGlobalQueue {
            XCTAssertEqual(false, DispatchQueue.re.isOnMainQueue)
        }
    }
}
