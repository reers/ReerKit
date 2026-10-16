//
//  ArrayExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/9/19.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class ArrayExtensionsTests: XCTestCase {

    func testArrayExtensions() {
        var array = [2, 3, 4, 5]
        array.re.prepend(1)
        XCTAssertEqual(array, [1, 2, 3, 4, 5])

        array.re.swapAt(0, 1)
        XCTAssertEqual(array, [2, 1, 3, 4, 5])
        array.re.swapAt(0, 10)
        XCTAssertEqual(array, [2, 1, 3, 4, 5])
    }

    func testArrayEquatableExtensions() {
        var array = [1, 2, 2, 3, 4, 5]
        array.re.removeAll(2)
        XCTAssertEqual(array, [1, 3, 4, 5])

        array = [1, 2, 2, 3, 4, 5]
        array.re.removeDuplicates()
        XCTAssertEqual(array, [1, 2, 3, 4, 5])
    }

    private struct Sticker: Hashable {
        var id: Int?
        var resource: String?
    }

    @inline(never)
    private static func merge(_ a: [Sticker], _ b: [Sticker], _ c: [Sticker]) -> [Sticker] {
        var result = a + b + c
        result.re.removeDuplicates()
        return result
    }

    @inline(never)
    private static func prependAndSwap(_ values: [Int]) -> [Int] {
        var result = values
        result.re.prepend(-1)
        result.re.swapAt(0, result.count - 1)
        return result
    }

    // Must also pass under the Release configuration, where optimizations used to expose a dangling pointer.
    func testMutatingNamespaceOnLocalVariable() {
        let stickers = (0..<50).map { Sticker(id: $0, resource: "res_\($0)") }
        for _ in 0..<2000 {
            XCTAssertEqual(Self.merge(stickers, stickers, stickers), stickers)
        }
        for _ in 0..<2000 {
            XCTAssertEqual(Self.prependAndSwap([1, 2, 3]), [3, 1, 2, -1])
        }
    }

    func testMutatingNamespaceOnBackgroundQueue() {
        let stickers = (0..<50).map { Sticker(id: $0, resource: "res_\($0)") }
        DispatchQueue.concurrentPerform(iterations: 2000) { _ in
            XCTAssertEqual(Self.merge(stickers, stickers, stickers), stickers)
        }
    }

    func testMutatingNamespaceDoesNotCopyBuffer() {
        var array = Array(0..<1000)
        let before = array.withUnsafeBufferPointer { $0.baseAddress }
        array.re.swapAt(0, 999)
        let after = array.withUnsafeBufferPointer { $0.baseAddress }
        XCTAssertEqual(before, after)
        XCTAssertEqual(array.first, 999)
        XCTAssertEqual(array.last, 0)
    }

    func testWithoutDuplicatesUsingKeyPath() {
        let array = [
            Person(name: "Wade", age: 20, location: Location(city: "London")),
            Person(name: "James", age: 32),
            Person(name: "James", age: 36),
            Person(name: "Rose", age: 29),
            Person(name: "James", age: 72, location: Location(city: "Moscow")),
            Person(name: "Rose", age: 56),
            Person(name: "Wade", age: 22, location: Location(city: "Prague"))
        ]
        let arrayWithoutDuplicatesHashable = array.re.removingDuplicates(byKeyPath: \.name)
        let arrayWithoutDuplicatesHashablePrepared = [
            Person(name: "Wade", age: 20, location: Location(city: "London")),
            Person(name: "James", age: 32),
            Person(name: "Rose", age: 29)
        ]
        XCTAssertEqual(arrayWithoutDuplicatesHashable, arrayWithoutDuplicatesHashablePrepared)
        let arrayWithoutDuplicatesNHashable = array.re.removingDuplicates(byKeyPath: \.location)
        let arrayWithoutDuplicatesNHashablePrepared = [
            Person(name: "Wade", age: 20, location: Location(city: "London")),
            Person(name: "James", age: 32),
            Person(name: "James", age: 72, location: Location(city: "Moscow")),
            Person(name: "Wade", age: 22, location: Location(city: "Prague"))
        ]
        XCTAssertEqual(arrayWithoutDuplicatesNHashable, arrayWithoutDuplicatesNHashablePrepared)
    }
    
    func testJSON() {
        let array = [
            [
            "abc":123,
            "haha": ["name":"phoenix"]
            ]
        ]
        let jsonString = array.re.jsonString()
        XCTAssert((jsonString == "[{\"haha\":{\"name\":\"phoenix\"},\"abc\":123}]") || (jsonString == "[{\"abc\":123,\"haha\":{\"name\":\"phoenix\"}}]"))
        let data = array.re.jsonData()!
        let dict = data.re.array?[0] as? Dictionary<String, Any>
        XCTAssertEqual(dict?["abc"] as! Int, 123)
    }
    
    func testAppendSingleElement() {
        var numbers = [1, 2, 3]
        numbers.re.appendIfNotExist(2)
        numbers.re.appendIfNotExist(4)
        XCTAssertEqual(numbers, [1, 2, 3, 4])
    }
    
    func testAppendMultipleElements() {
        var numbers = [1, 2, 3]
        numbers.re.appendIfNotExist(contentsOf: [2, 3, 4, 5])
        XCTAssertEqual(numbers, [1, 2, 3, 4, 5])
    }

}
