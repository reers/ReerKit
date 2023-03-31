//
//  ColorExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/3/31.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class UIColorExtensionsTests: XCTestCase {

    func testColor() {
        let rgba = UIColor.re(red: 255, green: 111, blue: 222, alpha: 0.5).re.rgba
        XCTAssertEqual(rgba.red, 255)
        XCTAssertEqual(rgba.green, 111)
        XCTAssertEqual(rgba.blue, 222)
        XCTAssertEqual(rgba.alpha, 0.5)

        XCTAssertEqual(UIColor.re(hex: 0xDECEB5, alpha: 0.5).re.hexString, "#deceb5")
        XCTAssertEqual(UIColor.re(hexString: "0xDECEB5", alpha: 0.5).re.hexString, "#deceb5")

        XCTAssertEqual(UIColor.re(argbHex: 0x7FEDE7F6).re.argbHexString, "#7fede7f6")
        XCTAssertEqual(UIColor.re(argbHexString: "0x7FEDE7F6").re.argbHexString, "#7fede7f6")

        XCTAssertEqual(UIColor.re(rgbaHex: 0x7FEDE7F6).re.rgbaHexString, "#7fede7f6")
        XCTAssertEqual(UIColor.re(rgbaHexString: "0x7FEDE7F6").re.rgbaHexString, "#7fede7f6")

        XCTAssertNotNil(UIColor.re.random)

        XCTAssertEqual(UIColor.re(hex: 0xDECEB5, alpha: 0.5).re.alpha, 0.5)

        let rgbaPercent = UIColor.red.withAlphaComponent(0.5).re.rgbaPercent
        XCTAssertEqual(rgbaPercent.red, 1)
        XCTAssertEqual(rgbaPercent.green, 0)
        XCTAssertEqual(rgbaPercent.blue, 0)
        XCTAssertEqual(rgbaPercent.alpha, 0.5)
    }

    func testChangeColor() {
        XCTAssertEqual(UIColor.red.re.lighten(by: 0.5).re.rgba.blue, 127)
        XCTAssertEqual(UIColor.red.re.darken(by: 0.5).re.rgba.red, 127)
        XCTAssertEqual(UIColor.black.re.blend(with: .white).re.rgba.red, 127)
    }
}
