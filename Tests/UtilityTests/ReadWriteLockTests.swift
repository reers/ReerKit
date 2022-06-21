//
//  ReadWriteLockTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/17.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class ReadWriteLockTests: XCTestCase {

    func testReadWriteLock() {
        var result = ""
        let rwlock = ReadWriteLock()
        DispatchQueue.global().async {
            
            rwlock.writeLock()
            result += "1"
            for _ in 0...10000 {
                // do something
            }
            result += "2"
            rwlock.writeUnlock()
        }
        for i in 0...10 {
            DispatchQueue.global().async {
                rwlock.readLock()
                result += "3"
                for _ in 0..<i {}
                rwlock.readUnlock()
                if i == 0 {
                    XCTAssertTrue(result.hasPrefix("123"))
                }
            }
        }
    }
    
    func testReadWriteLockClosure() {
        var result = ""
        let rwlock = ReadWriteLock()
        DispatchQueue.global().async {
            writeLocked(rwlock) {
                result += "1"
                for _ in 0...10000 {
                    // do something
                }
                result += "2"
            }
        }
        for i in 0...10 {
            DispatchQueue.global().async {
                readLocked(rwlock) {
                    result += "3"
                    for _ in 0..<i {}
                }
                if i == 0 {
                    XCTAssertTrue(result.hasPrefix("123"))
                }
            }
        }
    }

}
