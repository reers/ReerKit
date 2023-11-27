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
    
    @RWLocked
    var array: [Int] = []
    
    func testRWLocked() {
        let expectation = expectation(description: #function)
        DispatchQueue.global().async {
            print("write group 1")
            self.$array.write {
                $0.append(1)
                print("append 1")
                sleep(1)
                $0.append(2)
                print("append 2")
            }
        }
        delay(0.5, onQueue: .global()) {
            print("write gourp 2")
            self.$array.write {
                $0.append(3)
                print("append 3")
            }
            XCTAssertEqual(self.array.re[0..<3], [1, 2, 3])
            expectation.fulfill()
        }
        delay(0.2, onQueue: .global()) {
            print("read group")
            self.$array.read {
                XCTAssertEqual($0, [1, 2])
                print("read")
            }
        }
        
        waitForExpectations(timeout: 10)
    }
}
