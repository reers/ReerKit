//
//  OnceTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/22.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class OnceTests: XCTestCase {
    
    static var int = 0
    
    func initString() {
        once {
            Self.int += 1
        }
    }

    func testOnce() {
        var result = 0
        func foo() {
            once {
                result += 1
            }
        }
        foo()
        foo()
        XCTAssertEqual(result, 1)
        
        var ret = 0
        let token = OnceToken()
        once(token) { ret += 1 }
        once(token) { ret += 1 }
        once(token) { ret += 1 }
        XCTAssertEqual(ret, 1)
        
        deonce(token)
        once(token) { ret += 1 }
        XCTAssertEqual(ret, 2)
        
        initString()
        initString()
        initString()
        XCTAssertEqual(Self.int, 1)
    }

}
