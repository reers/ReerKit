//
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

postfix operator ~!
public postfix func ~! <T>(value: T) -> T? {
    return Optional(value)
}

extension Optional: ReerGenericCompatible {
    public typealias T = Wrapped
}

// MARK: - Check state of an Optional instance.

public extension ReerGeneric where Base == Optional<T> {
    
    /// ReerKit: Contains a nil value.
    var isNil: Bool {
        switch base {
        case .none: return true
        default: return false
        }
    }
    
    /// ReerKit: Contains a valid value.
    var isValid: Bool {
        return !isNil
    }
}

// MARK: - Get a value from the optional.

public extension ReerGeneric where Base == Optional<T> {
    
    /// ReerKit: Get the optional wrapped value or the passed default value if it is nil.
    ///
    ///        let foo: String? = nil
    ///        print(foo.re.value(default: "bar")) -> "bar"
    ///
    ///        let bar: String? = "bar"
    ///        print(bar.re.value(default: "foo")) -> "bar"
    ///
    /// - Parameter defaultValue: default value to return if self is nil.
    /// - Returns: self if not nil or default value if nil.
    func value(default defaultValue: T) -> T {
        return base ?? defaultValue
    }
    
    /// ReerKit: Gets the wrapped value of an optional. If the optional is `nil`, throw a custom error.
    ///
    ///        let foo: String? = nil
    ///        try print(foo.re.value(throw: MyError.notFound)) -> error: MyError.notFound
    ///
    ///        let bar: String? = "bar"
    ///        try print(bar.re.value(throw: MyError.notFound)) -> "bar"
    ///
    /// - Parameter error: The error to throw if the optional is `nil`.
    /// - Throws: The error passed in.
    /// - Returns: The value wrapped by the optional.
    func value(throw error: Error) throws -> T {
        guard let wrapped = base else { throw error }
        return wrapped
    }
    
    /// ReerKit: Runs a closure to Wrapped if not nil.
    ///
    ///        let foo: String? = nil
    ///        foo.re.run { unwrappedFoo in
    ///            // block will never run since foo is nil
    ///            print(unwrappedFoo)
    ///        }
    ///
    ///        let bar: String? = "bar"
    ///        bar.re.run { unwrappedBar in
    ///            // block will run since bar is not nil
    ///            print(unwrappedBar) -> "bar"
    ///        }
    ///
    /// - Parameter block: a block to run if self is not nil.
    func run(_ action: (T) -> Void) {
        _ = base.map(action)
    }
}

// MARK: - Get bool/string/int/float/double/cgFloat value from the optional.

public extension ReerGeneric where Base == Optional<T> {
    
    /// ReerKit: Transform the optional wrapped value to `Bool` if possible.
    ///
    ///     let a: Any? = 23
    ///     a.re.bool -> Optional(true)
    var bool: Bool? {
        if isNil { return nil }
        if let bool = base as? Bool {
            return bool
        } else if let stringConvertible = base as? CustomStringConvertible,
                  let double = Double(stringConvertible.description) {
            return double != .zero
        } else if let string = base as? String {
            if let int = string~!.re.int {
                return int != 0
            } else {
                let lowercasedString = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                switch lowercasedString {
                case "true", "yes":
                    return true
                case "false", "no":
                    return false
                default:
                    return nil
                }
            }
        } else {
            return nil
        }
    }
    
    /// ReerKit: Transform the optional wrapped value to `Bool` if possible.
    /// Return `false` if failed.
    var boolValue: Bool {
        boolValue(default: false)
    }
    
    /// ReerKit: Transform the optional wrapped value to `Bool` if possible.
    /// Return the passed default value if it is nil.
    func boolValue(default defaultValue: Bool) -> Bool {
        guard let bool = bool else { return defaultValue }
        return bool
    }
    
    /// ReerKit: Transform the optional wrapped value to `Int` if possible.
    ///
    ///     let a: Any? = "23"
    ///     a.re.int -> Optional(23)
    var int: Int? {
        if isNil { return nil }
        if let stringConvertible = base as? CustomStringConvertible,
           let double = Double(stringConvertible.description) {
            return Int(double)
        } else if let bool = base as? Bool {
            return bool ? 1 : 0
        } else {
            return nil
        }
    }
    
    /// ReerKit: Transform the optional wrapped value to `Int` if possible.
    /// Return `0` if failed.
    var intValue: Int {
        intValue(default: 0)
    }
    
    /// ReerKit: Transform the optional wrapped value to `Int` if possible.
    /// Return the passed default value if it is nil.
    func intValue(default defaultValue: Int) -> Int {
        guard let int = int else { return defaultValue }
        return int
    }
    
    /// ReerKit: Transform the optional wrapped value to `String` if possible.
    ///
    ///     let a: Any? = 23
    ///     a.re.string -> Optional("23")
    var string: String? {
        if let string = base as? String {
            return string
        } else if let bool = base as? Bool {
            return bool ? "true" : "false"
        } else if let stringConvertible = base as? CustomStringConvertible {
            if let int = Int(stringConvertible.description) {
                return int.description
            } else if let double = Double(stringConvertible.description) {
                return double.description
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// ReerKit: Transform the optional wrapped value to `String` if possible.
    /// Return `""` if failed.
    var stringValue: String {
        stringValue(default: "")
    }
    
    /// ReerKit: Transform the optional wrapped value to `String` if possible.
    /// Return the passed default value if it is nil.
    func stringValue(default defaultValue: String) -> String {
        guard let string = string else { return defaultValue }
        return string
    }
    
    /// ReerKit: Transform the optional wrapped value to `Double` if possible.
    ///
    ///     let a: Any? = 23
    ///     a.re.double -> Optional(23.0)
    var double: Double? {
        if isNil { return nil }
        if let stringConvertible = base as? CustomStringConvertible,
           let double = Double(stringConvertible.description) {
            return double
        } else if let bool = base as? Bool {
            return bool ? 1.0 : 0.0
        } else {
            return nil
        }
    }
    
    /// ReerKit: Transform the optional wrapped value to `Double` if possible.
    /// Return `0` if failed.
    var doubleValue: Double {
        doubleValue(default: 0.0)
    }
    
    /// ReerKit: Transform the optional wrapped value to `Double` if possible.
    /// Return the passed default value if it is nil.
    func doubleValue(default defaultValue: Double) -> Double {
        guard let double = double else { return defaultValue }
        return double
    }
    
    /// ReerKit: Transform the optional wrapped value to `Float` if possible.
    ///
    ///     let a: Any? = 23
    ///     a.re.float -> Optional(23.0)
    var float: Float? {
        if isNil { return nil }
        if let stringConvertible = base as? CustomStringConvertible,
           let float = Float(stringConvertible.description) {
            return float
        } else if let bool = base as? Bool {
            return bool ? 1.0 : 0.0
        } else {
            return nil
        }
    }
    
    /// ReerKit: Transform the optional wrapped value to `Float` if possible.
    /// Return `0` if failed.
    var floatValue: Float {
        floatValue(default: 0.0)
    }
    
    /// ReerKit: Transform the optional wrapped value to `Float` if possible.
    /// Return the passed default value if it is nil.
    func floatValue(default defaultValue: Float) -> Float {
        guard let float = float else { return defaultValue }
        return float
    }
    
    #if canImport(CoreGraphics)
    /// ReerKit: Transform the optional wrapped value to `CGFloat` if possible.
    ///
    ///     let a: Any? = 23
    ///     a.re.cgFloat -> Optional(23.0)
    var cgFloat: CGFloat? {
        guard let double = double else { return nil }
        return CGFloat(double)
    }
    
    /// ReerKit: Transform the optional wrapped value to `CGFloat` if possible.
    /// Return `0` if failed.
    var cgFloatValue: CGFloat {
        cgFloatValue(default: 0.0)
    }
    
    /// ReerKit: Transform the optional wrapped value to `CGFloat` if possible.
    /// Return the passed default value if it is nil.
    func cgFloatValue(default defaultValue: CGFloat) -> CGFloat {
        guard let cgFloat = cgFloat else { return defaultValue }
        return cgFloat
    }
    #endif
}

// MARK: - Check Optional<Collection> is nil or empty.

public extension ReerGeneric where Base == Optional<T>, T: Collection {
    /// ReerKit: Check if optional is nil or empty collection.
    ///
    ///     let foo: String? = ""
    ///     print(foo.re.isEmpty) -> true
    var isEmpty: Bool {
        guard let collection = base else { return true }
        return collection.isEmpty
    }
}
