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
        let newArray = [Int].re(expression: array.removeLast(), count: array.count)
        XCTAssertEqual(newArray, [3, 2, 1])
        XCTAssert(array.isEmpty)
        let empty = [Int].re(expression: 1, count: 0)
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

    func testIntSubscriptsForString() {
        // Getter
        var string = "012345"
        XCTAssertEqual(string.re[0], "0")
        XCTAssertEqual(string.re[5], "5")
        XCTAssertEqual(string.re[6], nil)
        XCTAssertEqual(string.re[-1], nil)
        
        // Setter
        string = "012345"
        string.re[0] = "a"
        XCTAssertEqual(string, "a12345")
        
        string = "012345"
        string.re[0] = nil
        XCTAssertEqual(string, "12345")
        
        string = "012345"
        string.re[7] = "a"
        XCTAssertEqual(string, "012345")
    }
    
    func testIntSubscriptsForArray() {
        // Getter
        var array = [0, 1, 2, 3, 4, 5]
        XCTAssertEqual(array.re[0], 0)
        XCTAssertEqual(array.re[5], 5)
        XCTAssertEqual(array.re[6], nil)
        XCTAssertEqual(array.re[-1], nil)
        
        // Setter
        array = [0, 1, 2, 3, 4, 5]
        array.re[0] = 9
        XCTAssertEqual(array, [9, 1, 2, 3, 4, 5])
        
        array = [0, 1, 2, 3, 4, 5]
        array.re[0] = nil
        XCTAssertEqual(array, [1, 2, 3, 4, 5])
        
        array = [0, 1, 2, 3, 4, 5]
        array.re[7] = 9
        XCTAssertEqual(array, [0, 1, 2, 3, 4, 5])
    }
    
    func testIntRangeSubscriptsForString() {
        // Getter
        var string = "012345"
        XCTAssertEqual(string.re[1..<3], "12")
        XCTAssertEqual(string.re[..<3], "012")
        XCTAssertEqual(string.re[-2..<3], "012")
        XCTAssertEqual(string.re[3..<10], "345")
        
        XCTAssertEqual(string.re[3...], "345")
        XCTAssertEqual(string.re[7...], nil)
        XCTAssertEqual(string.re[-10..<(-1)], nil)
        
        // Setter
        string = "012345"
        string.re[0..<1] = "a"
        XCTAssertEqual(string, "a12345")
        
        string = "012345"
        string.re[0..<1] = nil
        XCTAssertEqual(string, "12345")
        
        string = "012345"
        string.re[0..<1] = ""
        XCTAssertEqual(string, "12345")
        
        string = "012345"
        string.re[7...] = "a"
        XCTAssertEqual(string, "012345")
        
        string = "012345"
        string.re[0...5] = "a"
        XCTAssertEqual(string, "a")
        
        string = "012345"
        string.re[-1...6] = nil
        XCTAssertEqual(string, "")
    }
    
    func testIntRangeSubscriptsForArray() {
        // Getter
        var array = [0, 1, 2, 3, 4, 5]
        XCTAssertEqual(array.re[1..<3], [1, 2])
        XCTAssertEqual(array.re[..<3], [0, 1, 2])
        XCTAssertEqual(array.re[-2..<3], [0, 1, 2])
        XCTAssertEqual(array.re[3..<10], [3, 4, 5])
        XCTAssertEqual(array.re[3...], [3, 4, 5])
        XCTAssertEqual(array.re[7...], nil)
        XCTAssertEqual(array.re[-10..<(-1)], nil)
        
        // Setter
        array = [0, 1, 2, 3, 4, 5]
        array.re[0..<1] = [9]
        XCTAssertEqual(array, [9, 1, 2, 3, 4, 5])
        
        array = [0, 1, 2, 3, 4, 5]
        array.re[0..<1] = nil
        XCTAssertEqual(array, [1, 2, 3, 4, 5])
        
        array = [0, 1, 2, 3, 4, 5]
        array.re[0..<1] = []
        XCTAssertEqual(array, [1, 2, 3, 4, 5])
        
        array = [0, 1, 2, 3, 4, 5]
        array.re[7...] = [9]
        XCTAssertEqual(array, [0, 1, 2, 3, 4, 5])
        
        array = [0, 1, 2, 3, 4, 5]
        array.re[0...5] = [9]
        XCTAssertEqual(array, [9])
        
        array = [0, 1, 2, 3, 4, 5]
        array.re[0...5] = []
        XCTAssertEqual(array, [])
    }
}
