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

// MARK: - Initializer

public extension REColor {
    /// ReerKit: Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - alpha: optional transparency value (default is 1).
    static func re(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) -> UIColor {
        let red = max(0, min(255, red))
        let green = max(0, min(255, green))
        let blue = max(0, min(255, blue))
        let alpha = max(0, min(1, alpha))
        return REColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    /// ReerKit: Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int with 6 digits (example: 0xDECEB5).
    ///   - alpha: optional transparency value (default is 1).
    static func re(hex: Int, alpha: CGFloat = 1) -> REColor {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        let alpha = max(0, min(1, alpha))
        return REColor.re(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// ReerKit: Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - alpha: optional transparency value (default is 1).
    static func re(hexString: String, alpha: CGFloat = 1) -> REColor {
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

        return REColor.re(hex: hexValue, alpha: alpha)
    }

    /// ReerKit: Create Color from hexadecimal value in the format ARGB (alpha-red-green-blue).
    ///
    /// - Parameters:
    ///   - argbHex: hexadecimal value with 8 digits (examples: 0x7FEDE7F6).
    static func re(argbHex: Int) -> REColor {
        let alpha = (argbHex >> 24) & 0xFF
        let red = (argbHex >> 16) & 0xFF
        let green = (argbHex >> 8) & 0xFF
        let blue = argbHex & 0xFF
        return REColor.re(red: red, green: green, blue: blue, alpha: CGFloat(alpha) / 255)
    }

    /// ReerKit: Create Color from hexadecimal string in the format ARGB (alpha-red-green-blue).
    ///
    /// - Parameters:
    ///   - argbHexString: hexadecimal string (examples: 7FEDE7F6, 0x7FEDE7F6, #7FEDE7F6, #f0ff, 0xFF0F, ..).
    static func re(argbHexString: String) -> REColor {
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

        return REColor.re(red: red, green: green, blue: blue, alpha: CGFloat(alpha) / 255)
    }

    /// ReerKit: Create Color from hexadecimal value in the format RGBA (red-green-blue-alpha).
    ///
    /// - Parameters:
    ///   - rgbaHex: hexadecimal value with 8 digits  (examples: 0x7FEDE7F6).
    static func re(rgbaHex: Int) -> REColor {
        let red = (rgbaHex >> 24) & 0xFF
        let green = (rgbaHex >> 16) & 0xFF
        let blue = (rgbaHex >> 8) & 0xFF
        let alpha = rgbaHex & 0xFF
        return REColor.re(red: red, green: green, blue: blue, alpha: CGFloat(alpha) / 255)
    }

    /// ReerKit: Create Color from hexadecimal string in the format RGBA (red-green-blue-alpha).
    ///
    /// - Parameters:
    ///   - argbHexString: hexadecimal string (examples: 7FEDE7F6, 0x7FEDE7F6, #7FEDE7F6, #f0ff, 0xFF0F, ..).
    static func re(rgbaHexString: String) -> REColor {
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

        return REColor.re(red: red, green: green, blue: blue, alpha: CGFloat(alpha) / 255)
    }

    /// ReerKit: Create a dynamic color with light and dark color.
    static func re(light: REColor, dark: REColor) -> REColor {
        if #available(iOS 13.0, *) {
            return REColor.init { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        } else {
            return light
        }
    }
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

    /// ReerKit: Alpha of Color (read-only).
    var alpha: CGFloat {
        return base.cgColor.alpha
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

#endif
