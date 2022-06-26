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

/// Global function that wrapped `readLock()` and `readUnlock()`
public func readLocked<Result>(_ lock: ReadWriteLock, execute: () throws -> Result) rethrows -> Result {
    lock.readLock()
    defer { lock.readUnlock() }
    return try execute()
}

/// Global function that wrapped `writeLock()` and `writeUnlock()`
public func writeLocked<Result>(_ lock: ReadWriteLock, execute: () throws -> Result) rethrows -> Result {
    lock.writeLock()
    defer { lock.writeUnlock() }
    return try execute()
}
#endif
