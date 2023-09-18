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

#if canImport(Dispatch)
import Dispatch

/// ReerKit: Get current queue label.
/// - Returns: Queue label string.
public func currentQueueLabel() -> String {
    let label = __dispatch_queue_get_label(nil)
    return String(cString: label, encoding: .utf8) ?? ""
}

/// ReerKit: Execute a closure on main queue asynchronously.
public func asyncOnMainQueue(_ action: @escaping () -> Void) {
    if currentQueueLabel() == DispatchQueue.main.label {
        action()
    } else {
        DispatchQueue.main.async(execute: action)
    }
}

/// ReerKit: Execute a closure on main queue synchronously.
public func syncOnMainQueue(_ action: @escaping () -> Void) {
    if currentQueueLabel() == DispatchQueue.main.label {
        action()
    } else {
        DispatchQueue.main.sync(execute: action)
    }
}

/// ReerKit: Execute a closure on global queue asynchronously.
public func asyncOnGlobalQueue(qos: DispatchQoS.QoSClass = .default, action: @escaping () -> Void) {
    DispatchQueue.global(qos: qos).async(execute: action)
}

/// ReerKit: Execute a closure on global queue synchronously.
public func syncOnGlobalQueue(qos: DispatchQoS.QoSClass = .default, action: @escaping () -> Void) {
    DispatchQueue.global(qos: qos).sync(execute: action)
}

/// ReerKit: Delay to execute a closure on the queue.
public func delay(_ interval: Double, onQueue queue: DispatchQueue = .main, action: @escaping () -> Void) {
    queue.asyncAfter(deadline: .now() + interval, execute: action)
}
#endif
