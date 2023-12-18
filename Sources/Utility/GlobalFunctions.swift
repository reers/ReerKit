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


#if canImport(Darwin)
import Darwin

/// ReerKit: Get info by name via `sysctl`
/// e.g.
/// hw.model
/// kern.osversion
/// kern.hostname
public func sysctl(by name: String) -> String {
    var result: String?
    var size: size_t = 0
    sysctlbyname(name, nil, &size, nil, 0)
    var machine = [CChar](repeating: 0, count: Int(size))
    guard let last = machine.last, last == 0 else { return "" }
    sysctlbyname(name, &machine, &size, nil, 0)
    result = String(cString: machine, encoding: .utf8)
    return result ?? ""
}
#endif


/// ReerKit: Return a `Bool` value, the probability of it being `true` is the input value.
func trueWithProbability(_ percent: Double) -> Bool {
    let total = 1_000_000.0
    let max = total * percent
    return Double.random(in: 0...total) <= max
}

/// ReerKit: Return a `Bool` value, the probability of it being `false` is the input value.
func falseWithProbability(_ percent: Double) -> Bool {
    let total = 1_000_000.0
    let min = total * percent
    return Double.random(in: 0...total) > min
}
