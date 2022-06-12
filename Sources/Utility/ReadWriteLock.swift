//
//  ReadWriteLock.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/13.
//

import Foundation
#if canImport(Darwin)
import Darwin

/// ReerKit: A wrapper of `pthread_rwlock_t`
public final class ReadWriteLock {
    private var rwlock = pthread_rwlock_t()
    
    public init() {
        pthread_rwlock_init(&rwlock, nil)
    }
    
    deinit {
        pthread_rwlock_destroy(&rwlock)
    }
    
    public func readLock() {
        pthread_rwlock_rdlock(&rwlock)
    }
    
    /// ReerKit: Returns true if the lock was succesfully locked and false if the lock was already locked.
    @discardableResult
    public func tryReadLock() -> Bool {
        pthread_rwlock_tryrdlock(&rwlock) == 0
    }
    
    public func writeLock() {
        pthread_rwlock_wrlock(&rwlock)
    }
    
    /// ReerKit: Returns true if the lock was succesfully locked and false if the lock was already locked.
    @discardableResult
    public func tryWriteLock() -> Bool {
        pthread_rwlock_trywrlock(&rwlock) == 0
    }
    
    public func unlock() {
        pthread_rwlock_unlock(&rwlock)
    }
}
#endif
