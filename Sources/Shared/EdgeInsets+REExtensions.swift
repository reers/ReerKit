//
//  Copyright © 2020 ReerKit
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

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
/// ReerKit: EdgeInsets
public typealias REEdgeInsets = UIEdgeInsets
#elseif os(macOS)
import Foundation
/// ReerKit: EdgeInsets
public typealias REEdgeInsets = NSEdgeInsets

public extension NSEdgeInsets {
    /// ReerKit: An edge insets struct whose top, left, bottom, and right fields are all set to 0.
    static let zero = NSEdgeInsets()
}

public extension NSEdgeInsets: Equatable {
    /// ReerKit: Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func == (lhs: NSEdgeInsets, rhs: NSEdgeInsets) -> Bool {
        return lhs.top == rhs.top
            && lhs.left == rhs.left
            && lhs.bottom == rhs.bottom
            && lhs.right == rhs.right
    }
}

#endif

#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)

public extension REEdgeInsets {

    /// ReerKit: Creates an `EdgeInsets` with the inset value applied to all (top, bottom, right, left).
    ///
    /// - Parameter inset: Inset to be applied in all the edges.
    static func re(inset: CGFloat) -> REEdgeInsets {
        return REEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

public extension ReerForEquatable where Base == REEdgeInsets {
    /// ReerKit: Return the vertical insets. The vertical insets is composed by top + bottom.
    var vertical: CGFloat {
        return base.top + base.bottom
    }

    /// ReerKit: Return the horizontal insets. The horizontal insets is composed by  left + right.
    var horizontal: CGFloat {
        return base.left + base.right
    }

    /// ReerKit: Creates an `EdgeInsets` based on current value and top offset.
    ///
    /// - Parameters:
    ///   - top: Offset to be applied in to the top edge.
    /// - Returns: EdgeInsets offset with given offset.
    func insetBy(top: CGFloat) -> REEdgeInsets {
        return REEdgeInsets(top: base.top + top, left: base.left, bottom: base.bottom, right: base.right)
    }

    /// ReerKit: Creates an `EdgeInsets` based on current value and left offset.
    ///
    /// - Parameters:
    ///   - left: Offset to be applied in to the left edge.
    /// - Returns: EdgeInsets offset with given offset.
    func insetBy(left: CGFloat) -> REEdgeInsets {
        return REEdgeInsets(top: base.top, left: base.left + left, bottom: base.bottom, right: base.right)
    }

    /// ReerKit: Creates an `EdgeInsets` based on current value and bottom offset.
    ///
    /// - Parameters:
    ///   - bottom: Offset to be applied in to the bottom edge.
    /// - Returns: EdgeInsets offset with given offset.
    func insetBy(bottom: CGFloat) -> REEdgeInsets {
        return REEdgeInsets(top: base.top, left: base.left, bottom: base.bottom + bottom, right: base.right)
    }

    /// ReerKit: Creates an `EdgeInsets` based on current value and right offset.
    ///
    /// - Parameters:
    ///   - right: Offset to be applied in to the right edge.
    /// - Returns: EdgeInsets offset with given offset.
    func insetBy(right: CGFloat) -> REEdgeInsets {
        return REEdgeInsets(top: base.top, left: base.left, bottom: base.bottom, right: base.right + right)
    }
}


// MARK: - Operators

public extension REEdgeInsets {

    /// ReerKit: Add all the properties of two `EdgeInsets` to create their addition.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand expression
    ///   - rhs: The right-hand expression
    /// - Returns: A new `EdgeInsets` instance where the values of `lhs` and `rhs` are added together.
    static func + (_ lhs: REEdgeInsets, _ rhs: REEdgeInsets) -> REEdgeInsets {
        return REEdgeInsets(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }

    /// ReerKit: Add all the properties of two `EdgeInsets` to the left-hand instance.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand expression to be mutated
    ///   - rhs: The right-hand expression
    static func += (_ lhs: inout REEdgeInsets, _ rhs: REEdgeInsets) {
        lhs.top += rhs.top
        lhs.left += rhs.left
        lhs.bottom += rhs.bottom
        lhs.right += rhs.right
    }
}

#endif
