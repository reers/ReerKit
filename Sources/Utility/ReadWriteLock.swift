//
//  ReadWriteLock.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/13.
//

#if canImport(Darwin)
import Darwin

/// ReerKit: Represents a reader-writer lock. Note that this implementation is not recursive.
public final class ReadWriteLock {
    
    private var readMutex = pthread_mutex_t()
    private var writeMutex = pthread_mutex_t()
    private var readCount: UInt = 0
    
    public init() {
        pthread_mutex_init(&readMutex, nil)
        pthread_mutex_init(&writeMutex, nil)
    }
    
    deinit {
        pthread_mutex_destroy(&readMutex)
        pthread_mutex_destroy(&writeMutex)
    }
    
    public func readLock() {
        pthread_mutex_lock(&readMutex)
        defer { pthread_mutex_unlock(&readMutex) }
        if readCount == 0 {
            pthread_mutex_lock(&writeMutex)
        }
        readCount += 1
    }
    
    /// ReerKit: Returns true if the lock was succesfully locked and false if the lock was already locked.
    @discardableResult
    public func tryReadLock() -> Bool {
        pthread_mutex_lock(&readMutex)
        defer { pthread_mutex_unlock(&readMutex) }
        let success = (readCount == 0)
            ? pthread_mutex_trylock(&writeMutex) == 0
            : true
        if success {
            readCount += 1
        }
        return success
    }
    
    public func readUnlock() {
        pthread_mutex_lock(&readMutex)
        defer { pthread_mutex_unlock(&readMutex) }
        if readCount > 0 {
            readCount -= 1
            if readCount == 0 {
                pthread_mutex_unlock(&writeMutex)
            }
        }
    }
    
    public func writeLock() {
        pthread_mutex_lock(&writeMutex)
    }
    
    /// ReerKit: Returns true if the lock was succesfully locked and false if the lock was already locked.
    @discardableResult
    public func tryWriteLock() -> Bool {
        return pthread_mutex_trylock(&writeMutex) == 0
    }
    
    public func writeUnlock() {
        pthread_mutex_unlock(&writeMutex)
    }
}
#endif
