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
        XCTAssertEqual("jk123".data(using: .utf8)?.re.hexString, "6a6b313233")
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
        XCTAssertEqual(objectData?.re.stringDictionary?["message"], "hello")

        let arrayData = "[\"hello\"]".data(using: .utf8)
        let array = (try? arrayData?.re.jsonValue()) as? [String]
        XCTAssertNotNil(array)
        XCTAssertEqual(array?.first, "hello")
        XCTAssertNil(arrayData?.re.dictionary)
        XCTAssertEqual((arrayData?.re.array as? [String])?.first, "hello")
    }

    func testHash() {
        let data = "123".re.utf8Data!

        XCTAssertEqual(data.re.md2String, "ef1fedf5d32ead6b7aaf687de4ed1b71")
        XCTAssertEqual(data.re.md4String, "c58cda49f00748a3bc0fcfa511d516cb")
        XCTAssertEqual(data.re.md5String, "202cb962ac59075b964b07152d234b70")
        XCTAssertEqual(data.re.sha1String, "40bd001563085fc35165329ea1ff5c5ecbdbbeef")
        XCTAssertEqual(data.re.sha224String, "78d8045d684abd2eece923758f3cd781489df3a48e1278982466017f")
        XCTAssertEqual(data.re.sha256String, "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3")
        XCTAssertEqual(data.re.sha384String, "9a0a82f0c0cf31470d7affede3406cc9aa8410671520b727044eda15b4c25532a9b5cd8aaf9cec4919d76255b6bfb00f")
        XCTAssertEqual(data.re.sha512String, "3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2")
    }
}

#endif
