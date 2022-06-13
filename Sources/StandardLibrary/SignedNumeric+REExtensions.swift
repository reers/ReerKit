//
//  SignedNumeric+REExtensions.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/14.
//  Copyright © 2022 reers. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

public extension SignedNumeric {
    /// Gets a namespace holder for ReerKit compatible types.
    var re: ReerKitWrapper<Self> {
        get { return ReerKitWrapper(self) }
        set {}
    }
    
    /// Gets a namespace holder for ReerKit compatible meta types.
    static var re: ReerKitWrapper<Self>.Type {
        get { return ReerKitWrapper.self }
        set {}
    }
}

// MARK: - Properties

public extension ReerKitWrapper where Base: SignedNumeric {
    
    /// ReerKit: String.
    var string: String {
        return String(describing: base)
    }
}

// MARK: - Methods

public extension ReerKitWrapper where Base: SignedNumeric {
    
    #if canImport(Foundation)
    /// ReerKit: String with number and current locale currency.
    func localeCurrency(_ locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: base as! NSNumber)
    }
    #endif
    
    #if canImport(Foundation)
    /// ReerKit: Spelled out representation of a number.
    ///
    ///        print((12.32).spelledOutString()) // prints "twelve point three two"
    ///
    /// - Parameter locale: Locale, default is .current.
    /// - Returns: String representation of number spelled in specified locale language. E.g. input 92, output in "en": "ninety-two".
    func spelledOutString(locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .spellOut
        guard let number = base as? NSNumber else { return nil }
        return formatter.string(from: number)
    }
    #endif
}

