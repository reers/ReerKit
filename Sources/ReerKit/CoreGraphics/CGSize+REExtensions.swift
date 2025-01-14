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

#if canImport(CoreGraphics)
import CoreGraphics

#if canImport(UIKit)
import UIKit
#endif

extension CGSize: ReerCompatibleValue {}
public extension Reer where Base == CGSize {
    /// ReerKit: Returns the aspect ratio.
    var aspectRatio: CGFloat {
        guard base.height != 0 else { return 0 }
        return base.width / base.height
    }

    /// ReerKit: Returns width or height, whichever is the bigger value.
    var maxDimension: CGFloat {
        return max(base.width, base.height)
    }

    /// ReerKit: Returns width or height, whichever is the smaller value.
    var minDimension: CGFloat {
        return min(base.width, base.height)
    }

    /// ReerKit: Aspect fit CGSize.
    ///
    ///     let rect = CGSize(width: 120, height: 80)
    ///     let parentRect  = CGSize(width: 100, height: 50)
    ///     let newRect = rect.re.aspectFit(to: parentRect)
    ///     //newRect.width = 75 , newRect.height = 50
    ///
    /// - Parameter boundingSize: bounding size to fit self to.
    /// - Returns: self fitted into given bounding size
    func aspectFit(to boundingSize: CGSize) -> CGSize {
        let minRatio = min(boundingSize.width / base.width, boundingSize.height / base.height)
        return CGSize(width: base.width * minRatio, height: base.height * minRatio)
    }

    /// ReerKit: Aspect fill CGSize.
    ///
    ///     let rect = CGSize(width: 20, height: 120)
    ///     let parentRect  = CGSize(width: 100, height: 60)
    ///     let newRect = rect.re.aspectFill(to: parentRect)
    ///     //newRect.width = 100 , newRect.height = 600
    ///
    /// - Parameter boundingSize: bounding size to fill self to.
    /// - Returns: self filled into given bounding size
    func aspectFill(to boundingSize: CGSize) -> CGSize {
        let maxRatio = max(boundingSize.width / base.width, boundingSize.height / base.height)
        return CGSize(width: base.width * maxRatio, height: base.height * maxRatio)
    }
    
    #if canImport(UIKit) && !os(watchOS)
    /// ReerKit: Returns a rectangle to fit the @param rect with specified content mode.
    ///
    /// - Parameters:
    ///   - rect: The constrant rect
    ///   - mode: The content mode
    /// - Returns: A rectangle for the given content mode.
    func fit(inRect rect: CGRect, mode: UIView.ContentMode) -> CGRect {
        var rect = rect.standardized
        var size = base
        size.width = size.width < 0 ? -size.width : size.width
        size.height = size.height < 0 ? -size.height : size.height
        let center = CGPoint(x: rect.midX, y: rect.midY)
        switch mode {
        case .scaleAspectFit, .scaleAspectFill:
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center
                rect.size = CGSize.zero
            }
            else {
                var scale: CGFloat = 0
                if (mode == .scaleAspectFit) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height
                    }
                    else {
                        scale = rect.size.width / size.width
                    }
                }
                else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width
                    }
                    else {
                        scale = rect.size.height / size.height
                    }
                }
                size.width *= scale
                size.height *= scale
                rect.size = size
                rect.origin = CGPoint.init(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
            }
        case .center:
            rect.size = size;
            rect.origin = CGPoint.init(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
        case .top:
            rect.origin.x = center.x - size.width * 0.5
            rect.size = size
        case .bottom:
            rect.origin.x = center.x - size.width * 0.5
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .left:
            rect.origin.y = center.y - size.height * 0.5
            rect.size = size
        case .right:
            rect.origin.y = center.y - size.height * 0.5
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .topLeft:
            rect.size = size
        case .topRight:
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .bottomLeft:
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .bottomRight:
            rect.origin.x += rect.size.width - size.width
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        default:
            break
        }
        return rect
    }
    #endif
}

// MARK: - Operators

public extension CGSize {
    /// ReerKit: Add two CGSize.
    ///
    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     let result = sizeA + sizeB
    ///     // result = CGSize(width: 8, height: 14)
    ///
    /// - Parameters:
    ///   - lhs: CGSize to add to.
    ///   - rhs: CGSize to add.
    /// - Returns: The result comes from the addition of the two given CGSize struct.
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    /// ReerKit: Add a tuple to CGSize.
    ///
    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let result = sizeA + (5, 4)
    ///     // result = CGSize(width: 10, height: 14)
    ///
    /// - Parameters:
    ///   - lhs: CGSize to add to.
    ///   - tuple: tuple value.
    /// - Returns: The result comes from the addition of the given CGSize and tuple.
    static func + (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width + tuple.width, height: lhs.height + tuple.height)
    }

    /// ReerKit: Add a CGSize to self.
    ///
    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     sizeA += sizeB
    ///     // sizeA = CGPoint(width: 8, height: 14)
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGSize to add.
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    /// ReerKit: Add a tuple to self.
    ///
    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     sizeA += (3, 4)
    ///     // result = CGSize(width: 8, height: 14)
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - tuple: tuple value.
    static func += (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width += tuple.width
        lhs.height += tuple.height
    }

    /// ReerKit: Subtract two CGSize.
    ///
    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     let result = sizeA - sizeB
    ///     // result = CGSize(width: 2, height: 6)
    ///
    /// - Parameters:
    ///   - lhs: CGSize to subtract from.
    ///   - rhs: CGSize to subtract.
    /// - Returns: The result comes from the subtract of the two given CGSize struct.
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    /// ReerKit: Subtract a tuple from CGSize.
    ///
    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let result = sizeA - (3, 2)
    ///     // result = CGSize(width: 2, height: 8)
    ///
    /// - Parameters:
    ///   - lhs: CGSize to subtract from.
    ///   - tuple: tuple value.
    /// - Returns: The result comes from the subtract of the given CGSize and tuple.
    static func - (lhs: CGSize, tuple: (width: CGFloat, heoght: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width - tuple.width, height: lhs.height - tuple.heoght)
    }

    /// ReerKit: Subtract a CGSize from self.
    ///
    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     sizeA -= sizeB
    ///     // sizeA = CGPoint(width: 2, height: 6)
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGSize to subtract.
    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    /// ReerKit: Subtract a tuple from self.
    ///
    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     sizeA -= (2, 4)
    ///     // result = CGSize(width: 3, height: 6)
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - tuple: tuple value.
    static func -= (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width -= tuple.width
        lhs.height -= tuple.height
    }

    /// ReerKit: Multiply two CGSize.
    ///
    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     let result = sizeA * sizeB
    ///     // result = CGSize(width: 15, height: 40)
    ///
    /// - Parameters:
    ///   - lhs: CGSize to multiply.
    ///   - rhs: CGSize to multiply with.
    /// - Returns: The result comes from the multiplication of the two given CGSize structs.
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    /// ReerKit: Multiply a CGSize with a scalar.
    ///
    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let result = sizeA * 5
    ///     // result = CGSize(width: 25, height: 50)
    ///
    /// - Parameters:
    ///   - lhs: CGSize to multiply.
    ///   - scalar: scalar value.
    /// - Returns: The result comes from the multiplication of the given CGSize and scalar.
    static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
    }

    /// ReerKit: Multiply a CGSize with a scalar.
    ///
    ///     let sizeA = CGSize(width: 5, height: 10)
    ///     let result = 5 * sizeA
    ///     // result = CGSize(width: 25, height: 50)
    ///
    /// - Parameters:
    ///   - scalar: scalar value.
    ///   - rhs: CGSize to multiply.
    /// - Returns: The result comes from the multiplication of the given scalar and CGSize.
    static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        return CGSize(width: scalar * rhs.width, height: scalar * rhs.height)
    }

    /// ReerKit: Multiply self with a CGSize.
    ///
    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     let sizeB = CGSize(width: 3, height: 4)
    ///     sizeA *= sizeB
    ///     // result = CGSize(width: 15, height: 40)
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGSize to multiply.
    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    /// ReerKit: Multiply self with a scalar.
    ///
    ///     var sizeA = CGSize(width: 5, height: 10)
    ///     sizeA *= 3
    ///     // result = CGSize(width: 15, height: 30)
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - scalar: scalar value.
    static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs.width *= scalar
        lhs.height *= scalar
    }
}

// MARK: - Initializers

public extension CGSize {
    /// ReerKit: Create a `CGSize` instance with side length (same width and height).
    ///
    /// - Parameters:
    ///   - side: side length.
    static func re(side: CGFloat) -> CGSize {
        return CGSize(width: side, height: side)
    }

    /// ReerKit: Create a `CGSize` instance with width, height, but without argument label.
    static func re(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }
}

#endif
