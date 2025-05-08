//
//  CollectionExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/9/20.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class CollectionExtensionsTests: XCTestCase {
    let collection = [1, 2, 3, 4, 5]

    func testFullRange() {
        XCTAssertEqual(collection.re.fullRange, 0..<5)
        XCTAssertEqual([].re.fullRange, 0..<0)
    }

    func testForEachInParallel() {
        let expectation = XCTestExpectation(description: "forEachInParallel")

        var count = 0
        let countQueue = DispatchQueue.global()
        collection.re.forEachInParallel {
            XCTAssert(collection.contains($0))
            countQueue.async {
                count += 1
                if count == self.collection.count {
                    expectation.fulfill()
                }
            }
        }
        if count != collection.count {
            wait(for: [expectation], timeout: 1.0)
        }
    }

    func testSafeSubscript() {
        XCTAssertNotNil(collection.re[2])
        XCTAssertEqual(collection.re[2], 3)
        XCTAssertNil(collection.re[10])
        XCTAssertEqual(collection.re[10, default: -999], -999)
    }

    func testIndicesWhere() {
        let array: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        let indices = array.re.indices { $0 % 2 == 0 }
        XCTAssertEqual(indices, [0, 2, 4, 6, 8])
        let emptyArray: [Int] = []
        let emptyIndices = emptyArray.re.indices { $0 % 2 == 0 }
        XCTAssertNil(emptyIndices)
    }

    func testForEachSlice() {
        // A slice with value zero
        var iterations: Int = 0
        var array: [String] = ["james", "irving", "jordan", "jonshon", "iverson", "shaq"]
        array.re.forEach(slice: 0) { _ in
            iterations += 1
        }
        XCTAssertEqual(iterations, 0)

        // A slice that divide the total evenly
        array = ["james", "irving", "jordan", "jonshon", "iverson", "shaq"]
        array.re.forEach(slice: 2) { sliceArray in
            switch iterations {
            case 0: XCTAssertEqual(sliceArray, ["james", "irving"])
            case 1: XCTAssertEqual(sliceArray, ["jordan", "jonshon"])
            case 2: XCTAssertEqual(sliceArray, ["iverson", "shaq"])
            default: break
            }
            iterations += 1
        }
        XCTAssertEqual(iterations, 3)

        // A slice that does not divide the total evenly
        iterations = 0
        array = ["james", "irving", "jordan", "jonshon", "iverson", "shaq", "bird"]
        array.re.forEach(slice: 2) { sliceArray in
            switch iterations {
            case 0: XCTAssertEqual(sliceArray, ["james", "irving"])
            case 1: XCTAssertEqual(sliceArray, ["jordan", "jonshon"])
            case 2: XCTAssertEqual(sliceArray, ["iverson", "shaq"])
            case 3: XCTAssertEqual(sliceArray, ["bird"])
            default: break
            }
            iterations += 1
        }
        XCTAssertEqual(iterations, 4)

        // A slice greater than the array count
        iterations = 0
        array = ["james", "irving", "jordan", "jonshon"]
        array.re.forEach(slice: 6) { sliceArray in
            XCTAssertEqual(sliceArray, ["james", "irving", "jordan", "jonshon"])
            iterations += 1
        }
        XCTAssertEqual(iterations, 1)

        iterations = 0

        // Empty array
        array = []
        array.re.forEach(slice: 1) { _ in
            XCTFail("Should not find any slices")
            iterations += 1
        }
        XCTAssertEqual(iterations, 0)
    }

    func testGroupBySize() {
        // A slice with value zero
        var array: [String] = ["james", "irving", "jordan", "jonshon", "iverson", "shaq"]
        var slices = array.re.group(by: 0)
        XCTAssertNil(slices)

        // A slice that divide the total evenly
        array = ["james", "irving", "jordan", "jonshon", "iverson", "shaq"]
        slices = array.re.group(by: 2)
        XCTAssertNotNil(slices)
        XCTAssertEqual(slices?.count, 3)

        // A slice that does not divide the total evenly
        array = ["james", "irving", "jordan", "jonshon", "iverson", "shaq", "bird"]
        slices = array.re.group(by: 2)
        XCTAssertNotNil(slices)
        XCTAssertEqual(slices?.count, 4)

        // A slice greater than the array count
        array = ["james", "irving", "jordan", "jonshon"]
        slices = array.re.group(by: 6)
        XCTAssertNotNil(slices)
        XCTAssertEqual(slices?.count, 1)
    }

    func testIndices() {
        XCTAssertEqual([].re.indices(of: 5), [])
        XCTAssertEqual([1, 1, 2, 3, 4, 1, 2, 1].re.indices(of: 5), [])
        XCTAssertEqual([1, 1, 2, 3, 4, 1, 2, 1].re.indices(of: 1), [0, 1, 5, 7])
        XCTAssertEqual(["a", "b", "c", "b", "4", "1", "2", "1"].re.indices(of: "b"), [1, 3])
    }

    func testAverage() {
        XCTAssertEqual([1.2, 2.3, 3.4, 4.5, 5.6].re.average(), 3.4)
        XCTAssertEqual([Double]().re.average(), 0)

        XCTAssertEqual([1, 2, 3, 4, 5].re.average(), 3)
        XCTAssertEqual([Int]().re.average(), 0)
    }
    
    func testForEachWithIndex() {
        var ret: [Int] = []
        ["a", "b", "c"].re.forEach { item, index in
            ret.append(index)
        }
        XCTAssertEqual(ret, [0, 1, 2])
        
        ret.removeAll()
        var retString = ""
        ["a", "b", "c"].re.forEach {
            retString += $0
            ret.append($1)
        }
        XCTAssertEqual(retString, "abc")
        XCTAssertEqual(ret, [0, 1, 2])
    }
}

