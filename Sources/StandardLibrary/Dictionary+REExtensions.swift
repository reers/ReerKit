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

// MARK: - Access dictionary value by using dynamic member lookup.
//
//     let dict = ["aKey": "aValue"]
//     dict.dml.aKey -> Optional("aValue")
//
// Where the key should conform `ExpressibleByStringLiteral`

public protocol DMLDictionary: Collection {
    associatedtype Key: Hashable & ExpressibleByStringLiteral
    associatedtype Value
    func value(forKey key: Key) -> Value?
}

extension Dictionary: DMLDictionary where Key: ExpressibleByStringLiteral {
    public typealias Key = Key
    public typealias Value = Value
    public func value(forKey key: Key) -> Value? {
        return self[key]
    }
}

@dynamicMemberLookup
public struct DML<Base> where Base: DMLDictionary {
    private let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    public subscript(dynamicMember member: Base.Key) -> Base.Value? {
        return base.value(forKey: member)
    }
}

public extension Dictionary where Key: ExpressibleByStringLiteral {
    var dml: DML<Self> {
        get { return DML<Self>(self) }
        set {}
    }
}
