//
//  DataExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/1.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

#if canImport(Foundation)
import Foundation

final class DataExtensionsTests: XCTestCase {
    func testString() {
        let dataFromString = "hello".data(using: .utf8)
        XCTAssertNotNil(dataFromString)
        XCTAssertNotNil(dataFromString?.re.string(encoding: .utf8))
        XCTAssertNotNil(dataFromString?.re.utf8String)
        XCTAssertEqual(dataFromString?.re.string(encoding: .utf8), "hello")
        XCTAssertEqual("123".data(using: .utf8)?.re.hexString, "313233")
    }

    func testBytes() {
        let dataFromString = "hello".data(using: .utf8)
        let bytes = dataFromString?.re.bytes
        XCTAssertNotNil(bytes)
        XCTAssertEqual(bytes?.count, 5)
    }

    func testJsonObject() {
        let invalidData = "hello".data(using: .utf8)
        XCTAssertThrowsError(try invalidData?.re.jsonValue())
        XCTAssertThrowsError(try invalidData?.re.jsonValue(options: [.allowFragments]))

        let stringData = "\"hello\"".data(using: .utf8)
        XCTAssertThrowsError(try stringData?.re.jsonValue())
        XCTAssertEqual((try? stringData?.re.jsonValue(options: [.allowFragments])) as? String, "hello")
        XCTAssertThrowsError(try stringData?.re.toDictionary())
        XCTAssertThrowsError(try stringData?.re.toArray())
        XCTAssertNil(stringData?.re.dictionary)
        XCTAssertNil(stringData?.re.array)

        let objectData = "{\"message\": \"hello\"}".data(using: .utf8)
        let object = objectData?.re.jsonValue as? [String: String]
        XCTAssertNotNil(object)
        XCTAssertEqual(object?["message"], "hello")
        XCTAssertEqual(objectData?.re.dictionary?["message"] as? String, "hello")
        XCTAssertNil(objectData?.re.array)

        let arrayData = "[\"hello\"]".data(using: .utf8)
        let array = (try? arrayData?.re.jsonValue()) as? [String]
        XCTAssertNotNil(array)
        XCTAssertEqual(array?.first, "hello")
        XCTAssertNil(arrayData?.re.dictionary)
        XCTAssertEqual((arrayData?.re.array as? [String])?.first, "hello")
    }
}

#endif
