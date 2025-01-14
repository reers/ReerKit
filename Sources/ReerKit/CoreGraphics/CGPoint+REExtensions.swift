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

// MARK: - Methods

extension CGPoint: ReerCompatibleValue {}
public extension Reer where Base == CGPoint {
    /// ReerKit: Distance from another CGPoint.
    ///
    ///     let point1 = CGPoint(x: 10, y: 10)
    ///     let point2 = CGPoint(x: 30, y: 30)
    ///     let distance = point1.re.distance(from: point2)
    ///     // distance = 28.28
    ///
    /// - Parameter point: CGPoint to get distance from.
    /// - Returns: Distance between self and given CGPoint.
    func distance(from point: CGPoint) -> CGFloat {
        return CGPoint.re.distance(from: base, to: point)
    }

    /// ReerKit: Distance between two CGPoints.
    ///
    ///     let point1 = CGPoint(x: 10, y: 10)
    ///     let point2 = CGPoint(x: 30, y: 30)
    ///     let distance = CGPoint.re.distance(from: point2, to: point1)
    ///     // distance = 28.28
    ///
    /// - Parameters:
    ///   - point1: first CGPoint.
    ///   - point2: second CGPoint.
    /// - Returns: distance between the two given CGPoints.
    static func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
    }
}

// MARK: - Operators

public extension CGPoint {
    /// ReerKit: Add two CGPoints.
    ///
    ///     let point1 = CGPoint(x: 10, y: 10)
    ///     let point2 = CGPoint(x: 30, y: 30)
    ///     let point = point1 + point2
    ///     // point = CGPoint(x: 40, y: 40)
    ///
    /// - Parameters:
    ///   - lhs: CGPoint to add to.
    ///   - rhs: CGPoint to add.
    /// - Returns: result of addition of the two given CGPoints.
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    /// ReerKit: Add a CGPoints to self.
    ///
    ///     let point1 = CGPoint(x: 10, y: 10)
    ///     let point2 = CGPoint(x: 30, y: 30)
    ///     point1 += point2
    ///     // point1 = CGPoint(x: 40, y: 40)
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGPoint to add.
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    /// ReerKit: Subtract two CGPoints.
    ///
    ///     let point1 = CGPoint(x: 10, y: 10)
    ///     let point2 = CGPoint(x: 30, y: 30)
    ///     let point = point1 - point2
    ///     // point = CGPoint(x: -20, y: -20)
    ///
    /// - Parameters:
    ///   - lhs: CGPoint to subtract from.
    ///   - rhs: CGPoint to subtract.
    /// - Returns: result of subtract of the two given CGPoints.
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    /// ReerKit: Subtract a CGPoints from self.
    ///
    ///     let point1 = CGPoint(x: 10, y: 10)
    ///     let point2 = CGPoint(x: 30, y: 30)
    ///     point1 -= point2
    ///     // point1 = CGPoint(x: -20, y: -20)
    ///
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGPoint to subtract.
    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    /// ReerKit: Multiply a CGPoint with a scalar.
    ///
    ///     let point1 = CGPoint(x: 10, y: 10)
    ///     let scalar = point1 * 5
    ///     // scalar = CGPoint(x: 50, y: 50)
    ///
    /// - Parameters:
    ///   - point: CGPoint to multiply.
    ///   - scalar: scalar value.
    /// - Returns: result of multiplication of the given CGPoint with the scalar.
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    /// ReerKit: Multiply self with a scalar.
    ///
    ///     let point1 = CGPoint(x: 10, y: 10)
    ///     point *= 5
    ///     // point1 = CGPoint(x: 50, y: 50)
    ///
    /// - Parameters:
    ///   - point: `self`.
    ///   - scalar: scalar value.
    /// 
    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point.x *= scalar
        point.y *= scalar
    }

    /// ReerKit: Multiply a CGPoint with a scalar.
    ///
    ///     let point1 = CGPoint(x: 10, y: 10)
    ///     let scalar = 5 * point1
    ///     // scalar = CGPoint(x: 50, y: 50)
    ///
    /// - Parameters:
    ///   - scalar: scalar value.
    ///   - point: CGPoint to multiply.
    /// - Returns: result of multiplication of the given CGPoint with the scalar.
    static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
}

// MARK: - Initializers

public extension CGPoint {

    /// ReerKit: Create a `CGPoint` instance with x, y, but without argument label.
    static func re(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

#endif
