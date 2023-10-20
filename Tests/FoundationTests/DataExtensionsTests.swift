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

    func testCompression() {
        let data = "123234234234234234wfasdfasfasdfasdfasdfasdf".re.utf8Data!
        XCTAssertEqual(data.re.zlibCompressed(level: .bestCompression)?.re.zlibDecompressed(), data)
        XCTAssertEqual(data.re.gzipCompressed(level: .bestSpeed)?.re.gzipDecompressed(), data)
        XCTAssertLessThan(data.re.zlibCompressed(level: .bestCompression)!.count, data.re.zlibCompressed(level: .bestSpeed)!.count)
        XCTAssertLessThan(data.re.gzipCompressed(level: .bestCompression)!.count, data.re.gzipCompressed(level: .bestSpeed)!.count)
        XCTAssertTrue(data.re.gzipCompressed()!.re.isGzipped)
        XCTAssertTrue(data.re.zlibCompressed(level: .defaultCompression)!.re.isZlibbed)
        XCTAssertTrue(data.re.zlibCompressed(level: .noCompression)!.re.isZlibbed)
        XCTAssertTrue(data.re.zlibCompressed(level: .bestSpeed)!.re.isZlibbed)
        XCTAssertTrue(data.re.zlibCompressed(level: .bestCompression)!.re.isZlibbed)
        XCTAssertTrue(data.re.zlibCompressed(level: CompressionLevel(rawValue: 2))!.re.isZlibbed)
    }
    
    func testRSA() {
        // 512 bit
        do {
            let publicKey = """
            -----BEGIN PUBLIC KEY-----
            MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAOp23au8FSO6GoU6WL7XJOKX6FzME5VR
            5GZfy9cdDxaixJTiYE+yqPVPuvuT7np9/uVAPNS5fhMcQ+irU+44SVECAwEAAQ==
            -----END PUBLIC KEY-----
            """
            let privateKey = """
            -----BEGIN RSA PRIVATE KEY-----
            MIIBOwIBAAJBAOp23au8FSO6GoU6WL7XJOKX6FzME5VR5GZfy9cdDxaixJTiYE+y
            qPVPuvuT7np9/uVAPNS5fhMcQ+irU+44SVECAwEAAQJAJ5bukyLtBt1TwQ87EO5P
            AhvYVmL3I41yXX7rcmUruQxsHGF+BiqQRs9wC+YAFnPo6Mg6VTr+Bom56ZJb+JXN
            KQIhAPQ68HoPCFjBLF+8B2Ixxa+khp2cVn06V3oorRj4si9vAiEA9cNx3e6qQbx+
            /kPlqQGDiGCrfAXguvJoJkFxubYMsz8CIQClKba21LOwUfLQSzgzD7XAsmLW84MJ
            7Qp7ckadPJJDwQIgQRazOJD2HJTcmWDIGVuiR2M654zy+PAsbz1T7lhtwqcCIQCf
            /gVQunFsqciQXZFrC3STSjn+tpcR5BqSjL5oxHtVgA==
            -----END RSA PRIVATE KEY-----
            """
            let original = String.re.random(ofLength: Int.random(in: 1...100))
            let encrypted1 = original.re.utf8Data!.re.rsaEncrypt(withPublicKey: publicKey)
            let ret1 = encrypted1!.re.rsaDecrypt(withPrivateKey: privateKey)!.re.utf8String!
            XCTAssertEqual(original, ret1)
            
            let encrypted2 = original.re.utf8Data!.re.rsaEncrypt(withPrivateKey: privateKey)
            let ret2 = encrypted2!.re.rsaDecrypt(withPublicKey: publicKey)!.re.utf8String!
            XCTAssertEqual(original, ret2)
        }
        // 2048 bit
        do {
            let publicKey = """
            -----BEGIN PUBLIC KEY-----
            MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm0bdWFyPZiY/zqV8sYB+
            7j4tYzacgKs2pI10s0gw730dxYuqIUzLvobWT9KzbYcSwuodw8wNHrUazakJ7Va6
            J/FSBgrUldpnnoW2CjUwrqrz5vaThKeHhIwKvQBTcik4kIXQxYtfO+jkSzo+ix/0
            KxZLGV282awg7U0Ny0H7lnCqTBQ0vkf3k9UkEruyTq7FdXwMH9o7sfDNJYWzfugv
            MQIEVUxxQJSg0R35fxtZKNrp57u1ALx9VS6MsdudL73cQ7vK/U+6XfiBOfeoZYv7
            jFYX9kjeRX0AERv6IYR7fynTpYj6ybuTODTRH1ye967Ga5YPZX7mV8VyxdX7ulAH
            0QIDAQAB
            -----END PUBLIC KEY-----
            """
            let privateKey = """
            -----BEGIN RSA PRIVATE KEY-----
            MIIEogIBAAKCAQEAm0bdWFyPZiY/zqV8sYB+7j4tYzacgKs2pI10s0gw730dxYuq
            IUzLvobWT9KzbYcSwuodw8wNHrUazakJ7Va6J/FSBgrUldpnnoW2CjUwrqrz5vaT
            hKeHhIwKvQBTcik4kIXQxYtfO+jkSzo+ix/0KxZLGV282awg7U0Ny0H7lnCqTBQ0
            vkf3k9UkEruyTq7FdXwMH9o7sfDNJYWzfugvMQIEVUxxQJSg0R35fxtZKNrp57u1
            ALx9VS6MsdudL73cQ7vK/U+6XfiBOfeoZYv7jFYX9kjeRX0AERv6IYR7fynTpYj6
            ybuTODTRH1ye967Ga5YPZX7mV8VyxdX7ulAH0QIDAQABAoIBADP33bDrGZtIheZ1
            gGwv40t9R9eCuZJeuyULqtkt+iLNLx+khMYsW6ximGuSyzaHFIJjtJ6JNoLmfhgC
            0S277wXbQGaBTXDx7egiPDDiaG6tDIBqWij1oOd9r0JeT49PuHy2LI9Q/AijA3Ui
            Aziw8xlQlsXgl4oKj+Kb/Vfft4I7ngFmfRjsxBtwlfX64k9z4uEf/guOFvQIe7Nf
            zapKLbtDyGJXWfBFlwfIpDeL5fmpt2ecnJ2aSqs6Cgsa13qDto8soOeRKITCqzg7
            ytBx8gCFKLaNbk6ytTufiwxt/53jjyLaHQOxonSvk3rKTIMYWsbzir6aeIjMa03n
            LboN0lkCgYEAnweocIAs6IfkCjK/FSqa6vA2PjCfbW90AT27zopVwfck9x9NKvJz
            aXdNQpUTSdMeu5Hwie4lFaXVzopxlLgiq9U2PFUrS5CqmSUnzZwvTwW+Ch2OO+6K
            hR2eiMw+Gz3otmtjh7YRNa5k/w5U0x3/ex2Wt49pPL+Y6N32lhy//4sCgYEA+fVa
            cMCd3ApStEHgXZ8ReACbCdxSDJVcYGPuY+pffhYDwgu5/XT0SiAvlFdkFScBqPBq
            dOFB8atqs67co6JPPh+h9uc8r1h7uodvt4lG+7joSsZJXXQjGqKTMLh+JCwFpfDb
            2fNZ/pl/bRrWRWczpimsITZn7rKQQfujaQ5KQZMCgYAAiAsFDTiZMlMNwauny3On
            E1RrEsiFmhi+JFGrWAT/V+8UsFMWsKa4FID6lvrwhTcWE1/FZjlTgDFdtlK414Cu
            KFE9FF/Hqd0YE+q1Ii96SR+gcwbVpm9qEHZGKMCQYL2VVniHrJEUJ9gIjii0Z+ZB
            qBCn3l/QpydAp/U5/TCbDwKBgFCnnd5CGO32msc1dotfF4jsURq2b/dFfsBPno25
            A8Uwn1fO5t3lDiqZBiFMrauxoXR81y0NvnSXxl9ibimS5xT5qg58gPVnjM0chKzp
            a/EvsizmnKe+INGoYexXq8RKPCxWcup5/rELoLV48mkEqwLT8Ynp/1FjZu8Tnp/4
            j3dnAoGAYXZ3vZPMC4Ky1rTnbkxHaW2NFfeEI5qYHyrsFbtAbTADWsG+c9olbiNE
            AeG3kQ5Ujw/eRQnlx6nsk540daRv96keDd1uYI/TrouMiOlLYWGoRCQa5vWG36bR
            XXo/5+87g2ye/govr7AuKODitG+Brq6d5SH5n/OMfz0rzVNuSIA=
            -----END RSA PRIVATE KEY-----
            """
            let original = String.re.random(ofLength: Int.random(in: 1...100))
            let encrypted1 = original.re.utf8Data!.re.rsaEncrypt(withPublicKey: publicKey)
            let ret1 = encrypted1!.re.rsaDecrypt(withPrivateKey: privateKey)!.re.utf8String!
            XCTAssertEqual(original, ret1)
            
            let encrypted2 = original.re.utf8Data!.re.rsaEncrypt(withPrivateKey: privateKey)
            let ret2 = encrypted2!.re.rsaDecrypt(withPublicKey: publicKey)!.re.utf8String!
            XCTAssertEqual(original, ret2)
        }
        
        // 4096 bit
        do {
            let publicKey = """
            -----BEGIN PUBLIC KEY-----
            MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAyIGqMNKBhWZ+8QsH0Cvf
            R2WhN4l07yFj1VTYYy+mm1tPJ9Nt0UK31TWRdNlMDdkRiD/bBpOtwS7eQmyLdd/G
            Rj7VM7YwgOSCqhlNBqT49zCjrY5rq6ikVTKEuuwpD6z5LURqBduNwynkauf7eJKC
            Wy4BL45agFqJEDC/cQIoTi3G+03PWo+ig2zF2fpLt/9mm/vx06hAka2zOSJmfcJr
            l8RYj5NCaTztur1/cRNYNwrStdam0T1i0IE7ZF9Zegsbzs58kk18kOabGA3yAOox
            5QoYP2qt/JORfi6fZ3PsQ+ORJqWanF8ruvatwgrKSfZ0rEpDmN7R9nY+vPLKlP8P
            VF8HVkNjTqSdBBVweYUmD245WRVmV7yI2FwDEbsL+Nt/8Z1gwGxgUSsFYDolycch
            NdE65MGpJpClxL+XA+xhspTSaJ39ajW409IPoL4C3dIpFamb1+aYCRLtnQUvZIZg
            DmHWRffUG11g3RwoGPqnBxE+JlsdI0Cwiq7DuyX6x+00M5uh2UoANzG7K25Mlq+9
            arazr0uu/szTnXvIUH7IffIvPMUBuzVUeTAt8sjoZ7JXJ7pzC5RGb4p54WQNCJqH
            ++Waie/lQ/TcOq1Kl/2/qyN91vMvTdfuJBwex6d5pze1ez64nNclkmOUSLWfYBdl
            1VaeURrWoJPkSYQvb52Qf1MCAwEAAQ==
            -----END PUBLIC KEY-----
            """
            let privateKey = """
            -----BEGIN RSA PRIVATE KEY-----
            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
            -----END RSA PRIVATE KEY-----
            """
            let original = String.re.random(ofLength: Int.random(in: 1...100))
            let encrypted1 = original.re.utf8Data!.re.rsaEncrypt(withPublicKey: publicKey)
            let ret1 = encrypted1!.re.rsaDecrypt(withPrivateKey: privateKey)!.re.utf8String!
            XCTAssertEqual(original, ret1)
            
            let encrypted2 = original.re.utf8Data!.re.rsaEncrypt(withPrivateKey: privateKey)
            let ret2 = encrypted2!.re.rsaDecrypt(withPublicKey: publicKey)!.re.utf8String!
            XCTAssertEqual(original, ret2)
        }
    }
}

#endif
