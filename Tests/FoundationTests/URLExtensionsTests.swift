//
//  URLExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/3.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit
import Foundation

final class URLExtensionsTests: XCTestCase {

    func testInit() {
        XCTAssertNotNil(URL.re(string: "myapp://example.com/over/there?hello=你好#nose"))
    }

}
