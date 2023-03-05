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

#if canImport(Foundation)
import Foundation

public final class Throttler {

    public enum PerformMode {
        case first
        case last
    }

    private var isPending = false
    private var hasExecuted = false
    private var latestAction: () -> Void = {}
    private let lock = UnfairLock()

    private let queue: DispatchQueue
    private let performMode: PerformMode

    public init(queue: DispatchQueue = .main, performMode: PerformMode = .first) {
        self.queue = queue
        self.performMode = performMode
    }

    public func execute(interval: TimeInterval, action: @escaping () -> Void) {
        execute(time: interval, action: action)
    }

    public func execute(deadline: DispatchTime, action: @escaping () -> Void) {
        execute(time: deadline, action: action)
    }

    public func execute(wallDeadline: DispatchTime, action: @escaping () -> Void) {
        execute(time: wallDeadline, action: action)
    }

    private func execute<Time: Comparable>(time: Time, action: @escaping () -> Void) {

        func execute(onQueue queue: DispatchQueue, after time: Time, action: DispatchWorkItem) {
            if let time = time as? TimeInterval {
                queue.asyncAfter(deadline: .now() + time, execute: action)
            } else if let time = time as? DispatchTime {
                queue.asyncAfter(deadline: time, execute: action)
            } else if let time = time as? DispatchWallTime {
                queue.asyncAfter(wallDeadline: time, execute: action)
            }
        }

        lock.around {
            switch performMode {
            case .first:
                if hasExecuted { return }
                queue.async {
                    action()
                }
                hasExecuted = true
                let workItem = DispatchWorkItem {
                    self.hasExecuted = false
                }
                execute(onQueue: queue, after: time, action: workItem)
            case .last:
                latestAction = action
                if isPending { return }
                isPending = true
                let workItem = DispatchWorkItem {
                    self.latestAction()
                    self.isPending = false
                }
                execute(onQueue: queue, after: time, action: workItem)
            }
        }
    }
}
#endif
