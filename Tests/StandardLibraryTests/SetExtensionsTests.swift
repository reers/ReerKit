//
//  SetExtensionsTests.swift
//  ReerKit
//
//  Created by phoenix on 2025/1/21.
//  Copyright © 2025 reers. All rights reserved.
//

import XCTest
import ReerKit

class SetExtensionsTests: XCTestCase {

    func testToogle() {
        var set: Set = [1, 2, 3, 4, 5]
        XCTAssertFalse(set.re.toggle(1))
        XCTAssertTrue(set.re.toggle(6))
        XCTAssertEqual(set, [2, 3, 4, 5, 6])
    }
}
