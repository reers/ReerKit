//
//  Copyright © 2020 SwifterSwift
//  Copyright © 2022 reers.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if !os(Linux)

#if canImport(UIKit)
import UIKit
/// ReerKit: Color
public typealias REColor = UIColor
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
/// ReerKit: Color
public typealias REColor = NSColor
#endif

// MARK: - ColorSpace

/// ReerKit: Color space for REColor
public enum ColorSpace {
    case sRGB
    case displayP3
}

// MARK: - Initializer

public extension REColor {
    /// ReerKit: Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - alpha: optional transparency value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(red: Int, green: Int, blue: Int, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> REColor {
        let red = max(0, min(255, red))
        let green = max(0, min(255, green))
        let blue = max(0, min(255, blue))
        let alpha = max(0, min(1, alpha))
        
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        
        switch colorSpace {
        case .sRGB:
            return REColor(red: r, green: g, blue: b, alpha: alpha)
        case .displayP3:
            return REColor(displayP3Red: r, green: g, blue: b, alpha: alpha)
        }
    }

    /// ReerKit: Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int with 6 digits (example: 0xDECEB5).
    ///   - alpha: optional transparency value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(hex: Int, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> REColor {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        let alpha = max(0, min(1, alpha))
        return REColor.re(red: red, green: green, blue: blue, alpha: alpha, colorSpace: colorSpace)
    }
    
    /// ReerKit: Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int with 6 digits (example: 0xDECEB5).
    ///   - alpha: optional transparency value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(_ hex: Int, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> REColor {
        return re(hex: hex, alpha: alpha, colorSpace: colorSpace)
    }

    /// ReerKit: Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - alpha: optional transparency value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(hexString: String, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> REColor {
        var string = hexString
            .lowercased()
            .re.removingPrefix("0x")
            .re.removingPrefix("#")

        if string.count == 3 {
            string = string.longFormatHex
        }
        guard string.count == 6 else {
            assertionFailure("Color string \(hexString) should be 3 or 6 characters.")
            return .clear
        }

        guard let hexValue = Int(string, radix: 16) else {
            assertionFailure("Invalid color string \(hexString)")
            return .clear
        }

        let alpha = max(0, min(1, alpha))

        return REColor.re(hex: hexValue, alpha: alpha, colorSpace: colorSpace)
    }
    
    /// ReerKit: Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - alpha: optional transparency value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(_ hexString: String, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> REColor {
        return re(hexString: hexString, alpha: alpha, colorSpace: colorSpace)
    }

    /// ReerKit: Create Color from hexadecimal value in the format ARGB (alpha-red-green-blue).
    ///
    /// - Parameters:
    ///   - argbHex: hexadecimal value with 8 digits (examples: 0x7FEDE7F6).
    ///   - colorSpace: color space (default is sRGB).
    static func re(argbHex: Int, colorSpace: ColorSpace = .sRGB) -> REColor {
        let alpha = (argbHex >> 24) & 0xFF
        let red = (argbHex >> 16) & 0xFF
        let green = (argbHex >> 8) & 0xFF
        let blue = argbHex & 0xFF
        return REColor.re(red: red, green: green, blue: blue, alpha: CGFloat(alpha) / 255, colorSpace: colorSpace)
    }

    /// ReerKit: Create Color from hexadecimal string in the format ARGB (alpha-red-green-blue).
    ///
    /// - Parameters:
    ///   - argbHexString: hexadecimal string (examples: 7FEDE7F6, 0x7FEDE7F6, #7FEDE7F6, #f0ff, 0xFF0F, ..).
    ///   - colorSpace: color space (default is sRGB).
    static func re(argbHexString: String, colorSpace: ColorSpace = .sRGB) -> REColor {
        var string = argbHexString
            .lowercased()
            .re.removingPrefix("0x")
            .re.removingPrefix("#")

        if string.count <= 4 {
            string = string.longFormatHex
        }

        guard let hexValue = Int(string, radix: 16) else {
            assertionFailure("Invalid color string \(argbHexString)")
            return .clear
        }

        let hasAlpha = string.count == 8

        let alpha = hasAlpha ? (hexValue >> 24) & 0xFF : 0xFF
        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF

        return REColor.re(red: red, green: green, blue: blue, alpha: CGFloat(alpha) / 255, colorSpace: colorSpace)
    }

    /// ReerKit: Create Color from hexadecimal value in the format RGBA (red-green-blue-alpha).
    ///
    /// - Parameters:
    ///   - rgbaHex: hexadecimal value with 8 digits  (examples: 0x7FEDE7F6).
    ///   - colorSpace: color space (default is sRGB).
    static func re(rgbaHex: Int, colorSpace: ColorSpace = .sRGB) -> REColor {
        let red = (rgbaHex >> 24) & 0xFF
        let green = (rgbaHex >> 16) & 0xFF
        let blue = (rgbaHex >> 8) & 0xFF
        let alpha = rgbaHex & 0xFF
        return REColor.re(red: red, green: green, blue: blue, alpha: CGFloat(alpha) / 255, colorSpace: colorSpace)
    }

    /// ReerKit: Create Color from hexadecimal string in the format RGBA (red-green-blue-alpha).
    ///
    /// - Parameters:
    ///   - rgbaHexString: hexadecimal string (examples: 7FEDE7F6, 0x7FEDE7F6, #7FEDE7F6, #f0ff, 0xFF0F, ..).
    ///   - colorSpace: color space (default is sRGB).
    static func re(rgbaHexString: String, colorSpace: ColorSpace = .sRGB) -> REColor {
        var string = rgbaHexString
            .lowercased()
            .re.removingPrefix("0x")
            .re.removingPrefix("#")

        if string.count <= 4 {
            string = string.longFormatHex
        }

        guard let hexValue = Int(string, radix: 16) else {
            assertionFailure("Invalid color string \(rgbaHexString)")
            return .clear
        }

        let hasAlpha = string.count == 8

        let red = (hexValue >> 24) & 0xFF
        let green = (hexValue >> 16) & 0xFF
        let blue = (hexValue >> 8) & 0xFF
        let alpha = hasAlpha ? hexValue & 0xFF : 0xFF

        return REColor.re(red: red, green: green, blue: blue, alpha: CGFloat(alpha) / 255, colorSpace: colorSpace)
    }

    #if !os(watchOS)
    /// ReerKit: Create a dynamic color with light and dark color.
    static func re(light: REColor, dark: REColor) -> REColor {
        #if os(macOS)
        if #available(macOS 10.15, *) {
            return REColor(name: nil, dynamicProvider: { $0.name == .darkAqua ? dark : light })
        } else {
            return REColor(cgColor: light.cgColor) ?? .clear
        }
        #elseif os(iOS) || os(tvOS) || os(visionOS)
        if #available(iOS 13.0, tvOS 13.0, *) {
            return REColor(dynamicProvider: { $0.userInterfaceStyle == .dark ? dark : light })
        } else {
            return REColor(cgColor: light.cgColor)
        }
        #endif
    }
    #endif
}

// MARK: - Properties & Functions

public extension Reer where Base: REColor {
    /// ReerKit: Random color.
    static var random: REColor {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return REColor.re(red: red, green: green, blue: blue)
    }
    
    /// ReerKit: Random color with specified color space.
    ///
    /// - Parameter colorSpace: color space (default is sRGB).
    /// - Returns: A random color in the specified color space.
    static func random(colorSpace: ColorSpace = .sRGB) -> REColor {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return REColor.re(red: red, green: green, blue: blue, colorSpace: colorSpace)
    }
    
    /// ReerKit: Get brightness of color.
    var brightness: CGFloat {
        let rgbValue = base.re.rgba
        return (299 * rgbValue.red.re.cgFloat + 587 * rgbValue.green.re.cgFloat + 114 * rgbValue.blue.re.cgFloat) / 1000.0
    }

    /// ReerKit: Alpha of Color (read-only).
    var alpha: CGFloat {
        return base.cgColor.alpha
    }
    
    /// ReerKit: Get components of hue, saturation, and brightness, and alpha (read-only).
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        base.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (hue: h, saturation: s, brightness: b, alpha: a)
    }

    /// ReerKit: RGBA components for a Color (RGB between 0 and 255).
    ///
    ///     UIColor.red.re.rgba.red -> 255
    ///     NSColor.green.re.rgba.green -> 255
    ///     UIColor.blue.re.rgba.blue -> 255
    ///
    var rgba: (red: Int, green: Int, blue: Int, alpha: CGFloat) {
        let components = rgbaComponents
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components.count >= 4 ? components[3] : 1.0
        return (Int(red * 255.0), Int(green * 255.0), Int(blue * 255.0), alpha)
    }

    /// ReerKit: RGBA components of percentage for a Color (RGB between 0 and 1.0).
    ///
    ///     UIColor.red.re.rgba.red -> 255
    ///     NSColor.green.re.rgba.green -> 255
    ///     UIColor.blue.re.rgba.blue -> 255
    ///
    var rgbaPercent: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let components = rgbaComponents
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components.count >= 4 ? components[3] : 1.0
        return (red, green, blue, alpha)
    }

    /// ReerKit: Hexadecimal value string (read-only).
    var hexString: String {
        let components = rgbaComponents.map { Int($0 * 255.0) }
        return String(format: "#%02x%02x%02x", components[0], components[1], components[2])
    }

    /// ReerKit: Hexadecimal value string in RGBA mode (read-only).
    var rgbaHexString: String {
        let components = rgbaComponents.map { Int($0 * 255.0) }
        return String(format: "#%02x%02x%02x%02x", components[0], components[1], components[2], components[3])
    }

    /// ReerKit: Hexadecimal value string in ARGB mode (read-only).
    var argbHexString: String {
        let components = rgbaComponents.map { Int($0 * 255.0) }
        return String(format: "#%02x%02x%02x%02x", components[3], components[0], components[1], components[2])
    }

    private var rgbaComponents: [CGFloat] {
        if let comps = base.cgColor.components {
            if comps.count == 4 { return comps }
            if comps.count == 2 { return [comps[0], comps[0], comps[0], comps[1]] }
        }
        return [0, 0, 0, 0]
    }

    /// ReerKit: Lighten a color
    ///
    ///     let color = UIColor(red: r, green: g, blue: b, alpha: a)
    ///     let lighterColor: UIColor = color.lighten(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to lighten the color
    /// - Returns: A lightened color
    func lighten(by percentage: CGFloat = 0.2) -> REColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        base.getRed(&r, green: &g, blue: &b, alpha: &a)
        return REColor(
            red: r + (1 - r) * percentage,
            green: g + (1 - g) * percentage,
            blue: b + (1 - b) * percentage,
            alpha: a
        )
    }

    /// ReerKit: Darken a color
    ///
    ///     let color = UIColor(red: r, green: g, blue: b, alpha: a)
    ///     let darkerColor: UIColor = color.darken(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to darken the color
    /// - Returns: A darkened color
    func darken(by percentage: CGFloat = 0.2) -> REColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        base.getRed(&r, green: &g, blue: &b, alpha: &a)
        return REColor(
            red: r - r * percentage,
            green: g - g * percentage,
            blue: b - b * percentage,
            alpha: a
        )
    }

    /// ReerKit: Blend two Colors.
    ///
    /// - Parameters:
    ///   - color1: first color to blend
    ///   - intensity1: intensity of first color (default is 0.5)
    ///   - color2: second color to blend
    ///   - intensity2: intensity of second color (default is 0.5)
    /// - Returns: Color created by blending first and second colors.
    static func blend(
        _ color1: REColor,
        intensity1: CGFloat = 0.5,
        with color2: REColor,
        intensity2: CGFloat = 0.5
    ) -> REColor {
        let total = intensity1 + intensity2
        let level1 = intensity1 / total
        let level2 = intensity2 / total

        guard level1 > 0 else { return color2 }
        guard level2 > 0 else { return color1 }

        let components1 = color1.re.rgbaComponents
        let components2 = color2.re.rgbaComponents

        let red1 = components1[0]
        let red2 = components2[0]

        let green1 = components1[1]
        let green2 = components2[1]

        let blue1 = components1[2]
        let blue2 = components2[2]

        let alpha1 = color1.cgColor.alpha
        let alpha2 = color2.cgColor.alpha

        let red = level1 * red1 + level2 * red2
        let green = level1 * green1 + level2 * green2
        let blue = level1 * blue1 + level2 * blue2
        let alpha = level1 * alpha1 + level2 * alpha2

        return REColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// ReerKit: Blend the color with a color
    ///
    /// - Parameter color: second color to blend
    /// - Returns: Color created by blending self and seond colors.
    func blend(with color: REColor) -> REColor {
        return REColor.re.blend(base, intensity1: 0.5, with: color, intensity2: 0.5)
    }
}

fileprivate extension String {
    var longFormatHex: String {
        var string = ""
        self.forEach { string.append(String(repeating: String($0), count: 2)) }
        return string
    }
}

// MARK: - SwiftUI Color Support

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Color {
    /// ReerKit: Create SwiftUI Color from RGB values with optional opacity.
    ///
    /// - Parameters:
    ///   - red: red component (0-255).
    ///   - green: green component (0-255).
    ///   - blue: blue component (0-255).
    ///   - opacity: optional opacity value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(red: Int, green: Int, blue: Int, opacity: Double = 1, colorSpace: ColorSpace = .sRGB) -> Color {
        let red = max(0, min(255, red))
        let green = max(0, min(255, green))
        let blue = max(0, min(255, blue))
        let opacity = max(0, min(1, opacity))
        
        let r = Double(red) / 255.0
        let g = Double(green) / 255.0
        let b = Double(blue) / 255.0
        
        switch colorSpace {
        case .sRGB:
            return Color(.sRGB, red: r, green: g, blue: b, opacity: opacity)
        case .displayP3:
            return Color(.displayP3, red: r, green: g, blue: b, opacity: opacity)
        }
    }
    
    /// ReerKit: Create SwiftUI Color from hexadecimal value with optional opacity.
    ///
    /// - Parameters:
    ///   - hex: hex Int with 6 digits (example: 0xDECEB5).
    ///   - opacity: optional opacity value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(hex: Int, opacity: Double = 1, colorSpace: ColorSpace = .sRGB) -> Color {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        return Color.re(red: red, green: green, blue: blue, opacity: opacity, colorSpace: colorSpace)
    }
    
    /// ReerKit: Create SwiftUI Color from hexadecimal value with optional opacity.
    ///
    /// - Parameters:
    ///   - hex: hex Int with 6 digits (example: 0xDECEB5).
    ///   - opacity: optional opacity value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(_ hex: Int, opacity: Double = 1, colorSpace: ColorSpace = .sRGB) -> Color {
        return re(hex: hex, opacity: opacity, colorSpace: colorSpace)
    }
    
    /// ReerKit: Create SwiftUI Color from hexadecimal string with optional opacity (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - opacity: optional opacity value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(hexString: String, opacity: Double = 1, colorSpace: ColorSpace = .sRGB) -> Color {
        var string = hexString
            .lowercased()
            .re.removingPrefix("0x")
            .re.removingPrefix("#")
        
        if string.count == 3 {
            string = string.longFormatHex
        }
        guard string.count == 6 else {
            assertionFailure("Color string \(hexString) should be 3 or 6 characters.")
            return .clear
        }
        
        guard let hexValue = Int(string, radix: 16) else {
            assertionFailure("Invalid color string \(hexString)")
            return .clear
        }
        
        return Color.re(hex: hexValue, opacity: opacity, colorSpace: colorSpace)
    }
    
    /// ReerKit: Create SwiftUI Color from hexadecimal string with optional opacity (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - opacity: optional opacity value (default is 1).
    ///   - colorSpace: color space (default is sRGB).
    static func re(_ hexString: String, opacity: Double = 1, colorSpace: ColorSpace = .sRGB) -> Color {
        return re(hexString: hexString, opacity: opacity, colorSpace: colorSpace)
    }
    
    /// ReerKit: Create SwiftUI Color from hexadecimal value in the format ARGB (alpha-red-green-blue).
    ///
    /// - Parameters:
    ///   - argbHex: hexadecimal value with 8 digits (examples: 0x7FEDE7F6).
    ///   - colorSpace: color space (default is sRGB).
    static func re(argbHex: Int, colorSpace: ColorSpace = .sRGB) -> Color {
        let alpha = (argbHex >> 24) & 0xFF
        let red = (argbHex >> 16) & 0xFF
        let green = (argbHex >> 8) & 0xFF
        let blue = argbHex & 0xFF
        return Color.re(red: red, green: green, blue: blue, opacity: Double(alpha) / 255, colorSpace: colorSpace)
    }
    
    /// ReerKit: Create SwiftUI Color from hexadecimal string in the format ARGB (alpha-red-green-blue).
    ///
    /// - Parameters:
    ///   - argbHexString: hexadecimal string (examples: 7FEDE7F6, 0x7FEDE7F6, #7FEDE7F6, #f0ff, 0xFF0F, ..).
    ///   - colorSpace: color space (default is sRGB).
    static func re(argbHexString: String, colorSpace: ColorSpace = .sRGB) -> Color {
        var string = argbHexString
            .lowercased()
            .re.removingPrefix("0x")
            .re.removingPrefix("#")
        
        if string.count <= 4 {
            string = string.longFormatHex
        }
        
        guard let hexValue = Int(string, radix: 16) else {
            assertionFailure("Invalid color string \(argbHexString)")
            return .clear
        }
        
        let hasAlpha = string.count == 8
        
        let alpha = hasAlpha ? (hexValue >> 24) & 0xFF : 0xFF
        let red = (hexValue >> 16) & 0xFF
        let green = (hexValue >> 8) & 0xFF
        let blue = hexValue & 0xFF
        
        return Color.re(red: red, green: green, blue: blue, opacity: Double(alpha) / 255, colorSpace: colorSpace)
    }
    
    /// ReerKit: Create SwiftUI Color from hexadecimal value in the format RGBA (red-green-blue-alpha).
    ///
    /// - Parameters:
    ///   - rgbaHex: hexadecimal value with 8 digits  (examples: 0x7FEDE7F6).
    ///   - colorSpace: color space (default is sRGB).
    static func re(rgbaHex: Int, colorSpace: ColorSpace = .sRGB) -> Color {
        let red = (rgbaHex >> 24) & 0xFF
        let green = (rgbaHex >> 16) & 0xFF
        let blue = (rgbaHex >> 8) & 0xFF
        let alpha = rgbaHex & 0xFF
        return Color.re(red: red, green: green, blue: blue, opacity: Double(alpha) / 255, colorSpace: colorSpace)
    }
    
    /// ReerKit: Create SwiftUI Color from hexadecimal string in the format RGBA (red-green-blue-alpha).
    ///
    /// - Parameters:
    ///   - rgbaHexString: hexadecimal string (examples: 7FEDE7F6, 0x7FEDE7F6, #7FEDE7F6, #f0ff, 0xFF0F, ..).
    ///   - colorSpace: color space (default is sRGB).
    static func re(rgbaHexString: String, colorSpace: ColorSpace = .sRGB) -> Color {
        var string = rgbaHexString
            .lowercased()
            .re.removingPrefix("0x")
            .re.removingPrefix("#")
        
        if string.count <= 4 {
            string = string.longFormatHex
        }
        
        guard let hexValue = Int(string, radix: 16) else {
            assertionFailure("Invalid color string \(rgbaHexString)")
            return .clear
        }
        
        let hasAlpha = string.count == 8
        
        let red = (hexValue >> 24) & 0xFF
        let green = (hexValue >> 16) & 0xFF
        let blue = (hexValue >> 8) & 0xFF
        let alpha = hasAlpha ? hexValue & 0xFF : 0xFF
        
        return Color.re(red: red, green: green, blue: blue, opacity: Double(alpha) / 255, colorSpace: colorSpace)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension ReerForEquatable where Base == Color {
    /// ReerKit: Random SwiftUI Color.
    static var random: Color {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return Color.re(red: red, green: green, blue: blue)
    }
    
    /// ReerKit: Random SwiftUI Color with specified color space.
    ///
    /// - Parameter colorSpace: color space (default is sRGB).
    /// - Returns: A random color in the specified color space.
    static func random(colorSpace: ColorSpace = .sRGB) -> Color {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return Color.re(red: red, green: green, blue: blue, colorSpace: colorSpace)
    }
    
    #if canImport(UIKit)
    /// ReerKit: Convert SwiftUI Color to UIColor.
    ///
    /// - Returns: UIColor representation of the SwiftUI Color.
    @available(macOS 14.0, *)
    var uiColor: UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(base)
        } else {
            return .clear
        }
    }
    #endif
    
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    /// ReerKit: Convert SwiftUI Color to NSColor.
    ///
    /// - Returns: NSColor representation of the SwiftUI Color.
    @available(macOS 11.0, *)
    var nsColor: NSColor {
        return NSColor(base)
    }
    #endif
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension ReerForEquatable where Base == Color {
    
    /// ReerKit: Get brightness of color.
    var brightness: CGFloat {
        let rgbValue = rgba
        return (299 * CGFloat(rgbValue.red) + 587 * CGFloat(rgbValue.green) + 114 * CGFloat(rgbValue.blue)) / 1000.0 / 255.0
    }
    
    /// ReerKit: Alpha of Color (read-only).
    var alpha: CGFloat {
        let components = rgbaComponents
        return components.count >= 4 ? components[3] : 1.0
    }
    
    /// ReerKit: Get components of hue, saturation, and brightness, and alpha (read-only).
    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        let comps = rgbaPercent
        let r = comps.red
        let g = comps.green
        let b = comps.blue
        let a = comps.alpha
        
        let maxValue = max(r, g, b)
        let minValue = min(r, g, b)
        let delta = maxValue - minValue
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        let brightness = maxValue
        
        if delta != 0 {
            saturation = delta / maxValue
            
            if r == maxValue {
                hue = ((g - b) / delta).truncatingRemainder(dividingBy: 6)
            } else if g == maxValue {
                hue = ((b - r) / delta) + 2
            } else {
                hue = ((r - g) / delta) + 4
            }
            
            hue /= 6
            if hue < 0 {
                hue += 1
            }
        }
        
        return (hue: hue, saturation: saturation, brightness: brightness, alpha: a)
    }
    
    /// ReerKit: RGBA components for a Color (RGB between 0 and 255).
    ///
    ///     Color.red.re.rgba.red -> 255
    ///     Color.green.re.rgba.green -> 255
    ///     Color.blue.re.rgba.blue -> 255
    ///
    var rgba: (red: Int, green: Int, blue: Int, alpha: CGFloat) {
        let components = rgbaComponents
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components.count >= 4 ? components[3] : 1.0
        return (Int(red * 255.0), Int(green * 255.0), Int(blue * 255.0), alpha)
    }
    
    /// ReerKit: RGBA components of percentage for a Color (RGB between 0 and 1.0).
    ///
    ///     Color.red.re.rgbaPercent.red -> 1.0
    ///     Color.green.re.rgbaPercent.green -> 1.0
    ///     Color.blue.re.rgbaPercent.blue -> 1.0
    ///
    var rgbaPercent: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let components = rgbaComponents
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components.count >= 4 ? components[3] : 1.0
        return (red, green, blue, alpha)
    }
    
    /// ReerKit: Hexadecimal value string (read-only).
    var hexString: String {
        let components = rgbaComponents.map { Int($0 * 255.0) }
        return String(format: "#%02x%02x%02x", components[0], components[1], components[2])
    }
    
    /// ReerKit: Hexadecimal value string in RGBA mode (read-only).
    var rgbaHexString: String {
        let components = rgbaComponents.map { Int($0 * 255.0) }
        return String(format: "#%02x%02x%02x%02x", components[0], components[1], components[2], components[3])
    }
    
    /// ReerKit: Hexadecimal value string in ARGB mode (read-only).
    var argbHexString: String {
        let components = rgbaComponents.map { Int($0 * 255.0) }
        return String(format: "#%02x%02x%02x%02x", components[3], components[0], components[1], components[2])
    }
    
    /// ReerKit: Lighten a color
    ///
    ///     let color = Color.re(hex: 0xFF8040)
    ///     let lighterColor = color.re.lighten(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to lighten the color
    /// - Returns: A lightened SwiftUI Color
    func lighten(by percentage: CGFloat = 0.2) -> Color {
        let comps = rgbaPercent
        let r = comps.red
        let g = comps.green
        let b = comps.blue
        let a = comps.alpha
        
        return Color(
            .sRGB,
            red: r + (1 - r) * percentage,
            green: g + (1 - g) * percentage,
            blue: b + (1 - b) * percentage,
            opacity: Double(a)
        )
    }
    
    /// ReerKit: Darken a color
    ///
    ///     let color = Color.re(hex: 0xFF8040)
    ///     let darkerColor = color.re.darken(by: 0.2)
    ///
    /// - Parameter percentage: Percentage by which to darken the color
    /// - Returns: A darkened SwiftUI Color
    func darken(by percentage: CGFloat = 0.2) -> Color {
        let comps = rgbaPercent
        let r = comps.red
        let g = comps.green
        let b = comps.blue
        let a = comps.alpha
        
        return Color(
            .sRGB,
            red: r - r * percentage,
            green: g - g * percentage,
            blue: b - b * percentage,
            opacity: Double(a)
        )
    }
    
    /// ReerKit: Blend two SwiftUI Colors.
    ///
    /// - Parameters:
    ///   - color1: first color to blend
    ///   - intensity1: intensity of first color (default is 0.5)
    ///   - color2: second color to blend
    ///   - intensity2: intensity of second color (default is 0.5)
    /// - Returns: Color created by blending first and second colors.
    static func blend(
        _ color1: Color,
        intensity1: CGFloat = 0.5,
        with color2: Color,
        intensity2: CGFloat = 0.5
    ) -> Color {
        let total = intensity1 + intensity2
        let level1 = intensity1 / total
        let level2 = intensity2 / total
        
        guard level1 > 0 else { return color2 }
        guard level2 > 0 else { return color1 }
        
        let components1 = color1.re.rgbaComponents
        let components2 = color2.re.rgbaComponents
        
        let red1 = components1[0]
        let red2 = components2[0]
        
        let green1 = components1[1]
        let green2 = components2[1]
        
        let blue1 = components1[2]
        let blue2 = components2[2]
        
        let alpha1 = components1.count >= 4 ? components1[3] : 1.0
        let alpha2 = components2.count >= 4 ? components2[3] : 1.0
        
        let red = level1 * red1 + level2 * red2
        let green = level1 * green1 + level2 * green2
        let blue = level1 * blue1 + level2 * blue2
        let alpha = level1 * alpha1 + level2 * alpha2
        
        return Color(.sRGB, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }
    
    /// ReerKit: Blend the color with another SwiftUI color
    ///
    /// - Parameter color: second color to blend
    /// - Returns: Color created by blending self and second colors.
    func blend(with color: Color) -> Color {
        return Color.re.blend(base, intensity1: 0.5, with: color, intensity2: 0.5)
    }
    
    private var rgbaComponents: [CGFloat] {
        if let comps = base.cgColor?.components {
            if comps.count == 4 { return comps }
            if comps.count == 2 { return [comps[0], comps[0], comps[0], comps[1]] }
        }
        return [0, 0, 0, 0]
    }
}

#if canImport(UIKit)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Reer where Base: UIColor {
    /// ReerKit: Convert UIColor to SwiftUI Color.
    ///
    /// - Returns: SwiftUI Color representation of the UIColor.
    var color: Color {
        return Color(base)
    }
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
@available(macOS 10.15, *)
public extension Reer where Base: NSColor {
    /// ReerKit: Convert NSColor to SwiftUI Color.
    ///
    /// - Returns: SwiftUI Color representation of the NSColor.
    var color: Color {
        return Color(base)
    }
}
#endif

#endif

#endif
