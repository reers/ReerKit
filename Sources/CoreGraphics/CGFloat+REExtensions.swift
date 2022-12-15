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

#if canImport(Foundation)
import Foundation
#endif

public extension Reer where Base == CGFloat {
    /// ReerKit: Absolute of CGFloat value.
    var abs: CGFloat {
        return Swift.abs(base)
    }

    #if canImport(Foundation)
    /// ReerKit: Ceil of CGFloat value.
    var ceil: CGFloat {
        return Foundation.ceil(base)
    }
    #endif

    /// ReerKit: Radian value of degree input.
    var degreesToRadians: CGFloat {
        return .pi * base / 180.0
    }

    #if canImport(Foundation)
    /// ReerKit: Floor of CGFloat value.
    var floor: CGFloat {
        return Foundation.floor(base)
    }
    #endif

    /// ReerKit: Check if CGFloat is positive.
    var isPositive: Bool {
        return base > 0
    }

    /// ReerKit: Check if CGFloat is negative.
    var isNegative: Bool {
        return base < 0
    }

    /// ReerKit: Int.
    var int: Int {
        return Int(base)
    }

    /// ReerKit: Float.
    var float: Float {
        return Float(base)
    }

    /// ReerKit: Double.
    var double: Double {
        return Double(base)
    }

    /// ReerKit: Degree value of radian input.
    var radiansToDegrees: CGFloat {
        return base * 180 / CGFloat.pi
    }
}

#endif
