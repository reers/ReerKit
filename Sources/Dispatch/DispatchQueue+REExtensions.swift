//
//  Copyright © 2020 SwifterSwift
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

public extension Reer where Base: DispatchQueue {
    
    /// ReerKit: A Boolean value indicating whether the current dispatch queue is the main queue.
    static var isOnMainQueue: Bool {
        return currentQueueLabel() == DispatchQueue.main.label
    }
    
    /// ReerKit: Returns a Boolean value indicating whether the current dispatch queue is the specified queue.
    ///
    /// - Returns: `true` if the current queue is the specified queue, otherwise `false`.
    var isExecuting: Bool {
        let key = DispatchSpecificKey<Void>()
        base.setSpecific(key: key, value: ())
        defer { base.setSpecific(key: key, value: nil) }
        return DispatchQueue.getSpecific(key: key) != nil
    }
}

public typealias DelayTimeInSecond = Double
public extension Reer where Base: DispatchQueue {

    /// ReerKit: Runs passed closure asynchronous after certain time interval.
    ///
    /// - Parameters:
    ///   - delay: The time interval(second) after which the closure will run.
    ///   - qos: Quality of service at which the work item should be executed.
    ///   - flags: Flags that control the execution environment of the work item.
    ///   - work: The closure to run after certain time interval.
    func asyncAfter(
        delay: DelayTimeInSecond,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping () -> Void
    ) {
        base.asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }
}

#endif
