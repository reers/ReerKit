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

    /// ReerKit: Dictionary of the attributes applied across the whole string.
    var attributes: [NSAttributedString.Key: Any] {
        guard base.length > 0 else { return [:] }
        return base.attributes(at: 0, effectiveRange: nil)
    }
    
    #if !os(Linux)
    @available(*, deprecated, renamed: "numberOfLines(forWidth:ignoreBlankLines:)", message: "Use numberOfLines(forWidth:ignoringBlankLines:) instead.")
    func lines(forWidth width: CGFloat, ignoreBlankLines: Bool = false) -> Int {
        return numberOfLines(forWidth: width, ignoreBlankLines: ignoreBlankLines)
    }
    
    /// ReerKit: Calculate lines for a `NSAttributedString` with a width constrained.
    /// - Parameters:
    ///   - width: A constrained of container view width.
    ///   - ignoreBlankLines: Whether should ignore blank lines.
    /// - Returns: Total lines of the attributed string after rendering.
    func numberOfLines(forWidth width: CGFloat, ignoreBlankLines: Bool = false) -> Int {
        let framesetter = CTFramesetterCreateWithAttributedString(base as! CFAttributedString)
        let path = CGPath(rect: .init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame) as Array
        var numberOfLines = lines.count
        
        if base.string.hasSuffix("\n") {
            numberOfLines += 1
        }
        
        if ignoreBlankLines, let ctLines = lines as? [CTLine] {
            numberOfLines = 0
            for ctLine in ctLines {
                let lineRange = CTLineGetStringRange(ctLine)
                let startIndex = base.string.index(base.string.startIndex, offsetBy: Int(lineRange.location))
                let endIndex = base.string.index(startIndex, offsetBy: Int(lineRange.length))
                let lineString = base.string[startIndex..<endIndex]
                let trimmed = lineString.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    numberOfLines += 1
                }
            }
        }
        
        return numberOfLines
    }
    
    /// ReerKit: Calculate height for a `NSAttributedString` with a constrained width.
    /// - Parameter width: A constrained of container view width.
    /// - Returns: Total height of the attributed string after rendering.
    func height(forWidth width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = base.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.height
    }
    #endif

    /// ReerKit: Applies given attributes to the new instance of NSAttributedString initialized with self object.
    ///
    /// - Parameter attributes: Dictionary of attributes.
    /// - Returns: NSAttributedString with applied attributes.
    func with(attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        guard !base.string.isEmpty else { return NSMutableAttributedString(string: "") }

        let copy = NSMutableAttributedString(attributedString: base)
        copy.addAttributes(attributes, range: NSRange(0..<base.length))
        return copy
    }

    /// ReerKit: Apply attributes to substrings matching a regular expression.
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes.
    ///   - pattern: a regular expression to target.
    ///   - options: The regular expression options that are applied to the expression during matching. See NSRegularExpression.Options for possible values.
    /// - Returns: An NSAttributedString with attributes applied to substrings matching the pattern.
    func with(
        attributes: [NSAttributedString.Key: Any],
        toRangesMatching pattern: String,
        options: NSRegularExpression.Options = []
    ) -> NSMutableAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: options) else { return NSMutableAttributedString(string: "") }

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
    func with<T: StringProtocol>(
        attributes: [NSAttributedString.Key: Any],
        toOccurrencesOf target: T
    ) -> NSMutableAttributedString {
        let pattern = "\\Q\(target)\\E"
        return with(attributes: attributes, toRangesMatching: pattern)
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
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return string
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
    static func + (lhs: NSAttributedString, rhs: String) -> NSMutableAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}

public extension ReerGeneric where Base == Array<T>, T: NSAttributedString {
    /// ReerKit: Returns a new `NSAttributedString` by concatenating the elements of the sequence, adding the given separator between each element.
    ///
    /// - Parameter separator: An `NSAttributedString` to add between the elements of the sequence.
    /// - Returns: NSAttributedString with applied attributes.
    func joined(separator: NSAttributedString) -> NSMutableAttributedString {
        guard let firstElement = base.first else { return NSMutableAttributedString(string: "") }
        return base.dropFirst().reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
            result.append(separator)
            result.append(element)
        }
    }

    func joined(separator: String) -> NSMutableAttributedString {
        guard let firstElement = base.first else { return NSMutableAttributedString(string: "") }
        let attributedStringSeparator = NSAttributedString(string: separator)
        return base.dropFirst().reduce(into: NSMutableAttributedString(attributedString: firstElement)) { result, element in
            result.append(attributedStringSeparator)
            result.append(element)
        }
    }
}

#endif
