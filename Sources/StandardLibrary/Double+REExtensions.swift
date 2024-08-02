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
#endif

#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

// MARK: - Properties

public extension Reer where Base == Double {
    /// ReerKit: Int.
    var int: Int {
        return Int(base)
    }

    /// ReerKit: Float.
    var float: Float {
        return Float(base)
    }

    #if canImport(CoreGraphics)
    /// ReerKit: CGFloat.
    var cgFloat: CGFloat {
        return CGFloat(base)
    }
    #endif
}

// MARK: - Functions

public extension Reer where Base == Double {
    /// ReerKit: Normalizes a Double value from an input range to an output range.
    ///
    /// - Parameters:
    ///   - inputRange: The range of the input value. This is the original range of the value.
    ///   - outputRange: The desired range for the output value. Defaults to 0...1 if not specified.
    /// - Returns: The normalized value within the output range.
    func normalized(
        from inputRange: ClosedRange<Double>,
        to outputRange: ClosedRange<Double> = 0...1
    ) -> Double {
        let inputMin = inputRange.lowerBound
        let inputMax = inputRange.upperBound
        let outputMin = outputRange.lowerBound
        let outputMax = outputRange.upperBound
        let normalizedValue = (base - inputMin) / (inputMax - inputMin)
        let scaledValue = normalizedValue * (outputMax - outputMin) + outputMin
        return min(max(scaledValue, outputMin), outputMax)
    }
}

// MARK: - Operators

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence
/// ReerKit: Value of exponentiation.
///
/// - Parameters:
///   - lhs: base double.
///   - rhs: exponent double.
/// - Returns: exponentiation result (example: 4.4 ** 0.5 = 2.0976176963).
public func ** (lhs: Double, rhs: Double) -> Double {
    // http://nshipster.com/swift-operators/
    return pow(lhs, rhs)
}
