//
//  RWLocked.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/13.
//

import Foundation
#if canImport(Darwin)
import Darwin

/// ReerKit: A read write lock wrapper grants multiple readers and single-writer guarantees on a value.
/// It is backed by a `pthread_rwlock_t`.
@propertyWrapper
public final class RWLocked<T> {
    private var value: T
    private var rwlock = pthread_rwlock_t()
    
    public init(wrappedValue: T) {
        value = wrappedValue
        pthread_rwlock_init(&rwlock, nil)
    }
    
    deinit {
        pthread_rwlock_destroy(&rwlock)
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
        pthread_rwlock_rdlock(&rwlock)
        defer { pthread_rwlock_unlock(&rwlock) }
        return try execute(value)
    }
    
    @discardableResult
    public func write<U>(_ execute: (inout T) throws -> U) rethrows -> U {
        pthread_rwlock_wrlock(&rwlock)
        defer { pthread_rwlock_unlock(&rwlock) }
        return try execute(&value)
    }
}

#endif
