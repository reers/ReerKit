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

extension Optional: ReerGenericCompatible {
    public typealias T = Wrapped
}

// MARK: - Check state of an Optional instance.

public extension ReerGeneric where Base == Optional<T> {
    
    /// ReerKit: Contains a nil value.
    var isNil: Bool {
        return base == nil
    }
    
    /// ReerKit: Contains a valid value.
    var isNotNil: Bool {
        return base != nil
    }
    
    /// ReerKit: Contains a nil value.
    var isNone: Bool {
        return base == nil
    }
    
    /// ReerKit: Contains a valid value.
    var isSome: Bool {
        return base != nil
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
    func value(or defaultValue: @autoclosure () -> T) -> T {
        return base ?? defaultValue()
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
    func run<U>(_ action: (T) throws -> U?) rethrows -> U? {
        return try base.flatMap(action)
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
                switch string.lowercased() {
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
        return bool ?? false
    }
    
    /// ReerKit: Transform the optional wrapped value to `Bool` if possible.
    /// Return the passed default value if it is nil.
    func boolValue(or defaultValue: @autoclosure () -> Bool) -> Bool {
        return bool ?? defaultValue()
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
        return int ?? 0
    }
    
    /// ReerKit: Transform the optional wrapped value to `Int` if possible.
    /// Return the passed default value if it is nil.
    func intValue(or defaultValue: @autoclosure () -> Int) -> Int {
        return int ?? defaultValue()
    }
    
    /// ReerKit: Transform the optional wrapped value to `String` if possible.
    ///
    ///     let a: Any? = 23
    ///     a.re.string -> Optional("23")
    var string: String? {
        if let string = base as? String {
            return string
        } else if let stringConvertible = base as? CustomStringConvertible {
            if let int = Int(stringConvertible.description) {
                return int.description
            } else if let double = Double(stringConvertible.description) {
                return double.description
            } else if let bool = base as? Bool {
                return bool ? "true" : "false"
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
        return string ?? ""
    }
    
    /// ReerKit: Transform the optional wrapped value to `String` if possible.
    /// Return the passed default value if it is nil.
    func stringValue(or defaultValue: @autoclosure () -> String) -> String {
        return string ?? defaultValue()
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
        return double ?? 0
    }
    
    /// ReerKit: Transform the optional wrapped value to `Double` if possible.
    /// Return the passed default value if it is nil.
    func doubleValue(or defaultValue: @autoclosure () -> Double) -> Double {
        return double ?? defaultValue()
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
        return float ?? 0
    }
    
    /// ReerKit: Transform the optional wrapped value to `Float` if possible.
    /// Return the passed default value if it is nil.
    func floatValue(or defaultValue: @autoclosure () -> Float) -> Float {
        return float ?? defaultValue()
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
        return cgFloat ?? 0
    }
    
    /// ReerKit: Transform the optional wrapped value to `CGFloat` if possible.
    /// Return the passed default value if it is nil.
    func cgFloatValue(or defaultValue: @autoclosure () -> CGFloat) -> CGFloat {
        return cgFloat ?? defaultValue()
    }
    #endif

    /// ReerKit: Transform the optional wrapped value to `Dictionay<AnyHashable, Any>` if possible.
    ///
    ///     let a: Any? = ["s": 123]
    ///     a.re.anyDict -> Optional(["s": 123])
    var anyDict: [AnyHashable: Any]? {
        return base as? [AnyHashable: Any]
    }

    /// ReerKit: Transform the optional wrapped value to `Dictionay<AnyHashable, Any>` if possible.
    /// Return `[:]` if failed.
    var anyDictValue: [AnyHashable: Any] {
        return anyDict ?? [:]
    }

    /// ReerKit: Transform the optional wrapped value to `Dictionay<String, Any>` if possible.
    ///
    ///     let a: Any? = ["s": 123]
    ///     a.re.anyDict -> Optional(["s": 123])
    var stringAnyDict: [String: Any]? {
        return base as? [String: Any]
    }

    /// ReerKit: Transform the optional wrapped value to `Dictionay<String, Any>` if possible.
    /// Return `[:]` if failed.
    var stringAnyDictValue: [String: Any] {
        return stringAnyDict ?? [:]
    }
    
    /// ReerKit: Transform the optional wrapped value to `Dictionay<AnyHashable, Any>` if possible.
    /// Return the passed default value if it is nil.
    func dictValue<Key, Value>(or defaultValue: @autoclosure () -> [Key: Value]) -> [Key: Value] {
        return base as? [Key: Value] ?? defaultValue()
    }

    /// ReerKit: Transform the optional wrapped value to `Array<Any>` if possible.
    ///
    ///     let a: Any? = [123]
    ///     a.re.anyArray -> Optional([123])
    var anyArray: [Any]? {
        return base as? [Any]
    }

    /// ReerKit: Transform the optional wrapped value to `Array<Any>` if possible.
    /// Return `[]` if failed.
    var anyArrayValue: [Any] {
        return anyArray ?? []
    }

    /// ReerKit: Transform the optional wrapped value to `Array<Any>` if possible.
    /// Return the passed default value if it is nil.
    func arrayValue<E>(or defaultValue: @autoclosure () -> [E]) -> [E] {
        return base as? [E] ?? defaultValue()
    }
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

// MARK: - Operators

/// Make any type to an optional value.
postfix operator ~!
public postfix func ~! <T>(value: T) -> T? {
    return Optional(value)
}

/// Make `Bool?` to a oppsite value if it is not nil.
prefix operator !
public prefix func ! (value: Bool?) -> Bool? {
    guard let value = value else { return nil }
    if value {
        return false
    } else {
        return true
    }
}

infix operator ?! : NilCoalescingPrecedence
public extension Optional where Wrapped: Collection {

    /// ReerKit: Return the default value when the optional is nil, or it's not nil, but the collection is empty.
    ///
    ///     let value: String? = ""
    ///     let result = value ?! "abc"
    ///     // result is "abc"
    ///     
    /// - Returns: A non empty value.
    static func ?! (optionalValue: Optional<Wrapped>, defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        return optionalValue.re.isEmpty ? defaultValue() : optionalValue!
    }
}
