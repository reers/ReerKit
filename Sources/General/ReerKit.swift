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

/// Wrapper for ReerKit compatible types. This type provides an extension point for
/// connivence methods in ReerKit.
public struct Reer<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// Represents an object type that is compatible with ReerKit. You can use `re` property to get a
/// value in the namespace of ReerKit.
public protocol ReerCompatible: AnyObject {}

/// Represents a value type that is compatible with ReerKit. You can use `re` property to get a
/// value in the namespace of ReerKit.
public protocol ReerCompatibleValue {}

extension ReerCompatible {
    /// Gets a namespace holder for ReerKit compatible types.
    public var re: Reer<Self> {
        get { return Reer(self) }
        set {}
    }
    
    /// Gets a namespace holder for ReerKit compatible meta types.
    public static var re: Reer<Self>.Type {
        get { return Reer.self }
        set {}
    }
}

extension ReerCompatibleValue {
    /// Gets a namespace holder for ReerKit compatible types.
    public var re: Reer<Self> {
        get { return Reer(self) }
        set {}
    }
    
    /// Gets a namespace holder for ReerKit compatible meta types.
    public static var re: Reer<Self>.Type {
        get { return Reer.self }
        set {}
    }
}

/// Wrapper for ReerKit compatible types with a generic parameter. This type provides an extension point for
/// connivence methods in ReerKit.
public struct ReerGeneric<Base, T> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// Represents a type with a generic parameter that is compatible with ReerKit. You can use `re` property to get a
/// value in the namespace of ReerKit.
public protocol ReerGenericCompatible {
    associatedtype T
}

public extension ReerGenericCompatible {
    /// Gets a namespace holder for ReerKit compatible types.
    var re: ReerGeneric<Self, T> {
        get { return ReerGeneric(self) }
        set {}
    }
    
    /// Gets a namespace holder for ReerKit compatible meta types.
    static var re: ReerGeneric<Self, T>.Type {
        get { return ReerGeneric<Self, T>.self }
        set {}
    }
}
