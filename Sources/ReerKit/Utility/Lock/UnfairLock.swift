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

#if canImport(os) && !os(Linux)
import os.lock

/// ReerKit: A wrapper of `os_unfair_lock`
///
/// - Important: The lock is heap-allocated to prevent issues with Swift's
///   potential bitwise copying of struct properties. `os_unfair_lock` relies
///   on its memory address for correctness, so copying it would cause undefined behavior.
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
    
    @inline(__always)
    public func lock() {
        os_unfair_lock_lock(unfairLock)
    }
    
    /// ReerKit: Returns true if the lock was succesfully locked and false if the lock was already locked.
    @inline(__always)
    @discardableResult
    public func tryLock() -> Bool {
        return os_unfair_lock_trylock(unfairLock)
    }
    
    @inline(__always)
    public func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }

    /// ReerKit: Executes a closure returning a value while acquiring the lock.
    ///
    /// - Parameter execute: The closure to run.
    ///
    /// - Returns: The value the closure generated.
    public func around<Result>(_ execute: () throws -> Result) rethrows -> Result {
        lock()
        defer { unlock() }
        return try execute()
    }
}

#endif
