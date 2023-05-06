//
//  DataStructuresTest.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/5/6.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class DataStructuresTest: XCTestCase {

    func testStack() {
        var stack = Stack<Int>()
        stack.push(1)
        stack.push(2)
        stack.push(3)
        XCTAssertEqual(stack.count, 3)
        XCTAssertEqual(stack.top, 3)
        stack.pop()
        XCTAssertEqual(stack.count, 2)
        XCTAssertEqual(stack.top, 2)
        print(stack)
    }

    func testQueue() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        XCTAssertEqual(queue.count, 3)
        XCTAssertEqual(queue.front, 1)
        queue.dequeue()
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.front, 2)
        print(queue)
    }
    
    func testLinkedList() {
        var list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        print(list)
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list[0], 1)
        XCTAssertEqual(list.firstIndex(of: 2), 1)
        list.removeLast()
        XCTAssertEqual(list[list.count - 1], 2)
        list.removeFirst()
        XCTAssertEqual(list[list.count - 1], 2)
        
        list = [1, 2, 3]
        XCTAssertEqual(list.count, 3)
        list.removeAll { $0 % 2 == 0 }
        XCTAssertEqual(list[1], 3)
        for (index, item) in list.enumerated() {
            if index == 0 {
                XCTAssertEqual(item, 1)
            }
        }
    }
}
