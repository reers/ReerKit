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

public extension SignedNumeric {
    /// Gets a namespace holder for ReerKit compatible types.
    var re: Reer<Self> {
        get { return Reer(self) }
        set {}
    }
    
    /// Gets a namespace holder for ReerKit compatible meta types.
    static var re: Reer<Self>.Type {
        get { return Reer.self }
        set {}
    }
}

// MARK: - Properties

public extension Reer where Base: SignedNumeric {
    
    /// ReerKit: String.
    var string: String {
        return String(describing: base)
    }
}

// MARK: - Methods

public extension Reer where Base: SignedNumeric {
    
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

