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

#if canImport(QuartzCore)

import QuartzCore

extension CATransform3D: ReerCompatibleValue {}

// MARK: - Equatable

extension CATransform3D: Equatable {
    /// ReerKit: Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    @inlinable
    public static func == (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
        return CATransform3DEqualToTransform(lhs, rhs)
    }
}

// MARK: - Properties

public extension Reer where Base == CATransform3D {
    /// ReerKit: The identity transform: [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1].
    @inlinable
    static var identity: CATransform3D { CATransform3DIdentity }

    /// ReerKit: Returns `true` if the receiver is the identity transform.
    @inlinable
    var isIdentity: Bool { CATransform3DIsIdentity(base) }
}


// MARK: - Initializers

public extension CATransform3D {
    /// ReerKit: Returns a transform that translates by `(tx, ty, tz)`.
    /// - Parameters:
    ///   - tx: x-axis translation
    ///   - ty: y-axis translation
    ///   - tz: z-axis translation
    @inlinable
    static func re(translationX tx: CGFloat, y ty: CGFloat, z tz: CGFloat) -> CATransform3D {
        return CATransform3DMakeTranslation(tx, ty, tz)
    }

    /// ReerKit: Returns a transform that scales by `(sx, sy, sz)`.
    /// - Parameters:
    ///   - sx: x-axis scale
    ///   - sy: y-axis scale
    ///   - sz: z-axis scale
    @inlinable
    static func re(scaleX sx: CGFloat, y sy: CGFloat, z sz: CGFloat) -> CATransform3D {
        return CATransform3DMakeScale(sx, sy, sz)
    }

    /// ReerKit: Returns a transform that rotates by `angle` radians about the vector `(x, y, z)`.
    ///
    /// If the vector has zero length the behavior is undefined.
    /// - Parameters:
    ///   - angle: The angle of rotation
    ///   - x: x position of the vector
    ///   - y: y position of the vector
    ///   - z: z position of the vector
    @inlinable
    static func re(rotationAngle angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
        return CATransform3DMakeRotation(angle, x, y, z)
    }
}

// MARK: - Nonmutating Methods

public extension Reer where Base == CATransform3D {
    /// ReerKit: Translate the receiver by `(tx, ty, tz)`.
    /// - Parameters:
    ///   - tx: x-axis translation
    ///   - ty: y-axis translation
    ///   - tz: z-axis translation
    /// - Returns: The translated matrix.
    @inlinable
    func translatedBy(x tx: CGFloat, y ty: CGFloat, z tz: CGFloat) -> CATransform3D {
        return CATransform3DTranslate(base, tx, ty, tz)
    }

    /// ReerKit: Scale the receiver by `(sx, sy, sz)`.
    /// - Parameters:
    ///   - sx: x-axis scale
    ///   - sy: y-axis scale
    ///   - sz: z-axis scale
    /// - Returns: The scaled matrix.
    @inlinable
    func scaledBy(x sx: CGFloat, y sy: CGFloat, z sz: CGFloat) -> CATransform3D {
        return CATransform3DScale(base, sx, sy, sz)
    }

    /// ReerKit: Rotate the receiver by `angle` radians about the vector `(x, y, z)`.
    ///
    /// If the vector has zero length the behavior is undefined.
    /// - Parameters:
    ///   - angle: The angle of rotation
    ///   - x: x position of the vector
    ///   - y: y position of the vector
    ///   - z: z position of the vector
    /// - Returns: The rotated matrix.
    @inlinable
    func rotated(by angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
        return CATransform3DRotate(base, angle, x, y, z)
    }

    /// ReerKit: Invert the receiver.
    ///
    /// Returns the original matrix if the receiver has no inverse.
    /// - Returns: The inverted matrix of the receiver.
    @inlinable
    func inverted() -> CATransform3D {
        return CATransform3DInvert(base)
    }

    /// ReerKit: Concatenate `transform` to the receiver.
    /// - Parameter t2: The transform to concatenate on to the receiver
    /// - Returns: The concatenated matrix.
    @inlinable
    func concatenating(_ t2: CATransform3D) -> CATransform3D {
        return CATransform3DConcat(base, t2)
    }
}

extension CATransform3D: ReerReferenceCompatible {}
public extension ReerReference where Base == CATransform3D {
    /// ReerKit: Translate the receiver by `(tx, ty, tz)`.
    /// - Parameters:
    ///   - tx: x-axis translation
    ///   - ty: y-axis translation
    ///   - tz: z-axis translation
    @inlinable
    mutating func translateBy(x tx: CGFloat, y ty: CGFloat, z tz: CGFloat) {
        base.pointee = CATransform3DTranslate(base.pointee, tx, ty, tz)
    }

    /// ReerKit: Scale the receiver by `(sx, sy, sz)`.
    /// - Parameters:
    ///   - sx: x-axis scale
    ///   - sy: y-axis scale
    ///   - sz: z-axis scale
    @inlinable
    mutating func scaleBy(x sx: CGFloat, y sy: CGFloat, z sz: CGFloat) {
        base.pointee = CATransform3DScale(base.pointee, sx, sy, sz)
    }

    /// ReerKit: Rotate the receiver by `angle` radians about the vector `(x, y, z)`.
    ///
    /// If the vector has zero length the behavior is undefined.
    /// - Parameters:
    ///   - angle: The angle of rotation
    ///   - x: x position of the vector
    ///   - y: y position of the vector
    ///   - z: z position of the vector
    @inlinable
    mutating func rotate(by angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        base.pointee = CATransform3DRotate(base.pointee, angle, x, y, z)
    }

    /// ReerKit: Invert the receiver.
    ///
    /// Returns the original matrix if the receiver has no inverse.
    @inlinable
    mutating func invert() {
        base.pointee = CATransform3DInvert(base.pointee)
    }

    /// ReerKit: Concatenate `transform` to the receiver.
    /// - Parameter t2: The transform to concatenate on to the receiver
    @inlinable
    mutating func concatenate(_ t2: CATransform3D) {
        base.pointee = CATransform3DConcat(base.pointee, t2)
    }
}

#if canImport(CoreGraphics)

import CoreGraphics

// MARK: - CGAffineTransform

public extension Reer where Base == CATransform3D {
    /// ReerKit: Returns true if the receiver can be represented exactly by an affine transform.
    @inlinable
    var isAffine: Bool { return CATransform3DIsAffine(base) }

    /// ReerKit: Returns the affine transform represented by the receiver.
    ///
    /// If the receiver can not be represented exactly by an affine transform the returned value is undefined.
    @inlinable
    func affineTransform() -> CGAffineTransform {
        return CATransform3DGetAffineTransform(base)
    }
}

#endif

#endif
