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

/// `MulticastDelegate` lets you easily create a "multicast delegate" for a given protocol or class.
/// The delegate will be a weak reference in `MulticastDelegate`, and will be removed automatically
/// from `delegates` after it released.
open class MulticastDelegate<T> {
    
    private let delegates: WeakSet<AnyObject>
    
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
        delegates.add(delegate as AnyObject)
    }
    
    /// ReerKit: Remove a previously-added delegate.
    public func remove(_ delegate: T) {
        delegates.remove(delegate as AnyObject)
    }
    
    /// ReerKit: Invoke a closure on each delegate.
    public func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates {
            if let delegate = delegate as? T {
                invocation(delegate)
            }
        }
    }
    
    /// ReerKit: Checks if the multicast delegate contains the given delegate.
    public func contains(_ delegate: T) -> Bool {
        return delegates.contains(delegate as AnyObject)
    }
}
