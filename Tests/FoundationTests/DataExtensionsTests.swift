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
    func testInit() {
        XCTAssertEqual(Data.re(hexString: "313233"), "123".re.utf8Data!)
    }

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

        // https://www.tools4noobs.com/online_tools/hash/
        XCTAssertEqual(data.re.md2String, "ef1fedf5d32ead6b7aaf687de4ed1b71")
        XCTAssertEqual(data.re.md4String, "c58cda49f00748a3bc0fcfa511d516cb")
        XCTAssertEqual(data.re.md5String, "202cb962ac59075b964b07152d234b70")
        XCTAssertEqual(data.re.sha1String, "40bd001563085fc35165329ea1ff5c5ecbdbbeef")
        XCTAssertEqual(data.re.sha224String, "78d8045d684abd2eece923758f3cd781489df3a48e1278982466017f")
        XCTAssertEqual(data.re.sha256String, "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3")
        XCTAssertEqual(data.re.sha384String, "9a0a82f0c0cf31470d7affede3406cc9aa8410671520b727044eda15b4c25532a9b5cd8aaf9cec4919d76255b6bfb00f")
        XCTAssertEqual(data.re.sha512String, "3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2")
    }

    func testHMAC() {
        let data = "123".re.utf8Data!
        let key = "reer"

        // https://www.freeformatter.com/hmac-generator.html#before-output
        XCTAssertEqual(data.re.hmacString(using: .md5, key: key), "d0e89aa8b7c6c8e87ac696ced0a24cab")
        XCTAssertEqual(data.re.hmacData(using: .md5, key: key)?.re.hexString, "d0e89aa8b7c6c8e87ac696ced0a24cab")

        XCTAssertEqual(data.re.hmacString(using: .sha1, key: key), "b46e171888933d33343231b0e723bbc66ac40645")
        XCTAssertEqual(data.re.hmacData(using: .sha1, key: key)?.re.hexString, "b46e171888933d33343231b0e723bbc66ac40645")

        XCTAssertEqual(data.re.hmacString(using: .sha224, key: key), "cde9fab2dd7d56d228fd5fe42be90bbb08232981a57c9ab1fe28c402")
        XCTAssertEqual(data.re.hmacData(using: .sha224, key: key)?.re.hexString, "cde9fab2dd7d56d228fd5fe42be90bbb08232981a57c9ab1fe28c402")

        XCTAssertEqual(data.re.hmacString(using: .sha256, key: key), "7b624987b6a41a7994c35e9f829a493798831c81ddccdd5fea9744ff429749be")
        XCTAssertEqual(data.re.hmacData(using: .sha256, key: key)?.re.hexString, "7b624987b6a41a7994c35e9f829a493798831c81ddccdd5fea9744ff429749be")

        XCTAssertEqual(data.re.hmacString(using: .sha384, key: key), "13ed12580b6ace99e3cba1137e3e318db23a5fb870f4fd7f3722ddfac4f1a2c85c6e09cf0af8eaa9b1e44ea85f010912")
        XCTAssertEqual(data.re.hmacData(using: .sha384, key: key)?.re.hexString, "13ed12580b6ace99e3cba1137e3e318db23a5fb870f4fd7f3722ddfac4f1a2c85c6e09cf0af8eaa9b1e44ea85f010912")

        XCTAssertEqual(data.re.hmacString(using: .sha512, key: key), "81578d57bc726570d0ed620e5c487a109588ea3e85993c79ec6e46b4c7af499b947e768eb52cedab6ddcb2da5e8c20d0d3e6a039dd23d1f86d34905c844332dd")
        XCTAssertEqual(data.re.hmacData(using: .sha512, key: key)?.re.hexString, "81578d57bc726570d0ed620e5c487a109588ea3e85993c79ec6e46b4c7af499b947e768eb52cedab6ddcb2da5e8c20d0d3e6a039dd23d1f86d34905c844332dd")
    }

    func testAes() {
        let data = "123".re.utf8Data!
        let key128 = Data.re(hexString: "000102030405060708090a0b0c0d0e0f")!
        let encrypted128 = data.re.aesEncrypt(withKey: key128)
        XCTAssertEqual(encrypted128?.re.aesDecrypt(withKey: key128)?.re.utf8String, "123")

        let key192 = Data.re(hexString: "000102030405060708090a0b0c0d0e0f1011121314151617")!
        let encrypted192 = data.re.aesEncrypt(withKey: key192)
        XCTAssertEqual(encrypted192?.re.aesDecrypt(withKey: key192)?.re.utf8String, "123")

        let key256 = Data.re(hexString: "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f")!
        let encrypted256 = data.re.aesEncrypt(withKey: key256)
        XCTAssertEqual(encrypted256?.re.aesDecrypt(withKey: key256)?.re.utf8String, "123")

        let iv = Data.re(hexString: "0f0e0d0c0b0a09080706050403020100")!
        let encryptedWithIV = data.re.aesEncrypt(withKey: key256, iv: iv)
        XCTAssertEqual(encryptedWithIV?.re.aesDecrypt(withKey: key256, iv: iv)?.re.utf8String, "123")
    }
}

#endif
