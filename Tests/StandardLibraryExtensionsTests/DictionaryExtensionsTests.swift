//
//  DictionaryExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/11/5.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class DictionaryExtensionsTests: XCTestCase {

    func testDMLAccess() {
        let dict = ["name": "phoenix", "age": "32", "666": "reer", "file_ext": "swift"]
        XCTAssertEqual(dict.dml.name!, "phoenix")
        XCTAssertEqual(dict.dml.age.re.intValue, 32)
        XCTAssertEqual(dict.dml.test, nil)
        XCTAssertEqual(dict.dml.666!, "reer")
        XCTAssertEqual(dict.dml.file_ext!, "swift")
    }

    var testDict: [String: Any] = ["testKey": "testValue", "testArrayKey": [1, 2, 3, 4, 5]]

    func testHasKey() {
        XCTAssert(testDict.re.has(key: "testKey"))
        XCTAssertFalse(testDict.re.has(key: "anotherKey"))
    }

    func testQueryString() {
        let dict = ["k1": "v1", "k2": "v2"]
        XCTAssertEqual(dict.re.queryString, "k1=v1&k2=v2")
    }

    func testInitGroupedByKeyPath() {
        let array1 = ["James", "Wade", "Bryant", "John"]
        let array2 = ["James", "Wade", "Bryant", "John", "", ""]
        let array3: [String] = []

        XCTAssertEqual(
            Dictionary.re(array1, groupBy: \String.count),
            [6: ["Bryant"], 5: ["James"], 4: ["Wade", "John"]])
        XCTAssertEqual(
            Dictionary.re(array1, groupBy: \String.first),
            [Optional("B"): ["Bryant"], Optional("J"): ["James", "John"], Optional("W"): ["Wade"]])
        XCTAssertEqual(
            Dictionary.re(array2, groupBy: \String.count),
            [6: ["Bryant"], 5: ["James"], 4: ["Wade", "John"], 0: ["", ""]])
        XCTAssertEqual(Dictionary(grouping: array3, by: \String.count), [:])
    }

    func testRemoveAll() {
        var dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
        dict.re.removeAll(keys: ["key1", "key2"])
        XCTAssert(dict.keys.contains("key3"))
        XCTAssertFalse(dict.keys.contains("key1"))
        XCTAssertFalse(dict.keys.contains("key2"))
    }

    func testRemoveElementForRandomKey() {
        var emptyDict = [String: String]()
        XCTAssertNil(emptyDict.re.removeValueForRandomKey())

        var dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
        let elements = dict.count
        let removedElement = dict.re.removeValueForRandomKey()
        XCTAssertEqual(elements - 1, dict.count)
        XCTAssertFalse(dict.contains(where: { $0.value == removedElement }))
    }

    func testJsonData() {
        let dict = ["key": "value"]

        let jsonString = "{\"key\":\"value\"}"
        let jsonData = jsonString.data(using: .utf8)

        let prettyJsonString = "{\n  \"key\" : \"value\"\n}"
        let prettyJsonData = prettyJsonString.data(using: .utf8)

        XCTAssertEqual(dict.re.jsonData(), jsonData)
        XCTAssertEqual(dict.re.jsonData(prettify: true), prettyJsonData)

        XCTAssertNil(["key": NSObject()].re.jsonData())
        XCTAssertNil([1: 2].re.jsonData())
    }

    func testJsonString() {
        XCTAssertNotNil(testDict.re.jsonString())
        XCTAssertEqual(testDict.re.jsonString()?.contains("\"testArrayKey\":[1,2,3,4,5]"), true)
        XCTAssertEqual(testDict.re.jsonString()?.contains("\"testKey\":\"testValue\""), true)

        XCTAssertEqual(
            testDict.re.jsonString(prettify: true)?.contains("[\n    1,\n    2,\n    3,\n    4,\n    5\n  ]"),
            true)

        XCTAssertNil(["key": NSObject()].re.jsonString())
        XCTAssertNil([1: 2].re.jsonString())
    }

    func testKeysForValue() {
        let dict = ["key1": "value1", "key2": "value1", "key3": "value2"]
        let result = dict.re.keys(forValue: "value1")
        XCTAssert(result.contains("key1"))
        XCTAssert(result.contains("key2"))
        XCTAssertFalse(result.contains("key3"))
    }

    func testLowercaseAllKeys() {
        var dict = ["tEstKeY": "value"]
        dict.re.lowercaseAllKeys()
        XCTAssertEqual(dict, ["testkey": "value"])
    }

    func testSubscriptKeypath() {
        var json = ["key": ["key1": ["key2": "value"]]]

        XCTAssertNil(json.re[path: []] as? String)
        XCTAssertEqual(json.re[path: ["key", "key1"]] as? [String: String], ["key2": "value"])
        XCTAssertEqual(json.re[path: ["key", "key1", "key2"]] as? String, "value")
        json.re[path: ["key", "key1", "key2"]] = "newValue"
        XCTAssertEqual(json.re[path: ["key", "key1", "key2"]] as? String, "newValue")
    }

    func testSubscriptStringKeypath() {
        var json = ["key": ["key1": ["key2": "value"]]]

        XCTAssertNil(json.re[path: ""].re.string)
        XCTAssertEqual(json.re[path: "key.key1"] as? [String: String], ["key2": "value"])
        XCTAssertEqual(json.re[path: "key.key1.key2"].re.string, "value")
        json.re[path: "key.key1.key2"] = "newValue"
        XCTAssertEqual(json.re[path: "key.key1.key2"].re.string, "newValue")
    }

    func testOperatorPlus() {
        let dict: [String: String] = ["key1": "value1"]
        let dict2: [String: String] = ["key2": "value2"]
        let result = dict + dict2
        XCTAssert(result.keys.contains("key1"))
        XCTAssert(result.keys.contains("key2"))
    }

    func testOperatorMinus() {
        let dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
        let result = dict - ["key1", "key2"]
        XCTAssert(result.keys.contains("key3"))
        XCTAssertFalse(result.keys.contains("key1"))
        XCTAssertFalse(result.keys.contains("key2"))
    }

    func testOperatorPlusEqual() {
        var dict: [String: String] = ["key1": "value1"]
        let dict2: [String: String] = ["key2": "value2"]
        dict += dict2
        XCTAssert(dict.keys.contains("key1"))
        XCTAssert(dict.keys.contains("key2"))
    }

    func testOperatorRemoveKeys() {
        var dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
        dict -= ["key1", "key2"]
        XCTAssert(dict.keys.contains("key3"))
        XCTAssertFalse(dict.keys.contains("key1"))
        XCTAssertFalse(dict.keys.contains("key2"))
    }

    func testMapKeysAndValues() {
        let intToString = [0: "0", 1: "1", 2: "2", 3: "3", 4: "4", 5: "5", 6: "6", 7: "7", 8: "8", 9: "9"]

        let stringToInt: [String: Int] = intToString.re.mapKeysAndValues { key, value in
            return (String(describing: key), Int(value)!)
        }

        XCTAssertEqual(stringToInt, ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9])
    }

    func testCompactMapKeysAndValues() {
        // swiftlint:disable:next nesting
        enum IntWord: String {
            case zero
            case one
            case two
        }

        let strings = [
            0: "zero",
            1: "one",
            2: "two",
            3: "three"
        ]
        let words: [String: IntWord] = strings.re.compactMapKeysAndValues { key, value in
            guard let word = IntWord(rawValue: value) else { return nil }
            return (String(describing: key), word)
        }

        XCTAssertEqual(words, ["0": .zero, "1": .one, "2": .two])
    }

    func testGetByKeys() {
        let dict = ["James": 100,
                    "Wade": 200,
                    "Bryant": 500,
                    "John": 600,
                    "Jack": 1000]
        let picked = dict.re.pick(keys: ["James", "Wade", "Jack"])
        let empty1 = dict.re.pick(keys: ["Pippen", "Rodman"])
        XCTAssertEqual(picked, ["James": 100, "Wade": 200, "Jack": 1000])
        XCTAssertTrue(empty1.isEmpty)

        let optionalValuesDict = ["James": 100,
                                  "Wade": nil,
                                  "Bryant": 500,
                                  "John": nil,
                                  "Jack": 1000]

        let pickedWithOptionals = optionalValuesDict.re.pick(keys: ["James", "Bryant", "John"])
        XCTAssertEqual(pickedWithOptionals, ["James": Optional(100), "Bryant": Optional(500), "John": nil])

        let emptyDict = [String: Int]()
        let empty3 = emptyDict.re.pick(keys: ["James", "Bryant", "John"])
        XCTAssertTrue(empty3.isEmpty)
    }
}
