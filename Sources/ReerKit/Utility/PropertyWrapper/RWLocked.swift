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

#if canImport(Darwin)
import Darwin

/// A property wrapper that provides thread-safe access using read-write locks
///
/// This wrapper protects a property using a read-write lock, which allows multiple
/// concurrent readers OR a single exclusive writer. This provides better performance
/// than exclusive locks when read operations significantly outnumber write operations.
/// **IMPORTANT:** Only the getter and setter of `wrappedValue` are protected.
/// For complex operations, you must use the projected value's `read(_:)` and `write(_:)` methods.
///
/// **Read-Write Lock Characteristics:**
/// - **Multiple readers**: Many threads can read simultaneously
/// - **Exclusive writer**: Only one thread can write at a time
/// - **Reader-writer exclusion**: No reads during writes, no writes during reads
/// - **Better for read-heavy workloads**: Reduces contention when reads >> writes
/// - **Higher overhead**: More complex than simple locks, use when appropriate
///
/// **Performance Considerations:**
/// - ✅ **Best for**: Read-heavy scenarios (90%+ reads)
/// - ❌ **Not optimal for**: Write-heavy or balanced read/write scenarios
/// - ❌ **Avoid for**: Simple counters or frequently modified state
/// - ✅ **Good for**: Caches, configuration, lookup tables, shared data structures
///
/// **Thread Safety Rules:**
/// - ✅ `property = value` (setter) - Thread-safe, exclusive write
/// - ✅ `let x = property` (getter) - Thread-safe, shared read
/// - ❌ `property.someMethod()` - NOT thread-safe
/// - ❌ `property[key] = value` - NOT thread-safe
/// - ❌ Multiple operations - NOT atomic together
/// - ✅ `$property.write { $0 += 1 }` - Thread-safe, exclusive write
/// - ✅ `$property.read { $0.someProperty }` - Thread-safe, shared read
///
/// **Common Pitfalls:**
/// ```swift
/// @RWLocked var cache: [String: Data] = [:]
///
/// // ❌ WRONG - Not thread-safe!
/// cache["key"] = data  // Gets cache, then modifies it - two separate operations
///
/// // ✅ CORRECT - Thread-safe exclusive write
/// $cache.write { $0["key"] = data }
///
/// // ❌ WRONG - Race condition!
/// if !cache.isEmpty {
///     let first = cache.first  // Another thread might modify between operations
/// }
///
/// // ✅ CORRECT - Atomic read operation
/// let firstItem = $cache.read { cache in
///     cache.isEmpty ? nil : cache.first
/// }
/// ```
///
/// **When to use RWLocked vs Locked:**
/// ```swift
/// // ✅ Use RWLocked for read-heavy scenarios
/// @RWLocked var userCache: [ID: User] = [:]        // 95% reads, 5% writes
/// @RWLocked var config: AppConfig = AppConfig()    // Read frequently, write rarely
/// @RWLocked var lookup: [String: Int] = [:]        // Dictionary lookups
///
/// // ✅ Use Locked for write-heavy or simple scenarios
/// @Locked var counter: Int = 0                     // Frequent increments
/// @Locked var isProcessing: Bool = false           // Frequent state changes
/// @Locked var queue: [Task] = []                   // Frequent add/remove
/// ```
///
/// Example usage:
/// ```swift
/// class UserCache {
///     private struct CacheData {
///         var users: [UserID: User] = [:]
///         var lastUpdate: Date = Date()
///         var hitCount: Int = 0
///         var missCount: Int = 0
///     }
///
///     @RWLocked
///     private var data = CacheData()
///
///     // Frequent read operations - multiple threads can execute concurrently
///     func getUser(_ id: UserID) -> User? {
///         return $data.read { data in
///             if let user = data.users[id] {
///                 // Note: Can't increment hitCount here - would need write lock
///                 return user
///             }
///             return nil
///         }
///     }
///
///     func getAllUsers() -> [User] {
///         return $data.read { Array($0.users.values) }
///     }
///
///     func getCacheInfo() -> (userCount: Int, lastUpdate: Date) {
///         return $data.read { ($0.users.count, $0.lastUpdate) }
///     }
///
///     // Infrequent write operations - exclusive access
///     func setUser(_ user: User) {
///         $data.write { data in
///             data.users[user.id] = user
///             data.lastUpdate = Date()
///         }
///     }
///
///     func removeUser(_ id: UserID) {
///         $data.write { data in
///             data.users.removeValue(forKey: id)
///             data.lastUpdate = Date()
///         }
///     }
///
///     func recordHit() {
///         $data.write { $0.hitCount += 1 }
///     }
/// }
/// ```
@propertyWrapper
public final class RWLocked<T> {
    private var value: T
    private var rwlock = ReadWriteLock()
    
    public init(wrappedValue: T) {
        value = wrappedValue
    }
    
    public var wrappedValue: T {
        get {
            return read { $0 }
        }
        set {
            write { $0 = newValue }
        }
    }
    
    public var projectedValue: RWLocked<T> { return self }
    
    public func read<U>(_ execute: (T) throws -> U) rethrows -> U {
        rwlock.readLock()
        defer { rwlock.readUnlock() }
        return try execute(value)
    }
    
    @discardableResult
    public func write<U>(_ execute: (inout T) throws -> U) rethrows -> U {
        rwlock.writeLock()
        defer { rwlock.writeUnlock() }
        return try execute(&value)
    }
}

#endif
