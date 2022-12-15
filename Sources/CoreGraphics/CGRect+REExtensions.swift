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

extension CGRect: ReerCompatibleValue {}
public extension Reer where Base == CGRect {
    /// ReerKit: Return center of rect.
    var center: CGPoint { CGPoint(x: base.midX, y: base.midY) }

    /// ReerKit: Create a new `CGRect` by resizing with specified anchor.
    /// - Parameters:
    ///   - size: new size to be applied.
    ///   - anchor: specified anchor, a point in normalized coordinates -
    ///     '(0, 0)' is the top left corner of rect，'(1, 1)' is the bottom right corner of rect,
    ///     defaults to '(0.5, 0.5)'. Example:
    ///
    ///          anchor = CGPoint(x: 0.0, y: 1.0):
    ///
    ///                       A2------B2
    ///          A----B       |        |
    ///          |    |  -->  |        |
    ///          C----D       C-------D2
    ///
    func resizing(to size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        let sizeDelta = CGSize(width: size.width - base.width, height: size.height - base.height)
        return CGRect(
            origin: CGPoint(
                x: base.minX - sizeDelta.width * anchor.x,
                y: base.minY - sizeDelta.height * anchor.y
            ),
            size: size
        )
    }
}

// MARK: - Initializers

public extension CGRect {
    /// ReerKit: Create a `CGRect` instance with center and size.
    /// - Parameters:
    ///   - center: center of the new rect.
    ///   - size: size of the new rect.
    static func re(center: CGPoint, size: CGSize) -> CGRect {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        return CGRect(origin: origin, size: size)
    }

    /// ReerKit: Create a `CGRect` instance with x, y, width, height, but without argument label.
    static func re(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

#endif
