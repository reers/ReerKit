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

public extension Reer where Base: Timer {
    
    /// ReerKit: Creates a timer and schedules it on the current run loop in the default mode.
    /// The target will be wrapped with a WeakProxy.
    static func scheduledTimer(
        timeInterval: TimeInterval,
        weakTarget: NSObject,
        selector: Selector,
        userInfo: Any?,
        repeats: Bool
    ) -> Timer {
        return Base.scheduledTimer(
            timeInterval: timeInterval,
            target: WeakProxy(target: weakTarget),
            selector: selector,
            userInfo: userInfo,
            repeats: repeats
        )
    }
    
    /// ReerKit: Initializes a timer object with the specified object and selector.
    /// The target will be wrapped with a WeakProxy.
    static func timer(
        timeInterval: TimeInterval,
        weakTarget: NSObject,
        selector: Selector,
        userInfo: Any?,
        repeats: Bool
    ) -> Timer {
        return Base(
            timeInterval: timeInterval,
            target: WeakProxy(target: weakTarget),
            selector: selector,
            userInfo: userInfo,
            repeats: repeats
        )
    }
    
    /// ReerKit: Resumes the timer.
    func resume() {
        let interval = base.intervalBeforeFiring
        guard interval > 0 else { return }
        base.fireDate = Date(timeIntervalSinceNow: interval)
        base.intervalBeforeFiring = 0
    }
    
    /// ReerKit: Suspends the timer.
    func suspend() {
        guard base.intervalBeforeFiring == 0 else { return }
        base.intervalBeforeFiring = base.fireDate.timeIntervalSinceNow
        base.fireDate = .distantFuture
    }
    
}

fileprivate extension Timer {
    
    @objc
    var intervalBeforeFiring: TimeInterval {
        get {
            re.associatedValue(forKey: AssociationKey(#function as StaticString), default: 0)
        }
        set {
            re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString))
        }
    }
}
#endif
