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

// MARK: - Numeric

public extension Numeric {
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

// MARK: - Sequence

public extension Sequence {
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

// MARK: - Equatable

public struct ReerForEquatable<Base> {
    public internal(set) var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public extension Equatable {
    /// Gets a namespace holder for ReerKit compatible types.
    var re: ReerForEquatable<Self> {
        get { return ReerForEquatable(self) }
        set {}
    }

    /// Gets a namespace holder for ReerKit compatible meta types.
    static var re: ReerForEquatable<Self>.Type {
        get { return ReerForEquatable.self }
        set {}
    }
}

// MARK: - MutableCollection

public struct ReerForMutableCollection<Base> {
    public let base: UnsafeMutablePointer<Base>
    public init(_ base: inout Base) {
        self.base = withUnsafeMutablePointer(to: &base) { $0 }
    }
}

public extension MutableCollection {
    /// Gets a namespace holder for ReerKit compatible types.
    var re: ReerForMutableCollection<Self> {
        mutating get { return ReerForMutableCollection(&self) }
        set {}
    }

    /// Gets a namespace holder for ReerKit compatible meta types.
    static var re: ReerForMutableCollection<Self>.Type {
        get { return ReerForMutableCollection<Self>.self }
        set {}
    }
}

// MARK: - StringProtocol

public struct ReerForStringProtocol<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public extension StringProtocol {
    /// Gets a namespace holder for ReerKit compatible types.
    var re: ReerForStringProtocol<Self> {
        get { return ReerForStringProtocol(self) }
        set {}
    }

    /// Gets a namespace holder for ReerKit compatible meta types.
    static var re: ReerForStringProtocol<Self>.Type {
        get { return ReerForStringProtocol.self }
        set {}
    }
}

// MARK: - RangeReplaceableCollection

public struct ReerForRangeReplaceableCollection<Base> {
    public let base: UnsafeMutablePointer<Base>
    public init(_ base: inout Base) {
        self.base = withUnsafeMutablePointer(to: &base) { $0 }
    }
}

public extension RangeReplaceableCollection {
    /// Gets a namespace holder for ReerKit compatible types.
    var re: ReerForRangeReplaceableCollection<Self> {
        mutating get { return ReerForRangeReplaceableCollection(&self) }
        set {}
    }

    /// Gets a namespace holder for ReerKit compatible meta types.
    static var re: ReerForRangeReplaceableCollection<Self>.Type {
        get { return ReerForRangeReplaceableCollection<Self>.self }
        set {}
    }
}

// MARK: - OptionSet

public struct ReerForOptionSet<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public extension OptionSet {
    /// Gets a namespace holder for ReerKit compatible types.
    var re: ReerForOptionSet<Self> {
        get { return ReerForOptionSet(self) }
        set {}
    }

    /// Gets a namespace holder for ReerKit compatible meta types.
    static var re: ReerForOptionSet<Self>.Type {
        get { return ReerForOptionSet.self }
        set {}
    }
}
