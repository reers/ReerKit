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
public extension Reer where Base == Int {
    
    /// ReerKit: Bool
    var bool: Bool {
        return base != 0
    }
    
    /// ReerKit: Radian value of degree input.
    var degreesToRadians: Double {
        return Double.pi * Double(base) / 180.0
    }
    
    /// ReerKit: Degree value of radian input
    var radiansToDegrees: Double {
        return Double(base) * 180 / Double.pi
    }
    
    /// ReerKit: UInt.
    var uInt: UInt {
        return UInt(base)
    }
    
    /// ReerKit: Double.
    var double: Double {
        return Double(base)
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
    
    #if !os(watchOS)
    /// ReerKit: String formatted for values over ±1000 (example: 1k, -2k, 100k, 1m, -5m..)
    var metricFormatted: String {
        var sign: String {
            return base >= 0 ? "" : "-"
        }
        let abs = Swift.abs(base)
        if abs == 0 {
            return "0k"
        } else if abs >= 0, abs < 1000 {
            return "0k"
        } else if abs >= 1000, abs < 1_000_000 {
            return String(format: "\(sign)%ik", abs / 1000)
        } else if abs >= 1_000_000, abs < 1_000_000_000 {
            return String(format: "\(sign)%im", abs / 1_000_000)
        } else if abs >= 1_000_000_000, abs < 1_000_000_000_000 {
            return String(format: "\(sign)%ig", abs / 1_000_000_000)
        }
        return String(format: "\(sign)%it", abs / 1_000_000_000_000)
    }
    #endif
    
    /// ReerKit: Array of digits of integer value.
    var digits: [Int] {
        guard base != 0 else { return [0] }
        var digits = [Int]()
        var number = base.re.abs
        
        while number != 0 {
            let x = number % 10
            digits.append(x)
            number = number / 10
        }
        
        digits.reverse()
        return digits
    }
    
    /// ReerKit: Number of digits of integer value.
    var digitsCount: Int {
        guard base != 0 else { return 1 }
        let number = Double(base.re.abs)
        return Int(log10(number) + 1)
    }
}

public extension Reer where Base == Int {
    
    /// ReerKit: check if given integer prime or not.
    /// Warning: Using big numbers can be computationally expensive!
    /// - Returns: true or false depending on prime-ness
    func isPrime() -> Bool {
        if base == 2 { return true }
        guard base > 1 && base % 2 != 0 else { return false }
        
        let max = Int(sqrt(Double(base)))
        for i in Swift.stride(from: 3, through: max, by: 2) where base % i == 0 {
            return false
        }
        return true
    }
    
    /// ReerKit: Roman numeral string from integer (if applicable).
    ///
    ///     10.romanNumeral() -> "X"
    ///
    /// - Returns: The roman numeral string.
    func romanNumeral() -> String? {
        
        guard base > 0 else { // there is no roman numerals for 0 or negative numbers
            return nil
        }
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        
        var romanValue = ""
        var startingValue = base
        
        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]
            let div = startingValue / arabicValue
            if div > 0 {
                for _ in 0..<div {
                    romanValue += romanChar
                }
                startingValue -= arabicValue * div
            }
        }
        return romanValue
    }

}


precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence
/// ReerKit: Value of exponentiation.
///
/// - Parameters:
///   - lhs: base integer.
///   - rhs: exponent integer.
/// - Returns: exponentiation result (example: 2 ** 3 = 8).
public func ** (lhs: Int, rhs: Int) -> Double {
    return pow(Double(lhs), Double(rhs))
}

prefix operator √
/// ReerKit: Square root of integer.
///
/// - Parameter int: integer value to find square root for
/// - Returns: square root of given integer.
public prefix func √ (int: Int) -> Double {
    return sqrt(Double(int))
}

infix operator ±
/// ReerKit: Tuple of plus-minus operation.
///
///     2 ± 3 -> (5, -1)
/// - Parameters:
///   - lhs: integer number.
///   - rhs: integer number.
/// - Returns: Tuple of plus-minus operation
public func ± (lhs: Int, rhs: Int) -> (Int, Int) {
    return (lhs + rhs, lhs - rhs)
}

prefix operator ±
/// ReerKit: Tuple of plus-minus operation.
///
/// - Parameter int: integer number
/// - Returns: Tuple of plus-minus operation (example: ± 2 -> (2, -2)).
///            The first value must be positive, the second is negative, or both is zero.
public prefix func ± (int: Int) -> (Int, Int) {
    let positiveValue = int.re.abs
    return (positiveValue, -positiveValue)
}



