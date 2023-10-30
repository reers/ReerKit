//
//  ContiguousBytesExtensions.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/10/30.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit
#if canImport(CryptoKit)
import CryptoKit


final class ContiguousBytesExtensions: XCTestCase {

    func testData() {
        if #available(iOS 13.0, *) {
            let key = SymmetricKey(size: .bits256)
            print(key.re.data.base64EncodedString())
            XCTAssertEqual(key.re.data.count, 32)
        }
    }

}
#endif
