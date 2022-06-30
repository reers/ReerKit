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
public extension Reer where Base: SignedInteger {
    
    /// ReerKit: Absolute value of integer number.
    var abs: Base {
        return Swift.abs(base)
    }
    
    /// ReerKit: Check if integer is positive.
    var isPositive: Bool {
        return base > 0
    }
    
    /// ReerKit: Check if integer is negative.
    var isNegative: Bool {
        return base < 0
    }
    
    /// ReerKit: Check if integer is even.
    var isEven: Bool {
        return (base % 2) == 0
    }
    
    /// ReerKit: Check if integer is odd.
    var isOdd: Bool {
        return (base % 2) != 0
    }
    
    /// ReerKit: String of format (XXh XXm) from seconds Int.
    var timeString: String {
        guard base > 0 else {
            return "0 sec"
        }
        if base < 60 {
            return "\(base) sec"
        }
        if base < 3600 {
            return "\(base / 60) min"
        }
        let hours = base / 3600
        let mins = (base % 3600) / 60
        
        if hours != 0 && mins == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(mins)m"
    }
}

public extension Reer where Base: SignedInteger {
    
    /// ReerKit: Greatest common divisor of integer value and n.
    ///
    /// - Parameter n: integer value to find gcd with.
    /// - Returns: greatest common divisor of self and n.
    func gcd(with n: Base) -> Base {
        return n == 0 ? base : n.re.gcd(with: base % n)
    }
    
    /// ReerKit: Least common multiple of integer and n.
    ///
    /// - Parameter n: integer value to find lcm with.
    /// - Returns: least common multiple of self and n.
    func lcm(with n: Base) -> Base {
        return (base * n).re.abs / gcd(with: n)
    }
    
    #if canImport(Foundation)
    /// ReerKit: Ordinal representation of an integer.
    ///
    ///        print((12).ordinalString()) // prints "12th"
    ///
    /// - Parameter locale: locale, default is .current.
    /// - Returns: string ordinal representation of number in specified locale language. E.g. input 92, output in "en": "92nd".
    func ordinalString(locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .ordinal
        guard let number = base as? NSNumber else { return nil }
        return formatter.string(from: number)
    }
    #endif
}
