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

public protocol MulticastDelegateProtocol {
    associatedtype Delegate
    func add(delegate: Delegate)
    func remove(delegate: Delegate)
    func removeAllDelegates()
}

/// `MulticastDelegate` lets you easily create a "multicast delegate" for a given protocol or class.
/// The delegate will be a weak reference in `MulticastDelegate`, and will be removed automatically
/// from `delegates` after it released.
public final class MulticastDelegate<T> {
    
    private let delegates: WeakSet<AnyObject>
    #if os(Linux)
    private let lock = MutexLock()
    #else
    private let lock = UnfairLock()
    #endif
    
    
    /// ReerKit: Initialize a new `MulticastDelegate`, and delete references will be weak.
    public init() {
        delegates = WeakSet<AnyObject>()
    }
    
    /// ReerKit: Use the property to check if no delegates are contained there.
    public var isEmpty: Bool {
        return delegates.count == 0
    }
    
    /// ReerKit: Add a delegate.
    public func add(_ delegate: T) {
        guard let delegate = delegate as AnyObject? else {
            assert(false, "MulticastDelegate: delegate is not an AnyObject")
            return
        }
        lock.around { delegates.add(delegate) }
    }
    
    /// ReerKit: Remove a previously-added delegate.
    public func remove(_ delegate: T) {
        guard let delegate = delegate as AnyObject? else {
            assert(false, "MulticastDelegate: delegate is not an AnyObject")
            return
        }
        lock.around { delegates.remove(delegate) }
    }
    
    public func removeAllDelegates() {
        lock.around { delegates.removeAll() }
    }
    
    @available(*, deprecated, renamed: "notify(_:)", message: "Use notify(_:) instead.")
    public func invoke(_ invocation: (T) -> Void) {
        notify(invocation)
    }
    
    /// ReerKit: Notify a closure on each delegate.
    public func notify(_ function: (T) -> Void) {
        let delegateCopy = lock.around { delegates }
        for delegate in delegateCopy {
            if let delegate = delegate as? T {
                function(delegate)
            }
        }
    }
    
    /// ReerKit: Checks if the multicast delegate contains the given delegate.
    public func contains(_ delegate: T) -> Bool {
        guard let delegate = delegate as AnyObject? else {
            assert(false, "MulticastDelegate: delegate is not an AnyObject")
            return false
        }
        return delegates.contains(delegate)
    }
}
