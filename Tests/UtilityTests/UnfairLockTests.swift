//
//  UnfairLockTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/17.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class UnfairLockTests: XCTestCase {

    func testUnfairLock() {
        var count = 0
        let lock = UnfairLock()
        
        let group = DispatchGroup()
        for _ in 0..<1000 {
            group.enter()
            DispatchQueue.global().async(group: group) {
                lock.lock()
                count += 1
                lock.unlock()
                group.leave()
            }
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                locked(lock) {
                    count -= 1
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            XCTAssertEqual(count, 0)
        }
    }

}
