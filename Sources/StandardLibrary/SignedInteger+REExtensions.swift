//
//  SignedInteger+REExtensions.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/14.
//  Copyright © 2022 reers. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

// MARK: - Properties
public extension ReerKitWrapper where Base: SignedInteger {
    
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

public extension ReerKitWrapper where Base: SignedInteger {
    
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
