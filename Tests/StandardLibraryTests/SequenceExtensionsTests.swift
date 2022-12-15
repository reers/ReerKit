//
//  SequenceExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/13.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

private enum SequenceTestError: Error {
    case closureThrows
}

struct TestValue: Equatable, ExpressibleByIntegerLiteral {
    let value: Int

    init(integerLiteral value: Int) { self.value = value }
}

class SequenceExtensionsTests: XCTestCase {

    func testAllMatch() {
        let collection = [2, 4, 6, 8, 10, 12]
        XCTAssert(collection.re.all { $0 % 2 == 0 })
    }

    func testNoneMatch() {
        let collection = [3, 5, 7, 9, 11, 13]
        XCTAssert(collection.re.none { $0 % 2 == 0 })
    }
    
    func testAnyMatch() {
        let collection = [3, 5, 8, 9, 11, 13]
        XCTAssert(collection.re.any { $0 % 2 == 0 })
    }

    func testRejectWhere() {
        let input = [1, 2, 3, 4, 5]
        let output = input.re.reject { $0 % 2 == 0 }
        XCTAssertEqual(output, [1, 3, 5])
    }

    func testCountWhere() {
        let array = [1, 1, 1, 1, 4, 4, 1, 1, 1]
        let count = array.re.count { $0 % 2 == 0 }
        XCTAssertEqual(count, 2)
    }

    func testForReversedForEach() {
        let input = [1, 2, 3, 4, 5]
        var output: [Int] = []
        input.re.reversedForEach { output.append($0) }
        XCTAssertEqual(output.first, 5)
    }

    func testForEachWhere() {
        let input = [1, 2, 2, 2, 1, 4, 1]
        var output: [Int] = []
        input.re.forEach({ output.append($0 * 2) }, where: { $0 % 2 == 0 })
        XCTAssertEqual(output, [4, 4, 4, 8])
    }

    func testMapWhere() {
        let input = [1, 2, 3, 4, 5]
        let result = input.re.map({ $0.re.string }, where: { $0 % 2 == 0 })
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(["2", "4"], result)
    }


    func testDivided() {
        let input = [0, 1, 2, 3, 4, 5]
        let (even, odd) = input.re.divided { $0 % 2 == 0 }
        XCTAssertEqual(even, [0, 2, 4])
        XCTAssertEqual(odd, [1, 3, 5])

        // Parameter names + indexes
        let tuple = input.re.divided { $0 % 2 == 0 }
        XCTAssertEqual(tuple.matching, [0, 2, 4])
        XCTAssertEqual(tuple.0, [0, 2, 4])
        XCTAssertEqual(tuple.nonMatching, [1, 3, 5])
        XCTAssertEqual(tuple.1, [1, 3, 5])
    }

    func testContainsEquatable() {
        XCTAssert([TestValue]().re.contains([]))
        XCTAssertFalse([TestValue]().re.contains([1, 2]))
        XCTAssert(([1, 2, 3] as [TestValue]).re.contains([1, 2]))
        XCTAssert(([1, 2, 3] as [TestValue]).re.contains([2, 3]))
        XCTAssert(([1, 2, 3] as [TestValue]).re.contains([1, 3]))
        XCTAssertFalse(([1, 2, 3] as [TestValue]).re.contains([4, 5]))
    }

    func testContainsHashable() {
        XCTAssert([Int]().re.contains([]))
        XCTAssertFalse([Int]().re.contains([1, 2]))
        XCTAssert([1, 2, 3].re.contains([1, 2]))
        XCTAssert([1, 2, 3].re.contains([2, 3]))
        XCTAssert([1, 2, 3].re.contains([1, 3]))
        XCTAssertFalse([1, 2, 3].re.contains([4, 5]))
    }

    func testContainsDuplicates() {
        XCTAssertFalse([String]().re.containsDuplicates())
        XCTAssert(["a", "b", "b", "c"].re.containsDuplicates())
        XCTAssertFalse(["a", "b", "c", "d"].re.containsDuplicates())
    }

    func testDuplicates() {
        XCTAssertEqual([1, 1, 2, 2, 3, 3, 3, 4, 5].re.duplicates().sorted(), [1, 2, 3])
        XCTAssertEqual(["h", "e", "l", "l", "o"].re.duplicates().sorted(), ["l"])
    }

    func testSum() {
        XCTAssertEqual([1, 2, 3, 4, 5].re.sum(), 15)
        XCTAssertEqual([1.2, 2.3, 3.4, 4.5, 5.6].re.sum(), 17)
    }

    func testKeyPathSum() {
        XCTAssertEqual(["James", "Wade", "Bryant"].re.sum(for: \.count), 15)
        XCTAssertEqual(["a", "b", "c", "d"].re.sum(for: \.count), 4)
    }
    
    func testLast() {
        XCTAssertEqual([2, 2, 4, 7].re.last { $0 % 2 == 0 }, 4)
    }

    func testKeyPathSorted() {
        let array = ["James", "Wade", "Bryant"]
        XCTAssertEqual(array.re.sorted(by: \String.count, with: <), ["Wade", "James", "Bryant"])
        XCTAssertEqual(array.re.sorted(by: \String.count, with: >), ["Bryant", "James", "Wade"])

        // Comparable version
        XCTAssertEqual(array.re.sorted(by: \String.count), ["Wade", "James", "Bryant"])

        // Testing optional keyPath
        let optionalCompare = { (char1: Character?, char2: Character?) -> Bool in
            guard let char1 = char1, let char2 = char2 else { return false }
            return char1 < char2
        }

        let array2 = ["James", "Wade", "Bryant", ""]
        XCTAssertEqual(array2.re.sorted(by: \String.first, with: optionalCompare), ["Bryant", "James", "Wade", ""])
    }

    func testSortedByTwoKeyPaths() {
        let people = [
            SimplePerson(forename: "Tom", surname: "James", age: 32),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 57),
            SimplePerson(forename: "Max", surname: "James", age: 34)
        ]
        let expectedResult = [
            SimplePerson(forename: "Tom", surname: "James", age: 32),
            SimplePerson(forename: "Max", surname: "James", age: 34),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 57)
        ]
        XCTAssertEqual(people.re.sorted(by: \.surname, and: \.age), expectedResult)
    }

    func testSortedByThreeKeyPaths() {
        let people = [
            SimplePerson(forename: "Tom", surname: "James", age: 32),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 57),
            SimplePerson(forename: "Max", surname: "James", age: 34),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 82)
        ]
        let expectedResult = [
            SimplePerson(forename: "Max", surname: "James", age: 34),
            SimplePerson(forename: "Tom", surname: "James", age: 32),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 57),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 82)
        ]
        XCTAssertEqual(people.re.sorted(by: \.surname, and: \.forename, and: \.age), expectedResult)
    }
    
    
    func testWithoutDuplicates() {
        XCTAssertEqual([1, 2, 1, 3, 2].re.withoutDuplicates(), [1, 2, 3])
    }

}
