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

extension CGVector: ReerCompatibleValue {}
public extension Reer where Base == CGVector {
    /// ReerKit: The angle of rotation (in radians) of the vector. The range of the angle is -π to π; an angle of 0 points to the right.
    ///
    var angle: CGFloat {
        return atan2(base.dy, base.dx)
    }

    /// ReerKit: The magnitude (or length) of the vector.
    ///
    var magnitude: CGFloat {
        return sqrt((base.dx * base.dx) + (base.dy * base.dy))
    }
}

// MARK: - Initializers

public extension CGVector {
    /// ReerKit: Creates a vector with the given magnitude and angle.
    ///
    ///     let vector = CGVector.re(angle: .pi, magnitude: 1)
    ///
    /// - Parameters:
    ///     - angle: The angle of rotation (in radians) counterclockwise from the positive x-axis.
    ///     - magnitude: The length of the vector.
    ///
    static func re(angle: CGFloat, magnitude: CGFloat) -> CGVector {
        self.init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

// MARK: - Operators

public extension CGVector {
    /// ReerKit: Multiplies a scalar and a vector (commutative).
    ///
    ///     let vector = CGVector(dx: 1, dy: 1)
    ///     let largerVector = vector * 2
    ///
    /// - Parameters:
    ///   - vector: The vector to be multiplied.
    ///   - scalar: The scale by which the vector will be multiplied.
    /// - Returns: The vector with its magnitude scaled.
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }

    /// ReerKit: Multiplies a scalar and a vector (commutative).
    ///
    ///     let vector = CGVector(dx: 1, dy: 1)
    ///     let largerVector = 2 * vector
    ///
    /// - Parameters:
    ///   - scalar: The scalar by which the vector will be multiplied.
    ///   - vector: The vector to be multiplied.
    /// - Returns: The vector with its magnitude scaled.
    static func * (scalar: CGFloat, vector: CGVector) -> CGVector {
        return CGVector(dx: scalar * vector.dx, dy: scalar * vector.dy)
    }

    /// ReerKit: Compound assignment operator for vector-scalar multiplication.
    ///
    ///     var vector = CGVector(dx: 1, dy: 1)
    ///     vector *= 2
    ///
    /// - Parameters:
    ///   - vector: The vector to be multiplied.
    ///   - scalar: The scale by which the vector will be multiplied.
    static func *= (vector: inout CGVector, scalar: CGFloat) {
        vector.dx *= scalar
        vector.dy *= scalar
    }

    /// ReerKit: Negates the vector. The direction is reversed, but magnitude remains the same.
    ///
    ///     let vector = CGVector(dx: 1, dy: 1)
    ///     let reversedVector = -vector
    ///
    /// - Parameter vector: The vector to be negated.
    /// - Returns: The negated vector.
    static prefix func - (vector: CGVector) -> CGVector {
        return CGVector(dx: -vector.dx, dy: -vector.dy)
    }
}

#endif
