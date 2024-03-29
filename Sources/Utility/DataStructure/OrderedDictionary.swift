//
//  Copyright © 2020 groue.
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

/// ReerKit: A dictionary with guaranteed keys ordering.
///
///     var dict = OrderedDictionary<String, Int>()
///     dict.append(1, forKey: "foo")
///     dict.append(2, forKey: "bar")
///
///     dict["foo"] // 1
///     dict["bar"] // 2
///     dict["qux"] // nil
///     dict.map { $0.key } // ["foo", "bar"], in this order.
public struct OrderedDictionary<Key: Hashable, Value> {
    public private(set) var keys: [Key]
    public private(set) var dictionary: [Key: Value]
    
    public var values: [Value] { keys.map { dictionary[$0]! } }
    
    private init(keys: [Key], dictionary: [Key: Value]) {
        assert(Set(keys) == Set(dictionary.keys))
        self.keys = keys
        self.dictionary = dictionary
    }
    
    /// Creates an empty ordered dictionary.
    public init() {
        keys = []
        dictionary = [:]
    }
    
    /// Creates an empty ordered dictionary.
    public init(minimumCapacity: Int) {
        keys = []
        keys.reserveCapacity(minimumCapacity)
        dictionary = Dictionary(minimumCapacity: minimumCapacity)
    }
    
    /// Returns the value associated with key, or nil.
    public subscript(_ key: Key) -> Value? {
        get { dictionary[key] }
        set {
            if let value = newValue {
                updateValue(value, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
    /// Returns the value associated with key, or the default value.
    public subscript(_ key: Key, default defaultValue: Value) -> Value {
        get { dictionary[key] ?? defaultValue }
        set { self[key] = newValue }
    }
    
    /// Appends the given value for the given key.
    ///
    /// - precondition: There is no value associated with key yet.
    public mutating func appendValue(_ value: Value, forKey key: Key) {
        guard updateValue(value, forKey: key) == nil else {
            fatalError("key is already defined")
        }
    }
    
    /// Updates the value stored in the dictionary for the given key, or
    /// appends a new key-value pair if the key does not exist.
    ///
    /// Use this method instead of key-based subscripting when you need to know
    /// whether the new value supplants the value of an existing key. If the
    /// value of an existing key is updated, updateValue(_:forKey:) returns the
    /// original value. If the given key is not present in the dictionary, this
    /// method appends the key-value pair and returns nil.
    @discardableResult
    public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        if let oldValue = dictionary.updateValue(value, forKey: key) {
            return oldValue
        }
        keys.append(key)
        return nil
    }
    
    /// Removes the value associated with key.
    @discardableResult
    public mutating func removeValue(forKey key: Key) -> Value? {
        guard let value = dictionary.removeValue(forKey: key) else {
            return nil
        }
        let index = keys.firstIndex { $0 == key }!
        keys.remove(at: index)
        return value
    }
    
    /// Returns a new ordered dictionary containing the keys of this dictionary
    /// with the values transformed by the given closure.
    public func mapValues<T>(_ transform: (Value) throws -> T) rethrows -> OrderedDictionary<Key, T> {
        try reduce(into: .init()) { dict, pair in
            let value = try transform(pair.value)
            dict.appendValue(value, forKey: pair.key)
        }
    }
    
    /// Returns a new ordered dictionary containing only the key-value pairs
    /// that have non-nil values as the result of transformation by the
    /// given closure.
    public func compactMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> OrderedDictionary<Key, T> {
        try reduce(into: .init()) { dict, pair in
            if let value = try transform(pair.value) {
                dict.appendValue(value, forKey: pair.key)
            }
        }
    }
    
    public func filter(_ isIncluded: ((key: Key, value: Value)) throws -> Bool) rethrows -> OrderedDictionary<Key, Value> {
        let dictionary = try self.dictionary.filter(isIncluded)
        let keys = self.keys.filter(dictionary.keys.contains)
        return OrderedDictionary(keys: keys, dictionary: dictionary)
    }
    
    public mutating func merge<S>(
        _ other: S,
        uniquingKeysWith combine: (Value, Value) throws -> Value
    ) rethrows where S: Sequence, S.Element == (Key, Value) {
        for (key, value) in other {
            if let current = self[key] {
                self[key] = try combine(current, value)
            } else {
                self[key] = value
            }
        }
    }
    
    public mutating func merge<S>(
        _ other: S,
        uniquingKeysWith combine: (Value, Value) throws -> Value
    ) rethrows where S: Sequence, S.Element == (key: Key, value: Value) {
        for (key, value) in other {
            if let current = self[key] {
                self[key] = try combine(current, value)
            } else {
                self[key] = value
            }
        }
    }
    
    public func merging<S>(
        _ other: S,
        uniquingKeysWith combine: (Value, Value) throws -> Value
    ) rethrows -> OrderedDictionary<Key, Value>
    where S: Sequence, S.Element == (Key, Value) {
        var result = self
        try result.merge(other, uniquingKeysWith: combine)
        return result
    }
    
    public func merging<S>(
        _ other: S,
        uniquingKeysWith combine: (Value, Value) throws -> Value
    ) rethrows -> OrderedDictionary<Key, Value>
    where S: Sequence, S.Element == (key: Key, value: Value) {
        var result = self
        try result.merge(other, uniquingKeysWith: combine)
        return result
    }
}

extension OrderedDictionary: Collection {
    public typealias Index = Int
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { keys.count }
    
    public func index(after i: Int) -> Int { i + 1 }
    
    public subscript(position: Int) -> (key: Key, value: Value) {
        let key = keys[position]
        return (key: key, value: dictionary[key]!)
    }
}

extension OrderedDictionary: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.keys = elements.map { $0.0 }
        self.dictionary = Dictionary(uniqueKeysWithValues: elements)
    }
}

extension OrderedDictionary: Equatable where Value: Equatable {
    public static func == (lhs: OrderedDictionary, rhs: OrderedDictionary) -> Bool {
        (lhs.keys == rhs.keys) && (lhs.dictionary == rhs.dictionary)
    }
}

extension OrderedDictionary: CustomStringConvertible {
    public var description: String {
        let chunks = map { (key, value) in
            "\(String(reflecting: key)): \(String(reflecting: value))"
        }
        if chunks.isEmpty {
            return "[:]"
        } else {
            return "[\(chunks.joined(separator: ", "))]"
        }
    }
}

extension Dictionary {
    public init(_ orderedDictionary: OrderedDictionary<Key, Value>) {
        self = orderedDictionary.dictionary
    }
}
