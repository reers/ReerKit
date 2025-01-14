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
