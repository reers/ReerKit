//
//  WeakTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/19.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class TestKey: Hashable {
    static func == (lhs: TestKey, rhs: TestKey) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}

class WeakTests: XCTestCase {

    func testWeakSet() {
        var aa: NSObject? = NSObject()
        let bb: NSObject? = NSObject()
        var set: WeakSet<NSObject> = [aa!, bb!]
        XCTAssertEqual(set.count, 2)
        set = WeakSet([aa!, bb!])
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

    func testWeakKeyMap() {
        var aa: TestKey? = TestKey()
        let bb: TestKey? = TestKey()

        let map: WeakMap<WeakKey, TestKey, String>  = .init([aa!: "aa", bb!: "bb"])

        var count = 0
        map.forEach { key, value in
            count += 1
        }
        XCTAssertEqual(count, 2)

        XCTAssertEqual(map.count, 2)
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            aa = nil
            XCTAssertEqual(map.count, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testWeakValueMap() {
        var aa: NSObject? = NSObject()
        let bb: NSObject? = NSObject()

        let map: WeakMap<WeakValue, String, NSObject> = .init(["aa": aa!, "bb": bb!])

        var count = 0
        map.forEach { key, value in
            count += 1
        }
        XCTAssertEqual(count, 2)

        XCTAssertEqual(map.count, 2)
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            aa = nil
            XCTAssertEqual(map.count, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testWeakKeyValueMap() {
        var aa: TestKey? = TestKey()
        let bb: TestKey? = TestKey()
        var cc: NSObject? = NSObject()
        var dd: NSObject? = NSObject()

        let map: WeakMap<WeakKeyValue, TestKey, NSObject> = .init([aa!: cc!, bb!: dd!])

        var count = 0
        map.forEach { key, value in
            count += 1
        }
        XCTAssertEqual(count, 2)

        XCTAssertEqual(map.count, 2)
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            aa = nil
            cc = nil
            dd = nil
            XCTAssertEqual(map.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

}
