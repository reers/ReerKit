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

#if canImport(os)
import os.lock

/// A property wrapper that provides thread-safe access to values using `os_unfair_lock`
///
/// This wrapper protects a property from race conditions by using an unfair lock,
/// which is a low-level, high-performance synchronization primitive. **IMPORTANT:**
/// Only the getter and setter of `wrappedValue` are protected. For complex operations,
/// you must use the projected value's `read(_:)` and `write(_:)` methods.
///
/// **Performance Characteristics:**
/// - **Fast**: `os_unfair_lock` is optimized for performance
/// - **Unfair**: Does not guarantee FIFO order for waiting threads
/// - **Low overhead**: Minimal memory footprint and CPU usage
/// - **Priority inversion safe**: Supports priority inheritance
///
/// **Thread Safety Rules:**
/// - ✅ `property = value` (setter) - Thread-safe
/// - ✅ `let x = property` (getter) - Thread-safe
/// - ❌ `property.someMethod()` - NOT thread-safe
/// - ❌ `property[key] = value` - NOT thread-safe
/// - ❌ Multiple operations like `property += 1` then `otherProperty = property` - NOT atomic
/// - ✅ `$property.write { $0 += 1 }` - Thread-safe
/// - ✅ `$property.read { $0.someProperty }` - Thread-safe
///
/// **Use Cases:**
/// - Protecting individual values that need atomic reads/writes
/// - Building blocks for more complex thread-safe operations
/// - Counters and flags in concurrent environments
/// - State that needs protection but complex operations use explicit locking
///
/// **Common Pitfalls:**
/// ```swift
/// @Locked var cache: [String: Data] = [:]
///
/// // ❌ WRONG - Not thread-safe!
/// cache["key"] = data  // Gets cache, then modifies it - two separate operations
///
/// // ✅ CORRECT - Thread-safe
/// $cache.write { $0["key"] = data }
///
/// // ❌ WRONG - Race condition between operations!
/// if !cache.isEmpty {
///     let first = cache.first  // Another thread might modify cache between these lines
/// }
///
/// // ✅ CORRECT - Atomic operation
/// let firstItem = $cache.read { cache in
///     cache.isEmpty ? nil : cache.first
/// }
/// ```
///
/// Example usage:
/// ```swift
/// class ThreadSafeCounter {
///     @Locked
///     private var value: Int = 0
///
///     // ✅ Simple atomic operations
///     func getValue() -> Int {
///         return value  // Thread-safe getter
///     }
///
///     func setValue(_ newValue: Int) {
///         value = newValue  // Thread-safe setter
///     }
///
///     // ✅ Complex atomic operations
///     func incrementAndGet() -> Int {
///         return $value.write { value in
///             value += 1
///             return value
///         }
///     }
/// }
///
/// class ThreadSafeCache {
///     private struct CacheData {
///         var items: [String: Data] = [:]
///         var hitCount: Int = 0
///         var missCount: Int = 0
///     }
///
///     @Locked
///     private var cacheData = CacheData()
///
///     func get(_ key: String) -> Data? {
///         return $cacheData.write { data in
///             if let item = data.items[key] {
///                 data.hitCount += 1
///                 return item
///             } else {
///                 data.missCount += 1
///                 return nil
///             }
///         }
///     }
///
///     func set(_ key: String, _ value: Data) {
///         $cacheData.write { data in
///             data.items[key] = value
///         }
///     }
///
///     func getStats() -> (hits: Int, misses: Int, count: Int) {
///         return $cacheData.read { data in
///             (data.hitCount, data.missCount, data.items.count)
///         }
///     }
/// }
/// ```
@propertyWrapper
public final class Locked<T> {
    private var value: T
    private let lock: os_unfair_lock_t
    
    public init(wrappedValue: T) {
        value = wrappedValue
        lock = .allocate(capacity: 1)
        lock.initialize(to: os_unfair_lock())
    }
    
    deinit {
        lock.deinitialize(count: 1)
        lock.deallocate()
    }
    
    public var wrappedValue: T {
        get {
            return read { $0 }
        }
        set {
            write { $0 = newValue }
        }
    }
    
    public var projectedValue: Locked<T> { return self }
    
    public func read<U>(_ execute: (T) throws -> U) rethrows -> U {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        return try execute(value)
    }
    
    @discardableResult
    public func write<U>(_ execute: (inout T) throws -> U) rethrows -> U {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        return try execute(&value)
    }
}
#endif
