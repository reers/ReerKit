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

#if canImport(Foundation)
import Foundation

public struct ReerForContiguousBytes<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public extension ContiguousBytes {
    /// Gets a namespace holder for ReerKit compatible types.
    var re: ReerForContiguousBytes<Self> {
        get { return ReerForContiguousBytes(self) }
        set {}
    }

    /// Gets a namespace holder for ReerKit compatible meta types.
    static var re: ReerForContiguousBytes<Self>.Type {
        get { return ReerForContiguousBytes.self }
        set {}
    }
}

public extension ReerForContiguousBytes where Base: ContiguousBytes {
    /// ReerKit: Transform `ContiguousBytes` to `Data`
    var data: Data {
        return base.withUnsafeBytes { Data($0) }
    }
}

#endif
