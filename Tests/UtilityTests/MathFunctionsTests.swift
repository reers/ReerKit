//
//  MathFunctionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2024/8/2.
//  Copyright © 2024 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class MathFunctionsTests: XCTestCase {

    func testLinear() {
        let linear = LinearFunction(slope: 2, intercept: 5)
        let y = linear(x: 3)
        let x = linear(y: 11)
        
        XCTAssertEqual(y, 11)
        XCTAssertEqual(x, 3)
        
        
        let linear2 = LinearFunction(point1: .init(x: 0, y: 1), point2: .init(x: 1, y: 0))
        
        XCTAssertEqual(linear2(x: 2), -1)
        XCTAssertEqual(linear2(y: -1), 2)
    }

}
