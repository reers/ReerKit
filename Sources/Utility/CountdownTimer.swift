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

#if canImport(Foundation) && canImport(Dispatch)
import Foundation
import Dispatch

public final class CountdownTimer {
    public let interval: TimeInterval
    public let times: Int
    public let totalDuration: TimeInterval
    public let action: (CountdownTimer) -> Void

    public private(set) var leftTimes: Int

    public var leftDuration: TimeInterval {
        return interval * Double(leftTimes)
    }

    public var finished: Bool {
        return leftTimes == 0
    }

    private var timer: RETimer?

    public init(interval: TimeInterval, times: Int, action: @escaping (CountdownTimer) -> Void) {
        self.interval = interval
        self.times = times
        self.totalDuration = interval * Double(times)
        self.action = action
        self.leftTimes = times
    }

    public init(times: Int, totalDuration: TimeInterval, action: @escaping (CountdownTimer) -> Void) {
        self.interval = totalDuration / Double(times)
        self.times = times
        self.totalDuration = totalDuration
        self.action = action
        self.leftTimes = times
    }

    public static func scheduledTimer(
        withInterval interval: TimeInterval,
        times: Int,
        action: @escaping (CountdownTimer) -> Void
    ) -> CountdownTimer {
        let timer = CountdownTimer(interval: interval, times: times, action: action)
        timer.fire()
        return timer
    }

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
        let totalTimes = totalSeconds * multiple
        let timer = CountdownTimer(interval: accuracy, times: totalTimes) { countDownTimer in
            countDownTimer.secondsCount += 1
            if countDownTimer.secondsCount % multiple == 0 {
                let displaySeconds = Int(countDownTimer.leftDuration.rounded(.up))
                let passedDuration = Double(totalSeconds) - countDownTimer.leftDuration
                action(displaySeconds, countDownTimer.leftDuration, passedDuration)
            }
        }
        timer.fire()
        return timer
    }

    public func fire() {
        timer = RETimer.scheduledTimer(timeInterval: interval, repeats: times > 1) { [weak self] timer in
            guard let self = self else { return }
            self.leftTimes -= 1
            if self.leftTimes == 0 {
                timer.invalidate()
            }
            self.action(self)
        }
    }
    
    public func resume() {
        timer?.schedule()
    }

    public func suspend() {
        timer?.suspend()
    }

    public func invalidate() {
        timer?.invalidate()
    }
    
    public func reset() {
        resume()
        invalidate()
        timer = nil
        leftTimes = times
        secondsCount = 0
    }
}

#endif
