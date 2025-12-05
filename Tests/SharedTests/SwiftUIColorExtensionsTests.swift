//
//  SwiftUIColorExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by ReerKit
//

@testable import ReerKit
import XCTest

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
final class SwiftUIColorExtensionsTests: XCTestCase {
    
    func testColorFromRGB() {
        let color = Color.re(red: 255, green: 128, blue: 64)
        XCTAssertNotNil(color)
        
        // Test RGB clamping
        let clampedColor = Color.re(red: 300, green: -10, blue: 128)
        XCTAssertNotNil(clampedColor)
    }
    
    func testColorFromHex() {
        let color1 = Color.re(hex: 0xFF8040)
        XCTAssertNotNil(color1)
        
        let color2 = Color.re(0xFF8040)
        XCTAssertNotNil(color2)
    }
    
    func testColorFromHexString() {
        let color1 = Color.re(hexString: "#FF8040")
        XCTAssertNotNil(color1)
        
        let color2 = Color.re("FF8040")
        XCTAssertNotNil(color2)
        
        let color3 = Color.re("0xFF8040")
        XCTAssertNotNil(color3)
        
        // Test short format
        let color4 = Color.re("F84")
        XCTAssertNotNil(color4)
        
        let color5 = Color.re("#F84")
        XCTAssertNotNil(color5)
    }
    
    func testColorFromARGBHex() {
        let color = Color.re(argbHex: 0x7FFF8040)
        XCTAssertNotNil(color)
    }
    
    func testColorFromARGBHexString() {
        let color1 = Color.re(argbHexString: "#7FFF8040")
        XCTAssertNotNil(color1)
        
        let color2 = Color.re(argbHexString: "7FFF8040")
        XCTAssertNotNil(color2)
        
        let color3 = Color.re(argbHexString: "0x7FFF8040")
        XCTAssertNotNil(color3)
    }
    
    func testColorFromRGBAHex() {
        let color = Color.re(rgbaHex: 0xFF80407F)
        XCTAssertNotNil(color)
    }
    
    func testColorFromRGBAHexString() {
        let color1 = Color.re(rgbaHexString: "#FF80407F")
        XCTAssertNotNil(color1)
        
        let color2 = Color.re(rgbaHexString: "FF80407F")
        XCTAssertNotNil(color2)
        
        let color3 = Color.re(rgbaHexString: "0xFF80407F")
        XCTAssertNotNil(color3)
    }
    
    func testRandomColor() {
        let color1 = Color.re.random
        let color2 = Color.re.random
        XCTAssertNotNil(color1)
        XCTAssertNotNil(color2)
        
        let color3 = Color.re.random(colorSpace: .displayP3)
        XCTAssertNotNil(color3)
    }
    
    func testColorWithOpacity() {
        let color = Color.re(red: 255, green: 128, blue: 64, opacity: 0.5)
        XCTAssertNotNil(color)
        
        let colorFromHex = Color.re(hex: 0xFF8040, opacity: 0.7)
        XCTAssertNotNil(colorFromHex)
        
        let colorFromString = Color.re(hexString: "#FF8040", opacity: 0.3)
        XCTAssertNotNil(colorFromString)
    }
    
    func testColorSpaceSupport() {
        let sRGBColor = Color.re(red: 255, green: 128, blue: 64, colorSpace: .sRGB)
        XCTAssertNotNil(sRGBColor)
        
        let displayP3Color = Color.re(red: 255, green: 128, blue: 64, colorSpace: .displayP3)
        XCTAssertNotNil(displayP3Color)
    }
    
    #if canImport(UIKit)
    func testColorToUIColor() {
        let swiftUIColor = Color.re(hex: 0xFF8040)
        let uiColor = swiftUIColor.re.uiColor
        XCTAssertNotNil(uiColor)
    }
    
    func testUIColorToSwiftUIColor() {
        let uiColor = UIColor.red
        let swiftUIColor = uiColor.re.color
        XCTAssertNotNil(swiftUIColor)
    }
    
    #endif
    
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    @available(macOS 11.0, *)
    func testColorToNSColor() {
        let swiftUIColor = Color.re(hex: 0xFF8040)
        let nsColor = swiftUIColor.re.nsColor
        XCTAssertNotNil(nsColor)
    }
    
    @available(macOS 10.15, *)
    func testNSColorToSwiftUIColor() {
        let nsColor = NSColor.red
        let swiftUIColor = nsColor.re.color
        XCTAssertNotNil(swiftUIColor)
    }
    
    @available(macOS 11.0, *)
    func testREColorConversion() {
        let swiftUIColor = Color.re(hex: 0xFF8040)
        let reColor = swiftUIColor.re.reColor
        XCTAssertNotNil(reColor)
        
        // Test round-trip conversion
        let convertedColor = reColor.re.color
        XCTAssertNotNil(convertedColor)
    }
    #endif
}

#endif

