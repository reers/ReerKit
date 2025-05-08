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

#if !os(watchOS) && !os(Linux) && canImport(QuartzCore)
import QuartzCore

/// CAAnimation delegate proxy
private final class CAAnimationDelegateProxy: NSObject, CAAnimationDelegate {
    fileprivate var onStartActions = [(CAAnimation) -> Void]()
    fileprivate var onStopActions = [(CAAnimation, Bool) -> Void]()
    
    // MARK: - CAAnimationDelegate
    
    func animationDidStart(_ anim: CAAnimation) {
        onStartActions.forEach { $0(anim) }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        onStopActions.forEach { $0(anim, flag) }
    }
}

public extension Reer where Base: CAAnimation {
    /// ReerKit: Create delegate proxy if it doesn't exist
    ///
    /// - Returns: CAAnimationDelegateProxy
    private var delegateProxy: CAAnimationDelegateProxy {
        guard let delegate = base.delegate as? CAAnimationDelegateProxy else {
            let proxy = CAAnimationDelegateProxy()
            base.delegate = proxy  // retained
            return proxy
        }
        return delegate
    }
    
    /// ReerKit: CAAnimation wrapper to avoid circular references.
    ///
    /// - Parameters:
    ///   - action: A closure that call back with you created `animation` instance when animation start.
    /// - Returns: Reer
    @discardableResult
    func onStart(_ action: @escaping (CAAnimation) -> Void) -> Self {
        delegateProxy.onStartActions.append(action)
        return self
    }
    
    /// ReerKit: CAAnimation wrapper to avoid circular references.
    ///
    /// - Parameters:
    ///   - action: A closure that call back with you created `animation` instance and `finished` flag when animation stop.
    /// - Returns: Reer
    @discardableResult
    func onStop(_ action: @escaping (CAAnimation, Bool) -> Void) -> Self {
        delegateProxy.onStopActions.append(action)
        return self
    }
}

#endif
