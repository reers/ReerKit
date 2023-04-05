//
//  BundleExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/5.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class BundleExtensionsTests: XCTestCase {

    func testAppInfo() {
        XCTAssertEqual(Bundle.re.appDisplayName, "xctest")
        XCTAssertEqual(Bundle.re.appBundleID, "com.apple.dt.xctest.tool")
        XCTAssertEqual(Bundle.re.appVersion, "14.1")
    }
}
