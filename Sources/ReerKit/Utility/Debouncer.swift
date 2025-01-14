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

/// A class that provides debouncing functionality for executing actions after a specified delay.
public final class Debouncer {
    /// The dispatch queue on which the debounced action will be executed.
    private let queue: DispatchQueue
    
    /// The current work item representing the debounced action.
    public private(set) var workItem = DispatchWorkItem(block: {})
    
    /// The lock used for thread-safe operations.
    #if os(Linux)
    private let lock = MutexLock()
    #else
    private let lock = UnfairLock()
    #endif

    /// Initializes a new Debouncer instance.
    ///
    /// - Parameter queue: The dispatch queue to use for executing the debounced action. Defaults to the main queue.
    public init(queue: DispatchQueue = .main) {
        self.queue = queue
    }

    /// Executes the given action after the specified time interval, cancelling any previously scheduled action.
    ///
    /// - Parameters:
    ///   - interval: The time interval to wait before executing the action.
    ///   - action: The action to be executed.
    public func execute(interval: TimeInterval, action: @escaping () -> Void) {
        execute(time: interval, action: action)
    }

    /// Executes the given action at the specified dispatch time, cancelling any previously scheduled action.
    ///
    /// - Parameters:
    ///   - deadline: The dispatch time at which to execute the action.
    ///   - action: The action to be executed.
    public func execute(deadline: DispatchTime, action: @escaping () -> Void) {
        execute(time: deadline, action: action)
    }

    /// Executes the given action at the specified wall clock time, cancelling any previously scheduled action.
    ///
    /// - Parameters:
    ///   - wallDeadline: The wall clock time at which to execute the action.
    ///   - action: The action to be executed.
    public func execute(wallDeadline: DispatchWallTime, action: @escaping () -> Void) {
        execute(time: wallDeadline, action: action)
    }

    /// Private method that handles the execution of the debounced action.
    ///
    /// - Parameters:
    ///   - time: The time at which to execute the action, can be TimeInterval, DispatchTime, or DispatchWallTime.
    ///   - action: The action to be executed.
    private func execute<Time: Comparable>(time: Time, action: @escaping () -> Void) {
        lock.around {
            // Cancel any previously scheduled work item
            workItem.cancel()
            
            // Create a new work item with the given action
            workItem = DispatchWorkItem(block: action)
            
            // Schedule the work item based on the type of time provided
            if let time = time as? TimeInterval {
                queue.asyncAfter(deadline: .now() + time, execute: workItem)
            } else if let time = time as? DispatchTime {
                queue.asyncAfter(deadline: time, execute: workItem)
            } else if let time = time as? DispatchWallTime {
                queue.asyncAfter(wallDeadline: time, execute: workItem)
            }
        }
    }
}
#endif
