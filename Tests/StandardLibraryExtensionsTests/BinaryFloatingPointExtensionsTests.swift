//
//  BinaryFloatingPointExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/9/29.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class BinaryFloatingPointExtensionsTests: XCTestCase {
    func testRounded() {
        let double = 3.1415927
        XCTAssertEqual(double.re.rounded(3), 3.142)
        XCTAssertEqual(double.re.rounded(3, rule: .down), 3.141)
        XCTAssertEqual(double.re.rounded(2, rule: .awayFromZero), 3.15)

        let float: Float = 3.1415927
        XCTAssertEqual(float.re.rounded(4, rule: .towardZero), 3.1415)
        XCTAssertEqual(float.re.rounded(-1, rule: .toNearestOrEven), 3)
        XCTAssertEqual(float.re.rounded(0, rule: .toNearestOrAwayFromZero), 3)
    }
}
