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

#if canImport(Foundation) && canImport(Dispatch) && canImport(os) && !os(Linux)
import Foundation
import Dispatch

/// A class that represents a countdown timer with customizable intervals and durations.
public final class CountdownTimer {
    /// The time interval between each tick of the timer.
    public let interval: TimeInterval
    
    /// The total number of times the timer should tick.
    public let times: Int
    
    /// The total duration of the countdown.
    public let totalDuration: TimeInterval
    
    /// The action to be performed on each tick of the timer.
    public let action: (CountdownTimer) -> Void

    private let lock = UnfairLock()
    private var _leftTimes: Int

    /// The number of ticks remaining.
    public var leftTimes: Int {
        return lock.around { _leftTimes }
    }

    /// The remaining duration of the countdown.
    public var leftDuration: TimeInterval {
        return max(0, interval * Double(leftTimes))
    }

    /// Indicates whether the countdown has finished.
    public var finished: Bool {
        return leftTimes <= 0
    }

    /// The underlying timer object.
    private var timer: RETimer?

    /// Initializes a new countdown timer with a specified interval and number of ticks.
    ///
    /// - Parameters:
    ///   - interval: The time interval between each tick.
    ///   - times: The total number of ticks.
    ///   - action: The action to be performed on each tick.
    public init(interval: TimeInterval, times: Int, action: @escaping (CountdownTimer) -> Void) {
        let sanitizedInterval = max(0, interval)
        let sanitizedTimes = max(0, times)
        self.interval = sanitizedInterval
        self.times = sanitizedTimes
        self.totalDuration = sanitizedInterval * Double(sanitizedTimes)
        self.action = action
        self._leftTimes = sanitizedTimes
    }

    /// Initializes a new countdown timer with a specified number of ticks and total duration.
    ///
    /// - Parameters:
    ///   - times: The total number of ticks.
    ///   - totalDuration: The total duration of the countdown.
    ///   - action: The action to be performed on each tick.
    public init(times: Int, totalDuration: TimeInterval, action: @escaping (CountdownTimer) -> Void) {
        let sanitizedTimes = max(0, times)
        let sanitizedDuration = sanitizedTimes > 0 ? max(0, totalDuration) : 0
        self.interval = sanitizedTimes > 0 ? sanitizedDuration / Double(sanitizedTimes) : 0
        self.times = sanitizedTimes
        self.totalDuration = sanitizedDuration
        self.action = action
        self._leftTimes = sanitizedTimes
    }

    /// Creates and returns a new countdown timer with the specified interval and number of ticks.
    ///
    /// - Parameters:
    ///   - interval: The time interval between each tick.
    ///   - times: The total number of ticks.
    ///   - action: The action to be performed on each tick.
    /// - Returns: A new countdown timer that has already started.
    public static func scheduledTimer(
        withInterval interval: TimeInterval,
        times: Int,
        action: @escaping (CountdownTimer) -> Void
    ) -> CountdownTimer {
        let timer = CountdownTimer(interval: interval, times: times, action: action)
        timer.fire()
        return timer
    }

    /// Creates and returns a new countdown timer with the specified number of ticks and total duration.
    ///
    /// - Parameters:
    ///   - times: The total number of ticks.
    ///   - totalDuration: The total duration of the countdown.
    ///   - action: The action to be performed on each tick.
    /// - Returns: A new countdown timer that has already started.
    public static func scheduledTimer(
        withTimes times: Int,
        totalDuration: TimeInterval,
        action: @escaping (CountdownTimer) -> Void
    ) -> CountdownTimer {
        let timer = CountdownTimer(times: times, totalDuration: totalDuration, action: action)
        timer.fire()
        return timer
    }
    
    /// A record for count down timer when call back every second.
    private var secondsCount = 0
    
    /// ReerKit: Countdown timer with a total seconds be set, and call back every second.
    ///
    /// ```
    /// var countdownTimer = CountdownTimer.scheduledTimer(withTotalSeconds: 60) {
    ///     [weak self] displaySeconds, leftDuration, passedDuration in
    ///
    ///     let minutes = Int(Double(displaySeconds) / 60.0)
    ///     let seconds = Int(Double(displaySeconds) - minutes.re.double * 60.0)
    ///     self?.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - totalSeconds: Total seconds with `Int`
    ///   - action: Called back every second, carrying the displayed number of seconds, remaining time, and elapsed time.
    /// - Returns: A countdown timer.
    public static func scheduledTimer(
        withTotalSeconds totalSeconds: Int,
        action: @escaping (_ displaySeconds: Int, _ leftDuration: TimeInterval, _ passedDuration: TimeInterval) -> Void
    ) -> CountdownTimer {
        let accuracy: TimeInterval = 0.1
        let multiple = Int(1.0 / accuracy)
        let sanitizedSeconds = max(0, totalSeconds)
        let totalTimes = sanitizedSeconds * multiple
        let timer = CountdownTimer(interval: accuracy, times: totalTimes) { countDownTimer in
            let secondsCount: Int = countDownTimer.lock.around {
                countDownTimer.secondsCount += 1
                return countDownTimer.secondsCount
            }

            if secondsCount % multiple == 0 {
                let leftDuration = countDownTimer.leftDuration
                let displaySeconds = Int(leftDuration.rounded(.up))
                let passedDuration = max(0, Double(sanitizedSeconds) - leftDuration)
                action(displaySeconds, leftDuration, passedDuration)
            }
        }
        timer.fire()
        return timer
    }

    /// Starts the countdown timer. Calling it again invalidates the previous
    /// timer first, so the action can never be delivered twice per tick.
    public func fire() {
        let (oldTimer, newTimer): (RETimer?, RETimer?) = lock.around {
            let previous = timer
            timer = nil
            guard _leftTimes > 0 else {
                return (previous, nil)
            }

            let created = RETimer(timeInterval: interval, repeats: true) { [weak self] firingTimer in
                guard let self = self else { return }

                var shouldInvokeAction = false
                var shouldInvalidateTimer = false

                self.lock.lock()
                if self.timer === firingTimer, self._leftTimes > 0 {
                    self._leftTimes -= 1
                    shouldInvokeAction = true
                    if self._leftTimes <= 0 {
                        self.timer = nil
                        shouldInvalidateTimer = true
                    }
                } else {
                    shouldInvalidateTimer = true
                }
                self.lock.unlock()

                if shouldInvalidateTimer {
                    firingTimer.invalidate()
                }
                if shouldInvokeAction {
                    self.action(self)
                }
            }
            timer = created
            return (previous, created)
        }

        oldTimer?.invalidate()
        newTimer?.schedule()
    }

    /// Resumes the countdown timer if it was suspended.
    public func resume() {
        let currentTimer = lock.around { timer }
        currentTimer?.resume()
    }

    /// Suspends the countdown timer.
    public func suspend() {
        let currentTimer = lock.around { timer }
        currentTimer?.suspend()
    }

    /// Invalidates the countdown timer, preventing it from ever firing again.
    public func invalidate() {
        let oldTimer: RETimer? = lock.around {
            let previous = timer
            timer = nil
            return previous
        }
        oldTimer?.invalidate()
    }

    /// Resets the countdown timer to its initial state.
    public func reset() {
        let oldTimer: RETimer? = lock.around {
            let previous = timer
            timer = nil
            _leftTimes = times
            secondsCount = 0
            return previous
        }
        oldTimer?.invalidate()
    }
}

#endif
