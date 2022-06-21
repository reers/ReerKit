//
//  RWLocked.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/13.
//

#if canImport(Darwin)
import Darwin

/// ReerKit: A read write lock wrapper grants multiple readers and single-writer guarantees on a value.
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
