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

#if canImport(Foundation)
import Foundation
#endif

/// ReerKit: A timer based on `DispatchSource`.
///
///                           fireDate
///     schedule()   callbackImmediatelyWhenFired  default first callback
///         |                     |                      |
///         |--------delay--------|-------interval-------|-------interval-------|
public final class RETimer {

    /// A number of seconds.
    public typealias TimeInterval = Double

    public private(set) var repeats: Bool
    public private(set) var timeInterval: TimeInterval
    public private(set) var isValid = true
    public typealias RETimerAction = (_ timer: RETimer) -> Void
    
    private let timer: DispatchSourceTimer
    private var action: RETimerAction
    private var isRunning = false
    private var callbackImmediatelyWhenFired: Bool = false
    private let delay: TimeInterval

    /// ReerKit: Initializes a timer object with the specified time interval and block.
    /// You must call `schedule()` by yourself after creating the timer.
    ///
    /// - Parameters:
    ///   - delay: The delay interval after `schedule` method is invoked.
    ///   - timeInterval: The number of seconds between firings of the timer. If timeInterval is less than or equal to 0.0, this method chooses the nonnegative value of 0.0001 seconds instead.
    ///   - repeats: If true, the timer will repeatedly reschedule itself until invalidated. If false, the timer will be invalidated after it fires.
    ///   - queue: The dispatch queue to which to execute the installed handlers.
    ///   - callbackImmediatelyWhenFired: When should callback when time is fired, default is `false`, and its behavior is same like `Foundation.Timer`
    ///   - action: A closure to be executed when the timer fires. The closure takes a single Timer parameter and has no return value.
    public init(
        delay: TimeInterval = 0,
        timeInterval: TimeInterval,
        repeats: Bool = true,
        queue: DispatchQueue = .main,
        callbackImmediatelyWhenFired: Bool = false,
        action: @escaping RETimerAction
    ) {
        self.repeats = repeats
        self.action = action
        self.timeInterval = max(0.0001, timeInterval)
        self.callbackImmediatelyWhenFired = callbackImmediatelyWhenFired
        self.delay = delay

        self.timer = DispatchSource.makeTimerSource(queue: queue)
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            action(self)
            if !repeats {
                self.invalidate()
            }
        }
    }
    
    /// ReerKit: Creates a timer and schedules it with a delay interval.
    /// - Parameters:
    ///   - delay: The delay interval after `schedule` method is invoked.
    ///   - timeInterval: The number of seconds between firings of the timer. If timeInterval is less than or equal to 0.0, this method chooses the nonnegative value of 0.0001 seconds instead.
    ///   - repeats: If true, the timer will repeatedly reschedule itself until invalidated. If false, the timer will be invalidated after it fires.
    ///   - queue: The dispatch queue to which to execute the installed handlers.
    ///   - callbackImmediatelyWhenFired: When should callback when time is fired, default is `false`, and its behavior is same like `Foundation.Timer`
    ///   - action: A closure to be executed when the timer fires. The closure takes a single Timer parameter and has no return value.
    /// - Returns: A timer instance.
    public class func scheduledTimer(
        delay: TimeInterval = 0,
        timeInterval: TimeInterval,
        repeats: Bool = true,
        queue: DispatchQueue = .main,
        callbackImmediatelyWhenFired: Bool = false,
        action: @escaping RETimerAction
    ) -> RETimer {
        let timer = RETimer(
            delay: delay,
            timeInterval: timeInterval,
            repeats: repeats,
            queue: queue,
            callbackImmediatelyWhenFired: callbackImmediatelyWhenFired,
            action: action
        )
        timer.schedule()
        return timer
    }

    #if canImport(Foundation)
    /// ReerKit: Creates a timer and schedules it on a fire date.
    /// - Parameters:
    ///   - fireDate: The fire date of timer.
    ///   - timeInterval: The number of seconds between firings of the timer. If timeInterval is less than or equal to 0.0, this method chooses the nonnegative value of 0.0001 seconds instead.
    ///   - repeats: If true, the timer will repeatedly reschedule itself until invalidated. If false, the timer will be invalidated after it fires.
    ///   - queue: The dispatch queue to which to execute the installed handlers.
    ///   - callbackImmediatelyWhenFired: When should callback when time is fired, default is `false`, and its behavior is same like `Foundation.Timer`
    ///   - action: A closure to be executed when the timer fires. The closure takes a single Timer parameter and has no return value.
    /// - Returns: A timer instance.
    public static func scheduledTimer(
        fireDate: Date,
        timeInterval: TimeInterval,
        repeats: Bool = true,
        queue: DispatchQueue = .main,
        callbackImmediatelyWhenFired: Bool = false,
        action: @escaping RETimerAction
    ) -> RETimer {
        let delay = max(0, fireDate.timeIntervalSince(Date()))
        let timer = RETimer(
            delay: delay,
            timeInterval: timeInterval,
            repeats: repeats,
            queue: queue,
            callbackImmediatelyWhenFired: callbackImmediatelyWhenFired,
            action: action
        )
        timer.schedule()
        return timer
    }
    #endif

    /// ReerKit: Schedules a timer.
    @discardableResult
    public func schedule() -> Bool {
        guard isValid, !isRunning else { return false }
        let _ = scheduleTimerOnce
        timer.resume()
        isRunning = true
        return true
    }

    private lazy var scheduleTimerOnce: Void = {
        var deadlineTime: DispatchTimeInterval
        if callbackImmediatelyWhenFired {
            deadlineTime = .milliseconds(0)
        } else {
            deadlineTime = .milliseconds(Int(timeInterval * 1000))
        }

        let delayTime: DispatchTimeInterval = .milliseconds(Int(delay * 1000))
        if repeats {
            timer.schedule(deadline: .now() + delayTime + deadlineTime, repeating: timeInterval)
        } else {
            timer.schedule(deadline: .now() + delayTime + deadlineTime)
        }
    }()
    
    /// ReerKit: Resumes the timer. Same to `schedule()`.
    public func resume() {
        schedule()
    }

    /// ReerKit: Suspends the timer.
    public func suspend() {
        guard isValid, isRunning else { return }
        timer.suspend()
        isRunning = false
    }
    
    /// ReerKit: Stops the timer from ever firing again.
    public func invalidate() {
        timer.cancel()
        isRunning = false
        isValid = false
    }
}

public extension RETimer {
    
    /// ReerKit: Execute the closure after the delay interval.
    /// - Parameters:
    ///   - delay: The delay interval.
    ///   - queue: The dispatch queue to which to execute the installed handlers.
    ///   - action: A closure to be executed after the delay.
    static func after(
        _ delay: TimeInterval,
        queue: DispatchQueue = .main,
        action: @escaping () -> Void
    ) {
        queue.asyncAfter(deadline: .now() + delay, execute: action)
    }
}

#endif
