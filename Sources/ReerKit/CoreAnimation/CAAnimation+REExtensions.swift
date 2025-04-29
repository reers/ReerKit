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

public typealias RECADidStartBlock = (CAAnimation) -> Void
public typealias RECADidStopBlock = (CAAnimation, Bool) -> Void

/// CAAnimation delegate mediator
private final class CAAnimationDelegateMediator: NSObject, CAAnimationDelegate {
    fileprivate var startBlock: RECADidStartBlock?
    fileprivate var stopBlock: RECADidStopBlock?
    
    // MARK: - CAAnimationDelegate
    
    func animationDidStart(_ anim: CAAnimation) {
        startBlock?(anim)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopBlock?(anim, flag)
    }
}

public extension Reer where Base: CAAnimation {
    /// ReerKit: CAAnimation wrapper to avoid circular references.
    ///
    /// - Parameters:
    ///   - block: call back when animation start.
    func animationDidStart(_ block: @escaping RECADidStartBlock) {
        guard let delegate = base.delegate as? CAAnimationDelegateMediator else {
            let delegateMediator = CAAnimationDelegateMediator()
            delegateMediator.startBlock = block
            base.delegate = delegateMediator // retain
            return
        }
        delegate.startBlock = block
    }
    
    /// ReerKit: CAAnimation wrapper to avoid circular references.
    ///
    /// - Parameters:
    ///   - block: call back when animation stop.
    func animationDidStop(_ block: @escaping RECADidStopBlock) {
        guard let delegate = base.delegate as? CAAnimationDelegateMediator else {
            let delegateMediator = CAAnimationDelegateMediator()
            delegateMediator.stopBlock = block
            base.delegate = delegateMediator // retain
            return
        }
        delegate.stopBlock = block
    }
}

#endif
