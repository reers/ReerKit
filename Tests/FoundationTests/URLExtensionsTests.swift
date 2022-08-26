//
//  URLExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/25.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class URLExtensionsTests: XCTestCase {

    func testInit() {
        let _ = URL.re.with(urlString: "myapp://example.com/over/there?name=你好#nose")
    }

}
