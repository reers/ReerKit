//
//  NSObjectExtensionsTests.swift
//  ReerKitTests
//
//  Created by phoenix on 2022/6/12.
//

import XCTest
import Foundation
@testable import ReerKit

class NSObjectExtensionsTests: XCTestCase {

    func testOCClassName() {
        XCTAssertEqual(UIView().typeName, "UIView")
        XCTAssertEqual(UIView.typeName, "UIView")
    }

}

