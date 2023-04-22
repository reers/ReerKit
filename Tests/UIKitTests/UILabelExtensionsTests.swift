//
//  UILabelExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UILabelExtensionsTests: XCTestCase {

    func testrequiredHeight() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let label = UILabel(frame: frame)
        label.text = "Hello world"

        #if os(iOS)
        XCTAssert(label.re.requiredHeight >= 20)
        XCTAssert(label.re.requiredHeight < 25)
        #else
        XCTAssert(label.re.requiredHeight > 0)
        XCTAssert(label.re.requiredHeight < 100)
        #endif
    }
}

#endif
