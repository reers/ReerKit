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
