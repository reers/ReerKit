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

public protocol WeakOption {}

/// Use phantom types to express weak option.
public enum WeakKey: WeakOption {}
public enum WeakValue: WeakOption {}
public enum WeakKeyValue: WeakOption {}

/// A map class that weak refering every AnyObject element.
/// If the object element's key or value released, its weak wrapper `Weak<T>` will remove from the internal map automatically.
///
///     var aa: NSObject? = NSObject()
///     let bb: NSObject? = NSObject()
///     let map: WeakMap<WeakValue, String, NSObject> = .init(["aa": aa!, "bb": bb!])
///
public class WeakMap<Option: WeakOption, Key: Hashable, Value> {
    private var objectMap: [AnyHashable: Any] = [:]

    private init() {}

    public var count: Int {
        return objectMap.count
    }

    public var keys: [Key] {
        var result: [Key] = []
        for (key, _) in objectMap {
            result.append(key as! Key)
        }
        return result
    }

    public var values: [Value] {
        var result: [Value] = []
        for (_, value) in objectMap {
            result.append(value as! Value)
        }
        return result
    }
}


// MARK: - WeakKey

extension WeakMap where Option == WeakKey, Key: AnyObject & Hashable {
    public convenience init(_ weakKeyMap: [Key: Value] = [:]) {
        self.init()
        weakKeyMap.forEach { self[$0] = $1 }
    }

    public subscript(_ key: Key) -> Value? {
        get {
            return objectMap[Weak(key)] as? Value
        }
        set {
            let weakKey = Weak(key)
            objectMap[weakKey] = newValue
            observeDeinit(for: key) { [weak self] in
                guard let self = self else { return }
                self.objectMap.removeValue(forKey: weakKey)
            }
        }
    }

    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        let value = self[key]
        self[key] = nil
        return value
    }

    @discardableResult
    public func updateValue(_ value: Value, forKey key: Key) -> Value? {
        let value = self[key]
        self[key] = value
        return value
    }

    public func forEach(_ body: ((key: Key, value: Value)) throws -> Void) rethrows {
        for element in objectMap {
            guard let weakKey = element.key as? Weak<Key>,
                  let realKey = weakKey.object,
                  let value = element.value as? Value
            else { continue }
            try body((realKey, value))
        }
    }
}


// MARK: - WeakValue

extension WeakMap where Option == WeakValue, Key: Hashable, Value: AnyObject {
    public convenience init(_ weakValueMap: [Key: Value] = [:]) {
        self.init()
        weakValueMap.forEach { self[$0] = $1 }
    }

    public subscript(_ key: Key) -> Value? {
        get {
            guard let weakValue = objectMap[key] as? Weak<Value> else { return nil }
            return weakValue.object
        }
        set {
            guard let value = newValue else { return }
            let weakValue = Weak(value)
            objectMap[key] = weakValue
            observeDeinit(for: value) { [weak self] in
                guard let self = self else { return }
                self.objectMap.removeValue(forKey: key)
            }
        }
    }

    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        let value = self[key]
        self[key] = nil
        return value
    }

    @discardableResult
    public func updateValue(_ value: Value, forKey key: Key) -> Value? {
        let value = self[key]
        self[key] = value
        return value
    }

    public func forEach(_ body: ((key: Key, value: Value)) throws -> Void) rethrows {
        for element in objectMap {
            guard let key = element.key as? Key,
                  let weakValue = element.value as? Weak<Value>,
                  let realValue = weakValue.object
            else { continue }
            try body((key, realValue))
        }
    }
}


// MARK: - WeakKeyValue

extension WeakMap where Option == WeakKeyValue, Key: AnyObject & Hashable, Value: AnyObject {
    public convenience init(_ weakKeyValueMap: [Key: Value] = [:]) {
        self.init()
        weakKeyValueMap.forEach { self[$0] = $1 }
    }

    public subscript(_ key: Key) -> Value? {
        get {
            guard let weakValue = objectMap[Weak(key)] as? Weak<Value> else { return nil }
            return weakValue.object
        }
        set {
            guard let value = newValue else { return }
            let weakKey = Weak(key)
            let weakValue = Weak(value)
            objectMap[weakKey] = weakValue

            observeDeinit(for: key) { [weak self] in
                guard let self = self else { return }
                self.objectMap.removeValue(forKey: weakKey)
            }

            observeDeinit(for: value) { [weak self] in
                guard let self = self else { return }
                self.objectMap.removeValue(forKey: weakKey)
            }
        }
    }

    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        let value = self[key]
        self[key] = nil
        return value
    }

    @discardableResult
    public func updateValue(_ value: Value, forKey key: Key) -> Value? {
        let value = self[key]
        self[key] = value
        return value
    }

    public func forEach(_ body: ((key: Key, value: Value)) throws -> Void) rethrows {
        for element in objectMap {
            guard let weakKey = element.key as? Weak<Key>,
                  let realKey = weakKey.object,
                  let weakValue = element.value as? Weak<Value>,
                  let realValue = weakValue.object
            else { continue }
            try body((realKey, realValue))
        }
    }
}
