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

// MARK: - Access dictionary value by using dynamic member lookup.
//
//     let dict = ["aKey": "aValue", "123": "number"]
//     dict.dml.aKey -> Optional("aValue")
//     dict.dml.123 -> Optional("number")
//
//     ** NOT Support the keys that contain `./$#%()....` **
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

// MARK: - Nonmutating

extension Dictionary: ReerGeneric2Compatible {
    public typealias T1 = Key
    public typealias T2 = Value
}

public extension ReerGeneric2 where Base == Dictionary<T1, T2> {

    /// ReerKit: Query string from dictionary.
    var queryString: String {
        return base.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    /// ReerKit: Returns [String: String] for self.
    /// Returns nil if an error occurs.
    var stringDictionary: [String: String]? {
        if let stringDict = base as? [String: String] {
            return stringDict
        }

        var result: [String: String] = [:]
        for (key, value) in base {
            guard let stringKey = key~!.re.string, let stringValue = value~!.re.string else { return nil }
            result[stringKey] = stringValue
        }
        return result
    }

    /// ReerKit: Check if key exists in dictionary.
    ///
    ///        let dict: [String: Any] = ["testKey": "testValue", "testArrayKey": [1, 2, 3, 4, 5]]
    ///        dict.re.has(key: "testKey") -> true
    ///        dict.re.has(key: "anotherKey") -> false
    ///
    /// - Parameter key: key to search for.
    /// - Returns: true if key exists in dictionary.
    func has(key: T1) -> Bool {
        return base.index(forKey: key) != nil
    }

    #if canImport(Foundation)
    /// ReerKit: JSON Data from dictionary.
    ///
    /// - Parameter prettify: set true to prettify data (default is false).
    /// - Returns: optional JSON Data (if applicable).
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        let options = (prettify == true)
            ? JSONSerialization.WritingOptions.prettyPrinted
            : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: base, options: options)
    }
    #endif

    #if canImport(Foundation)
    /// ReerKit: JSON String from dictionary.
    ///
    ///        dict.re.jsonString() -> "{"testKey":"testValue","testArrayKey":[1,2,3,4,5]}"
    ///
    ///        dict.re.jsonString(prettify: true)
    ///        /*
    ///        returns the following string:
    ///
    ///        "{
    ///        "testKey" : "testValue",
    ///        "testArrayKey" : [
    ///            1,
    ///            2,
    ///            3,
    ///            4,
    ///            5
    ///        ]
    ///        }"
    ///
    ///        */
    ///
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(base) else { return nil }
        let options = (prettify == true)
            ? JSONSerialization.WritingOptions.prettyPrinted
            : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: base, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    #endif

    /// ReerKit: Returns a dictionary containing the results of mapping the given closure over the sequence’s elements.
    /// - Parameter transform: A mapping closure. `transform` accepts an element of this sequence as its parameter and returns a transformed value of the same or   of a different type.
    /// - Returns: A dictionary containing the transformed elements of this sequence.
    func mapKeysAndValues<K, V>(_ transform: ((key: T1, value: T2)) throws -> (K, V)) rethrows -> [K: V] {
        return [K: V](uniqueKeysWithValues: try base.map(transform))
    }

    /// ReerKit: Returns a dictionary containing the non-`nil` results of calling the given transformation with each element of this sequence.
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: A dictionary of the non-`nil` results of calling `transform` with each element of the sequence.
    /// - Complexity: *O(m + n)*, where _m_ is the length of this sequence and _n_ is the length of the result.
    func compactMapKeysAndValues<K, V>(_ transform: ((key: T1, value: T2)) throws -> (K, V)?) rethrows -> [K: V] {
        return [K: V](uniqueKeysWithValues: try base.compactMap(transform))
    }

    /// ReerKit: Creates a new dictionary using specified keys.
    ///
    ///        var dict =  ["key1": 1, "key2": 2, "key3": 3, "key4": 4]
    ///        dict.re.pick(keys: ["key1", "key3", "key4"]) -> ["key1": 1, "key3": 3, "key4": 4]
    ///        dict.re.pick(keys: ["key2"]) -> ["key2": 2]
    ///
    /// - Complexity: O(K), where _K_ is the length of the keys array.
    ///
    /// - Parameter keys: An array of keys that will be the entries in the resulting dictionary.
    ///
    /// - Returns: A new dictionary that contains the specified keys only. If none of the keys exist, an empty dictionary will be returned.
    func pick(keys: [T1]) -> [T1: T2] {
        return keys.reduce(into: [T1: T2]()) { result, item in
            result[item] = base[item]
        }
    }
}

public extension ReerGeneric2 where Base == Dictionary<T1, T2>, T2: Equatable {
    /// ReerKit: Returns an array of all keys that have the given value in dictionary.
    ///
    ///        let dict = ["key1": "value1", "key2": "value1", "key3": "value2"]
    ///        dict.re.keys(forValue: "value1") -> ["key1", "key2"]
    ///        dict.re.keys(forValue: "value2") -> ["key3"]
    ///        dict.re.keys(forValue: "value3") -> []
    ///
    /// - Parameter value: Value for which keys are to be fetched.
    /// - Returns: An array containing keys that have the given value.
    func keys(forValue value: T2) -> [T1] {
        return base.keys.filter { base[$0] == value }
    }
}

// MARK: - Mutating

extension Dictionary: ReerReferenceGeneric2Compatible {
    public typealias U1 = Key
    public typealias U2 = Value
}

public extension ReerReferenceGeneric2 where Base == Dictionary<U1, U2> {
    /// ReerKit: Remove all keys contained in the keys parameter from the dictionary.
    ///
    ///        var dict : [String: String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        dict.re.removeAll(keys: ["key1", "key2"])
    ///        dict.re.keys.contains("key3") -> true
    ///        dict.re.keys.contains("key1") -> false
    ///        dict.re.keys.contains("key2") -> false
    ///
    /// - Parameter keys: keys to be removed.
    mutating func removeAll<S: Sequence>(keys: S) where S.Element == U1 {
        keys.forEach { base.pointee.removeValue(forKey: $0) }
    }

    /// ReerKit: Remove a value for a random key from the dictionary.
    @discardableResult
    mutating func removeValueForRandomKey() -> U2? {
        guard let randomKey = base.pointee.keys.randomElement() else { return nil }
        return base.pointee.removeValue(forKey: randomKey)
    }
}

public extension ReerReferenceGeneric2 where Base == Dictionary<U1, U2>, U1: StringProtocol {
    /// ReerKit: Lowercase all keys in dictionary.
    ///
    ///        var dict = ["tEstKeY": "value"]
    ///        dict.re.lowercaseAllKeys()
    ///        print(dict) // prints "["testkey": "value"]"
    ///
    mutating func lowercaseAllKeys() {
        for key in base.pointee.keys {
            if let lowercaseKey = String(describing: key).lowercased() as? U1 {
                base.pointee[lowercaseKey] = base.pointee.removeValue(forKey: key)
            }
        }
    }
}

// MARK: - Subscripts

public extension ReerReferenceGeneric2 where Base == Dictionary<U1, U2> {
    /// ReerKit: Deep fetch or set a value from nested dictionaries.
    ///
    ///        var dict =  ["key": ["key1": ["key2": "value"]]]
    ///        dict.re[path: ["key", "key1", "key2"]] = "newValue"
    ///        dict.re[path: ["key", "key1", "key2"]] -> "newValue"
    ///
    /// - Note: Value fetching is iterative, while setting is recursive.
    ///
    /// - Complexity: O(N), _N_ being the length of the path passed in.
    ///
    /// - Parameter path: An array of keys to the desired value.
    ///
    /// - Returns: The value for the key-path passed in. `nil` if no value is found.
    subscript(path path: [U1]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            var result: Any? = base.pointee
            for key in path {
                if let element = (result as? [U1: Any])?[key] {
                    result = element
                } else {
                    return nil
                }
            }
            return result
        }
        set {
            if let first = path.first {
                if path.count == 1, let new = newValue as? U2 {
                    return base.pointee[first] = new
                }
                if var nested = base.pointee[first] as? [U1: Any] {
                    nested.re[path: Array(path.dropFirst())] = newValue
                    return base.pointee[first] = nested as? U2
                }
            }
        }
    }
}

public extension ReerReferenceGeneric2 where Base == Dictionary<U1, U2>, U1 == String {
    /// ReerKit: Deep fetch or set a value from nested dictionaries.
    ///
    ///        var dict =  ["key": ["key1": ["key2": "value"]]]
    ///        dict.re[path: "key.key1.key2"] = "newValue"
    ///        dict.re[path: "key.key1.key2"] -> "newValue"
    ///
    /// - Note: Value fetching is iterative, while setting is recursive.
    ///
    /// - Complexity: O(N), _N_ being the length of the path passed in.
    ///
    /// - Parameter path: An array of keys to the desired value.
    ///
    /// - Returns: The value for the key-path passed in. `nil` if no value is found.
    subscript(path path: U1) -> Any? {
        get {
            let keys = path.components(separatedBy: ".")
            return base.pointee.re[path: keys]
        }
        set {
            let keys = path.components(separatedBy: ".")
            base.pointee.re[path: keys] = newValue
        }
    }
}

// MARK: - Operators

public extension Dictionary {
    /// ReerKit: Merge the keys/values of two dictionaries.
    ///
    ///        let dict: [String: String] = ["key1": "value1"]
    ///        let dict2: [String: String] = ["key2": "value2"]
    ///        let result = dict + dict2
    ///        result["key1"] -> "value1"
    ///        result["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary.
    ///   - rhs: dictionary.
    /// - Returns: An dictionary with keys and values from both.
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }

    // MARK: - Operators

    /// ReerKit: Append the keys and values from the second dictionary into the first one.
    ///
    ///        var dict: [String: String] = ["key1": "value1"]
    ///        let dict2: [String: String] = ["key2": "value2"]
    ///        dict += dict2
    ///        dict["key1"] -> "value1"
    ///        dict["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary.
    ///   - rhs: dictionary.
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }

    /// ReerKit: Remove keys contained in the sequence from the dictionary.
    ///
    ///        let dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
    ///        let result = dict - ["key1", "key2"]
    ///        result.keys.contains("key3") -> true
    ///        result.keys.contains("key1") -> false
    ///        result.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary.
    ///   - keys: array with the keys to be removed.
    /// - Returns: a new dictionary with keys removed.
    static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        result.re.removeAll(keys: keys)
        return result
    }

    /// ReerKit: Remove keys contained in the sequence from the dictionary.
    ///
    ///        var dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
    ///        dict -= ["key1", "key2"]
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary.
    ///   - keys: array with the keys to be removed.
    static func -= <S: Sequence>(lhs: inout [Key: Value], keys: S) where S.Element == Key {
        lhs.re.removeAll(keys: keys)
    }
}

// MARK: - Initializer

public extension Dictionary {
    /// ReerKit: Creates a Dictionary from a given sequence grouped by a given key path.
    ///
    /// - Parameters:
    ///   - sequence: Sequence being grouped.
    ///   - keyPath: The key path to group by.
    static func re<S: Sequence>(_ sequence: S, groupBy keyPath: KeyPath<S.Element, Key>) -> [Key: Value] where Value == [S.Element] {
        return Self(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
}
