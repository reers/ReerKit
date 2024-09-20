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
    
    public enum State {
        case initial
        case running
        case suspended
        case invalidated
    }

    /// A number of seconds.
    public typealias TimeInterval = Double

    public private(set) var repeats: Bool
    public private(set) var timeInterval: TimeInterval
    public private(set) var state: State = .initial
    public typealias RETimerAction = (_ timer: RETimer) -> Void
    
    private let timer: DispatchSourceTimer
    private var action: RETimerAction
    private var callbackImmediatelyWhenFired: Bool = false
    private let delay: TimeInterval
    
    /// A record for timer to count seconds when callback occurs every second.
    private var secondsCount = 0

    // MARK: - Properties for Timing

    /// Records the time when the timer starts or resumes running.
    private var startTime: Date?

    /// Accumulated running time, excluding paused durations.
    private var elapsedTime: TimeInterval = 0

    /// Total elapsed time since the timer started, excluding paused durations.
    public var totalElapsedTime: TimeInterval {
        if let startTime = startTime {
            // Timer is running, calculate the current running duration.
            return elapsedTime + Date().timeIntervalSince(startTime)
        } else {
            // Timer is not running, return the accumulated running time.
            return elapsedTime
        }
    }

    /// ReerKit: Initializes a timer object with the specified time interval and block.
    /// You must call `schedule()` yourself after creating the timer.
    ///
    /// - Parameters:
    ///   - delay: The delay interval after `schedule` method is invoked.
    ///   - timeInterval: The number of seconds between firings of the timer. If timeInterval is less than or equal to 0.0, this method chooses the nonnegative value of 0.0001 seconds instead.
    ///   - repeats: If true, the timer will repeatedly reschedule itself until invalidated. If false, the timer will be invalidated after it fires.
    ///   - queue: The dispatch queue to which to execute the installed handlers.
    ///   - callbackImmediatelyWhenFired: When should callback when time is fired, default is `false`, and its behavior is the same as `Foundation.Timer`
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
            guard let self = self, self.state != .invalidated else { return }
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
    ///   - callbackImmediatelyWhenFired: When should callback when time is fired, default is `false`, and its behavior is the same as `Foundation.Timer`
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
    ///   - fireDate: The fire date of the timer.
    ///   - timeInterval: The number of seconds between firings of the timer. If timeInterval is less than or equal to 0.0, this method chooses the nonnegative value of 0.0001 seconds instead.
    ///   - repeats: If true, the timer will repeatedly reschedule itself until invalidated. If false, the timer will be invalidated after it fires.
    ///   - queue: The dispatch queue to which to execute the installed handlers.
    ///   - callbackImmediatelyWhenFired: When should callback when time is fired, default is `false`, and its behavior is the same as `Foundation.Timer`
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
        guard state == .initial || state == .suspended else { return false }
        _ = scheduleTimerOnce
        timer.resume()
        state = .running
        startTime = Date() // Record start time
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
    
    /// ReerKit: Resumes the timer. Same as `schedule()`.
    public func resume() {
        guard state == .suspended else { return }
        timer.resume()
        state = .running
        startTime = Date() // Record resume time
    }

    /// ReerKit: Suspends the timer.
    public func suspend() {
        guard state == .running else { return }
        timer.suspend()
        state = .suspended
        if let startTime = startTime {
            elapsedTime += Date().timeIntervalSince(startTime) // Accumulate running time
            self.startTime = nil
        }
    }
    
    /// ReerKit: Stops the timer from ever firing again.
    public func invalidate() {
        guard state != .invalidated else { return }
        if state == .suspended {
            timer.resume()
        }
        if let startTime = startTime {
            elapsedTime += Date().timeIntervalSince(startTime) // Accumulate running time
            self.startTime = nil
        }
        timer.cancel()
        state = .invalidated
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
    
    /// ReerKit: Creates a timer that fires every second, providing the timer instance, display seconds, and passed duration.
    ///
    /// This method creates a timer that fires every second, calling the `action` closure with the timer, the number of seconds that have passed, and the total elapsed time excluding any paused durations. Internally, it uses a more frequent interval for increased accuracy, especially when resuming from a suspended state.
    ///
    /// **Usage example:**
    /// ```swift
    /// let timer = RETimer.scheduledTimerEverySecond { timer, displaySeconds, passedDuration in
    ///     print("Timer fired! Display Seconds: \(displaySeconds), Passed Duration: \(passedDuration)")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - queue: The dispatch queue on which to execute the timer. Defaults to the main queue.
    ///   - action: A closure to be executed every second. The closure takes three parameters:
    ///     - `timer`: The `RETimer` instance.
    ///     - `displaySeconds`: An `Int` representing the number of seconds that have passed since the timer started.
    ///     - `passedDuration`: A `TimeInterval` representing the total elapsed time excluding any paused durations.
    /// - Returns: An instance of `RETimer` configured to fire every second.
    static func scheduledTimerEverySecond(
        queue: DispatchQueue = .main,
        action: @escaping (_ timer: RETimer, _ displaySeconds: Int, _ passedDuration: TimeInterval) -> Void
    ) -> RETimer {
        let accuracy: TimeInterval = 0.1
        let updatesPerSecond = Int(1.0 / accuracy)
        
        let timer = RETimer(
            timeInterval: accuracy,
            repeats: true,
            queue: queue,
            callbackImmediatelyWhenFired: false
        ) { internalTimer in
            internalTimer.secondsCount += 1
            if internalTimer.secondsCount % updatesPerSecond == 0 {
                let displaySeconds = internalTimer.secondsCount / updatesPerSecond
                let passedDuration = internalTimer.totalElapsedTime
                action(internalTimer, displaySeconds, passedDuration)
            }
        }
        
        timer.schedule()
        
        // Immediately call the action with initial values
        queue.async {
            let displaySeconds = 0
            let passedDuration = timer.totalElapsedTime
            action(timer, displaySeconds, passedDuration)
        }
        
        return timer
    }
}

#endif
