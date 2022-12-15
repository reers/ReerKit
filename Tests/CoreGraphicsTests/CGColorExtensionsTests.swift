//
//  CGColorExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/15.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(CoreGraphics)
import CoreGraphics

#if os(macOS)
import AppKit
#else
import UIKit
#endif

final class CGColorExtensionsTests: XCTestCase {
    #if !os(macOS)
    func testUIColor() {
        let red = UIColor.red
        let cgRed = red.cgColor
        XCTAssertEqual(cgRed.re.uiColor, red)
    }
    #endif

    #if os(macOS)
    func testNSColor() {
        let red = NSColor.red
        let cgRed = red.cgColor
        XCTAssertEqual(cgRed.re.nsColor, red)
    }
    #endif
}

#endif
