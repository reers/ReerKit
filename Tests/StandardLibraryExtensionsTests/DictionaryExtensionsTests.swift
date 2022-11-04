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
        let dict = ["name": "phoenix", "age": "32"]
        XCTAssertEqual(dict.dml.name!, "phoenix")
        XCTAssertEqual(dict.dml.age.re.intValue, 32)
        XCTAssertEqual(dict.dml.test, nil)
    }

}
