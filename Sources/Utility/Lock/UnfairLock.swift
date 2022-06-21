//
//  UnfairLock.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/13.
//

#if canImport(os)
import os.lock

/// ReerKit: A wrapper of `os_unfair_lock`
public final class UnfairLock {
    private let unfairLock: os_unfair_lock_t

    public init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }
    
    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }
    
    public func lock() {
        os_unfair_lock_lock(unfairLock)
    }
    
    /// ReerKit: Returns true if the lock was succesfully locked and false if the lock was already locked.
    @discardableResult
    public func tryLock() -> Bool {
        return os_unfair_lock_trylock(unfairLock)
    }
    
    public func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}

/// Global function that wrapped `lock()` and `unlock()`
public func locked<Result>(_ lock: UnfairLock, execute: () throws -> Result) rethrows -> Result {
    lock.lock()
    defer { lock.unlock() }
    return try execute()
}

#endif
