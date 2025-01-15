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
#endif

// MARK: - Properties

public extension Reer where Base: FloatingPoint {
    /// ReerKit: Absolute value of number.
    var abs: Base {
        return Swift.abs(base)
    }

    /// ReerKit: Check if number is positive.
    var isPositive: Bool {
        return base > 0
    }

    /// ReerKit: Check if number is negative.
    var isNegative: Bool {
        return base < 0
    }

    #if canImport(Foundation)
    /// ReerKit: Ceil of number.
    var ceil: Base {
        return Foundation.ceil(base)
    }
    #endif

    /// ReerKit: Radian value of degree input.
    var degreesToRadians: Base {
        return Base.pi * base / Base(180)
    }

    #if canImport(Foundation)
    /// ReerKit: Floor of number.
    var floor: Base {
        return Foundation.floor(base)
    }
    #endif

    /// ReerKit: Degree value of radian input.
    var radiansToDegrees: Base {
        return base * Base(180) / Base.pi
    }
}

// MARK: - Operators

infix operator ±
extension FloatingPoint {
    /// ReerKit: Tuple of plus-minus operation.
    ///
    /// - Parameters:
    ///   - lhs: number.
    ///   - rhs: number.
    /// - Returns: tuple of plus-minus operation ( 2.5 ± 1.5 -> (4, 1)).
    public static func ± (lhs: Self, rhs: Self) -> (Self, Self) {
        // http://nshipster.com/swift-operators/
        return (lhs + rhs, lhs - rhs)
    }
}


prefix operator ±
extension FloatingPoint {
    /// ReerKit: Tuple of plus-minus operation.
    ///
    /// - Parameter number: number.
    /// - Returns: tuple of plus-minus operation (± 2.5 -> (2.5, -2.5)).
    public prefix static func ± (number: Self) -> (Self, Self) {
        // http://nshipster.com/swift-operators/
        return 0 ± number
    }
}


prefix operator √
extension FloatingPoint {
    /// ReerKit: Square root of float.
    ///
    /// - Parameter float: float value to find square root for.
    /// - Returns: square root of given float.
    public prefix static func √ (float: Self) -> Self {
        // http://nshipster.com/swift-operators/
        return sqrt(float)
    }
}
