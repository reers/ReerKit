//
//  BidirectionalCollectionExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/9/29.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class BidirectionalCollectionExtensionsTests: XCTestCase {

    func testOffsetSubscript() {
        let arr = [1, 2, 3, 4, 5]
        XCTAssertEqual(arr.re[offset: 0], 1)
        XCTAssertEqual(arr.re[offset: 4], 5)
        XCTAssertEqual(arr.re[offset: -2], 4)
    }

}
