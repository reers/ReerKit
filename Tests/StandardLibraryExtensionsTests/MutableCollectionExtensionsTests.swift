//
//  MutableCollectionExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/10/27.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest

@testable import ReerKit

final class MutableCollectionTests: XCTestCase {
    func testKeyPathSort() {
        var array = ["James", "Wade", "Bryant"]
        array.re.sort(by: \String.count, with: <)
        XCTAssertEqual(array, ["Wade", "James", "Bryant"])
        array.re.sort(by: \String.count, with: >)
        XCTAssertEqual(array, ["Bryant", "James", "Wade"])

        // Comparable version
        array.re.sort(by: \String.count)
        XCTAssertEqual(array, ["Wade", "James", "Bryant"])

        // Testing optional keyPath
        let optionalCompare = { (char1: Character?, char2: Character?) -> Bool in
            guard let char1 = char1, let char2 = char2 else { return false }
            return char1 < char2
        }

        var array2 = ["James", "Wade", "Bryant", ""]
        array2.re.sort(by: \String.first, with: optionalCompare)
        XCTAssertEqual(array2, ["Bryant", "James", "Wade", ""])
    }

    func testSortByTwoKeyPaths() {
        var people = [
            SimplePerson(forename: "Tom", surname: "James", age: 32),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 57),
            SimplePerson(forename: "Max", surname: "James", age: 34)
        ]
        people.re.sort(by: \.surname, and: \.age)
        let expectedResult = [
            SimplePerson(forename: "Tom", surname: "James", age: 32),
            SimplePerson(forename: "Max", surname: "James", age: 34),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 57)
        ]
        XCTAssertEqual(people, expectedResult)
    }

    func testSortByThreeKeyPaths() {
        var people = [
            SimplePerson(forename: "Tom", surname: "James", age: 32),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 57),
            SimplePerson(forename: "Max", surname: "James", age: 34),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 82)
        ]
        people.re.sort(by: \.surname, and: \.forename, and: \.age)
        let expectedResult = [
            SimplePerson(forename: "Max", surname: "James", age: 34),
            SimplePerson(forename: "Tom", surname: "James", age: 32),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 57),
            SimplePerson(forename: "Angeline", surname: "Wade", age: 82)
        ]
        XCTAssertEqual(people, expectedResult)
    }

    func testAssignToAll() {
        var collection: [TestStruct] = [1, 2, 3, 4, 5]
        collection.re.assignToAll(value: 0, by: \.testField)
        let expectedCollection: [TestStruct] = [0, 0, 0, 0, 0]
        XCTAssertEqual(collection, expectedCollection)

        // check with an empty collection
        var initialEmptyCollection: [TestStruct] = []
        initialEmptyCollection.re.assignToAll(value: 5, by: \.testField)
        let expectedEmptyCollection: [TestStruct] = []
        XCTAssertEqual(initialEmptyCollection, expectedEmptyCollection)
    }
}
