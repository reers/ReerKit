//
//  RangeReplaceableCollectionExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/10/28.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

final class RangeReplaceableCollectionTests: XCTestCase {
    func testInitExpressionOfSize() {
        var array = [1, 2, 3]
        let newArray = [Int].re.with(expression: array.removeLast(), count: array.count)
        XCTAssertEqual(newArray, [3, 2, 1])
        XCTAssert(array.isEmpty)
        let empty = [Int].re.with(expression: 1, count: 0)
        XCTAssert(empty.isEmpty)
    }

    func testRemoveWhere() {
        var array = [0, 1, 2, 0, 3, 4, 5, 0, 0]
        array.re.removeFirst { $0 == 1 }
        XCTAssertEqual(array, [0, 2, 0, 3, 4, 5, 0, 0])
        array = []
        XCTAssertNil(array.re.removeFirst { $0 == 10 })
        array = [2, 2, 1, 2, 3]
        let removedElement = array.re.removeFirst { $0 == 2 }
        XCTAssertEqual(array, [2, 1, 2, 3])
        XCTAssertEqual(removedElement, 2)

        XCTAssertThrowsError(try array.re.removeFirst(where: { _ in throw NSError(domain: "", code: -1, userInfo: nil) }))
    }

    func testRemoveRandomElement() {
        var emptyArray = [Int]()
        XCTAssertNil(emptyArray.re.removeRandomElement())

        var array = [1, 2, 3]
        let elements = array.count
        let removedElement = array.re.removeRandomElement()!
        XCTAssertEqual(elements - 1, array.count)
        XCTAssertFalse(array.contains(removedElement))
    }

    func testKeepWhile() {
        var input = [2, 4, 6, 7, 8, 9, 10]
        input.re.keep(while: { $0 % 2 == 0 })
        XCTAssertEqual(input, [2, 4, 6])

        input = [7, 7, 8, 10]
        input.re.keep(while: { $0 % 2 == 0 })
        XCTAssertEqual(input, [Int]())
    }

    func testRemoveDuplicatesUsingKeyPathHashable() {
        var input = [Person(name: "Wade", age: 20, location: Location(city: "London")),
                     Person(name: "James", age: 32),
                     Person(name: "James", age: 36),
                     Person(name: "Rose", age: 29),
                     Person(name: "James", age: 72, location: Location(city: "Moscow")),
                     Person(name: "Rose", age: 56),
                     Person(name: "Wade", age: 22, location: Location(city: "Prague"))]

        let expectedResult = [Person(name: "Wade", age: 20, location: Location(city: "London")),
                              Person(name: "James", age: 32),
                              Person(name: "Rose", age: 29)]

        input.re.removeDuplicates(keyPath: \.name)
        XCTAssertEqual(input, expectedResult)
    }

    func testRemoveDuplicatesUsingKeyPathEquatable() {
        var input = [Person(name: "Wade", age: 20, location: Location(city: "London")),
                     Person(name: "James", age: 32),
                     Person(name: "James", age: 36),
                     Person(name: "Rose", age: 29),
                     Person(name: "James", age: 72, location: Location(city: "Moscow")),
                     Person(name: "Rose", age: 56),
                     Person(name: "Wade", age: 22, location: Location(city: "Prague"))]

        let expectedResult = [Person(name: "Wade", age: 20, location: Location(city: "London")),
                              Person(name: "James", age: 32),
                              Person(name: "James", age: 72, location: Location(city: "Moscow")),
                              Person(name: "Wade", age: 22, location: Location(city: "Prague"))]

        input.re.removeDuplicates(keyPath: \.location)
        XCTAssertEqual(input, expectedResult)
    }

    func testIntSubscripts() {
        var string = "Hello world!"
        XCTAssertEqual(string.re[0], "H")
        XCTAssertEqual(string.re[11], "!")

        XCTAssertEqual(string.re[0..<5], "Hello")
        XCTAssertEqual(string.re[6..<12], "world!")

        XCTAssertEqual(string.re[0...4], "Hello")
        XCTAssertEqual(string.re[6...11], "world!")

        XCTAssertEqual(string.re[0...], "Hello world!")

        XCTAssertEqual(string.re[...11], "Hello world!")

        XCTAssertEqual(string.re[..<16], "Hello world!")

        string.re[0] = "h"
        XCTAssertEqual(string, "hello world!")
        string.re[11] = "?"
        XCTAssertEqual(string, "hello world?")

        string.re[0..<5] = "Goodbye"
        XCTAssertEqual(string, "Goodbye world?")
        string.re[8..<14] = "planet!"
        XCTAssertEqual(string, "Goodbye planet!")

        string.re[0...6] = "Hello"
        XCTAssertEqual(string, "Hello planet!")
        string.re[6...12] = "world?"
        XCTAssertEqual(string, "Hello world?")

        string.re[5...] = "!"
        XCTAssertEqual(string, "Hello!")

        string.re[..<6] = "Hello Ferris"
        XCTAssertEqual(string, "Hello Ferris")

        string.re[...4] = "Save"
        XCTAssertEqual(string, "Save Ferris")
    }
}
