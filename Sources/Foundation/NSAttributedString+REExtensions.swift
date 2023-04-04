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

#if canImport(Foundation)
import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension Reer where Base: NSAttributedString {
    /// ReerKit: Bolded string using the system font.
    #if !os(Linux)
    var bolded: NSAttributedString {
        guard !base.string.isEmpty else { return base }

        let pointSize: CGFloat
        if let font = base.attribute(.font, at: 0, effectiveRange: nil) as? REFont {
            pointSize = font.pointSize
        } else {
            #if os(tvOS) || os(watchOS)
            pointSize = REFont.preferredFont(forTextStyle: .headline).pointSize
            #else
            pointSize = REFont.systemFontSize
            #endif
        }
        return applying(attributes: [.font: REFont.boldSystemFont(ofSize: pointSize)])
    }
    #endif

    #if !os(Linux)
    /// ReerKit: Underlined string.
    var underlined: NSAttributedString {
        return applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    #endif

    #if canImport(UIKit)
    /// ReerKit: Italicized string using the system font.
    var italicized: NSAttributedString {
        guard !base.string.isEmpty else { return base }

        let pointSize: CGFloat
        if let font = base.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
            pointSize = font.pointSize
        } else {
            #if os(tvOS) || os(watchOS)
            pointSize = UIFont.preferredFont(forTextStyle: .headline).pointSize
            #else
            pointSize = UIFont.systemFontSize
            #endif
        }
        return applying(attributes: [.font: UIFont.italicSystemFont(ofSize: pointSize)])
    }
    #endif

    #if !os(Linux)
    /// ReerKit: Struckthrough string.
    var struckthrough: NSAttributedString {
        return applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)])
    }
    #endif

    /// ReerKit: Dictionary of the attributes applied across the whole string.
    var attributes: [NSAttributedString.Key: Any] {
        guard base.length > 0 else { return [:] }
        return base.attributes(at: 0, effectiveRange: nil)
    }

    /// ReerKit: Applies given attributes to the new instance of NSAttributedString initialized with self object.
    ///
    /// - Parameter attributes: Dictionary of attributes.
    /// - Returns: NSAttributedString with applied attributes.
    func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        guard !base.string.isEmpty else { return base }

        let copy = NSMutableAttributedString(attributedString: base)
        copy.addAttributes(attributes, range: NSRange(0..<base.length))
        return copy
    }

    #if canImport(AppKit) || canImport(UIKit)
    /// ReerKit: Add color to NSAttributedString.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    func colored(with color: REColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    #endif

    /// ReerKit: Apply attributes to substrings matching a regular expression.
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes.
    ///   - pattern: a regular expression to target.
    ///   - options: The regular expression options that are applied to the expression during matching. See NSRegularExpression.Options for possible values.
    /// - Returns: An NSAttributedString with attributes applied to substrings matching the pattern.
    func applying(
        attributes: [NSAttributedString.Key: Any],
        toRangesMatching pattern: String,
        options: NSRegularExpression.Options = []
    ) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return base }

        let matches = pattern.matches(in: base.string, options: [], range: NSRange(0..<base.length))
        let result = NSMutableAttributedString(attributedString: base)

        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }

        return result
    }

    /// ReerKit: Apply attributes to occurrences of a given string.
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes.
    ///   - target: a subsequence string for the attributes to be applied to.
    /// - Returns: An NSAttributedString with attributes applied on the target string.
    func applying<T: StringProtocol>(
        attributes: [NSAttributedString.Key: Any],
        toOccurrencesOf target: T
    ) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"
        return applying(attributes: attributes, toRangesMatching: pattern)
    }
}

// MARK: - Operators

public extension NSAttributedString {
    /// ReerKit: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }

    /// ReerKit: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }

    /// ReerKit: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// ReerKit: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}

public extension ReerGeneric where Base == Array<T>, T: NSAttributedString {
    /// ReerKit: Returns a new `NSAttributedString` by concatenating the elements of the sequence, adding the given separator between each element.
    ///
    /// - Parameter separator: An `NSAttributedString` to add between the elements of the sequence.
    /// - Returns: NSAttributedString with applied attributes.
    func joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = base.first else { return NSMutableAttributedString(string: "") }
        return base.dropFirst().reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
            result.append(separator)
            result.append(element)
        }
    }

    func joined(separator: String) -> NSAttributedString {
        guard let firstElement = base.first else { return NSMutableAttributedString(string: "") }
        let attributedStringSeparator = NSAttributedString(string: separator)
        return base.dropFirst().reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
            result.append(attributedStringSeparator)
            result.append(element)
        }
    }
}

#endif
