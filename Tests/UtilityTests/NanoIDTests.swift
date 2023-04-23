//
//  NanoIDTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/24.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class NanoIDTests: XCTestCase {

    func testNanoID() {
        XCTAssertEqual(NanoID.generate().count, 21)
        XCTAssertEqual(NanoID.generate(alphabet: .init("a"), size: 3), "aaa")
    }

}
