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
    
    #endif
    
    // MARK: - Color Properties Tests (iOS 14.0+)
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorRGBA() {
        let color = Color.re(red: 255, green: 128, blue: 64)
        let rgba = color.re.rgba
        
        XCTAssertEqual(rgba.red, 255)
        XCTAssertEqual(rgba.green, 128)
        XCTAssertEqual(rgba.blue, 64)
        XCTAssertEqual(rgba.alpha, 1.0, accuracy: 0.01)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorRGBAPercent() {
        let color = Color.re(red: 255, green: 128, blue: 0)
        let rgbaPercent = color.re.rgbaPercent
        
        XCTAssertEqual(rgbaPercent.red, 1.0, accuracy: 0.01)
        XCTAssertEqual(rgbaPercent.green, 0.5, accuracy: 0.01)
        XCTAssertEqual(rgbaPercent.blue, 0.0, accuracy: 0.01)
        XCTAssertEqual(rgbaPercent.alpha, 1.0, accuracy: 0.01)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorAlpha() {
        let opaqueColor = Color.re(hex: 0xFF8040)
        XCTAssertEqual(opaqueColor.re.alpha, 1.0, accuracy: 0.01)
        
        let semiTransparentColor = Color.re(hex: 0xFF8040, opacity: 0.5)
        XCTAssertEqual(semiTransparentColor.re.alpha, 0.5, accuracy: 0.01)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorBrightness() {
        let white = Color.re(red: 255, green: 255, blue: 255)
        XCTAssertEqual(white.re.brightness, 1.0, accuracy: 0.01)
        
        let black = Color.re(red: 0, green: 0, blue: 0)
        XCTAssertEqual(black.re.brightness, 0.0, accuracy: 0.01)
        
        let gray = Color.re(red: 128, green: 128, blue: 128)
        XCTAssertGreaterThan(gray.re.brightness, 0.4)
        XCTAssertLessThan(gray.re.brightness, 0.6)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorHSBA() {
        let red = Color.re(red: 255, green: 0, blue: 0)
        let hsba = red.re.hsba
        
        XCTAssertEqual(hsba.hue, 0.0, accuracy: 0.01)
        XCTAssertEqual(hsba.saturation, 1.0, accuracy: 0.01)
        XCTAssertEqual(hsba.brightness, 1.0, accuracy: 0.01)
        XCTAssertEqual(hsba.alpha, 1.0, accuracy: 0.01)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorHexString() {
        let color = Color.re(red: 255, green: 128, blue: 64)
        XCTAssertEqual(color.re.hexString, "#ff8040")
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorRGBAHexString() {
        let color = Color.re(red: 255, green: 128, blue: 64, opacity: 0.5)
        // Alpha is approximately 127/128
        let hexString = color.re.rgbaHexString
        XCTAssert(hexString.hasPrefix("#ff8040"))
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorARGBHexString() {
        let color = Color.re(red: 255, green: 128, blue: 64, opacity: 1.0)
        XCTAssertEqual(color.re.argbHexString, "#ffff8040")
    }
    
    // MARK: - Color Manipulation Tests
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorLighten() {
        let color = Color.re(red: 128, green: 64, blue: 32)
        let lighterColor = color.re.lighten(by: 0.2)
        
        XCTAssertNotNil(lighterColor)
        
        // Verify the lightened color has higher RGB values
        let originalRGBA = color.re.rgba
        let lightenedRGBA = lighterColor.re.rgba
        
        XCTAssertGreaterThan(lightenedRGBA.red, originalRGBA.red)
        XCTAssertGreaterThan(lightenedRGBA.green, originalRGBA.green)
        XCTAssertGreaterThan(lightenedRGBA.blue, originalRGBA.blue)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorDarken() {
        let color = Color.re(red: 200, green: 150, blue: 100)
        let darkerColor = color.re.darken(by: 0.3)
        
        XCTAssertNotNil(darkerColor)
        
        // Verify the darkened color has lower RGB values
        let originalRGBA = color.re.rgba
        let darkenedRGBA = darkerColor.re.rgba
        
        XCTAssertLessThan(darkenedRGBA.red, originalRGBA.red)
        XCTAssertLessThan(darkenedRGBA.green, originalRGBA.green)
        XCTAssertLessThan(darkenedRGBA.blue, originalRGBA.blue)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorBlendStatic() {
        let red = Color.re(red: 255, green: 0, blue: 0)
        let blue = Color.re(red: 0, green: 0, blue: 255)
        
        let blended = Color.re.blend(red, intensity1: 0.5, with: blue, intensity2: 0.5)
        XCTAssertNotNil(blended)
        
        let blendedRGBA = blended.re.rgba
        // Should be somewhere between red and blue
        XCTAssertGreaterThan(blendedRGBA.red, 0)
        XCTAssertGreaterThan(blendedRGBA.blue, 0)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorBlendInstance() {
        let red = Color.re(red: 255, green: 0, blue: 0)
        let blue = Color.re(red: 0, green: 0, blue: 255)
        
        let blended = red.re.blend(with: blue)
        XCTAssertNotNil(blended)
        
        let blendedRGBA = blended.re.rgba
        // Should be equal blend (purple-ish)
        XCTAssertGreaterThan(blendedRGBA.red, 50)
        XCTAssertGreaterThan(blendedRGBA.blue, 50)
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    func testColorBlendIntensity() {
        let red = Color.re(red: 255, green: 0, blue: 0)
        let blue = Color.re(red: 0, green: 0, blue: 255)
        
        // Blend with more red
        let redDominant = Color.re.blend(red, intensity1: 0.8, with: blue, intensity2: 0.2)
        let redDominantRGBA = redDominant.re.rgba
        XCTAssertGreaterThan(redDominantRGBA.red, redDominantRGBA.blue)
        
        // Blend with more blue
        let blueDominant = Color.re.blend(red, intensity1: 0.2, with: blue, intensity2: 0.8)
        let blueDominantRGBA = blueDominant.re.rgba
        XCTAssertGreaterThan(blueDominantRGBA.blue, blueDominantRGBA.red)
    }
}

#endif

