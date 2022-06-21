//
//  Locked.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/12.
//

#if canImport(os)
import os.lock

/// ReerKit: A lock protects the property with an `os_unfair_lock`
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
        defer { os_unfair_lock_unlock(lock)}
        return try execute(value)
    }
    
    @discardableResult
    public func write<U>(_ execute: (inout T) throws -> U) rethrows -> U {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock)}
        return try execute(&value)
    }
}
#endif
