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

#if os(Linux)
import Glibc
#else
import Darwin
#endif

/// ReerKit: A wrapper class for pthread mutex, providing a simple interface for thread synchronization.
public final class MutexLock {
    private var mutex = pthread_mutex_t()
    
    public init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
    }
    
    /// Acquires the lock, blocking the current thread until the lock can be obtained.
    public func lock() {
        pthread_mutex_lock(&mutex)
    }
    
    /// ReerKit: Attempts to acquire the lock without blocking.
    /// Returns true if the lock was successfully locked and false if the lock was already locked.
    @discardableResult
    public func tryLock() -> Bool {
        return pthread_mutex_trylock(&mutex) == 0
    }
    
    /// Releases the lock.
    public func unlock() {
        pthread_mutex_unlock(&mutex)
    }

    /// ReerKit: Executes a closure returning a value while acquiring the lock.
    ///
    /// - Parameter execute: The closure to run while holding the lock.
    ///
    /// - Returns: The value the closure generated.
    ///
    /// - Throws: Rethrows any error that the closure might throw.
    public func around<Result>(_ execute: () throws -> Result) rethrows -> Result {
        lock()
        defer { unlock() }
        return try execute()
    }
}
