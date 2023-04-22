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

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Initializers

public extension UIStackView {
    /// SwifterSwift: Initialize an UIStackView with an array of UIView and common parameters.
    ///
    ///     let stackView = UIStackView(arrangedSubviews: [UIView(), UIView()], axis: .vertical)
    ///
    /// - Parameters:
    ///   - arrangedSubviews: The UIViews to add to the stack.
    ///   - axis: The axis along which the arranged views are laid out.
    ///   - spacing: The distance in points between the adjacent edges of the stack view’s arranged views (default: 0.0).
    ///   - alignment: The alignment of the arranged subviews perpendicular to the stack view’s axis (default: .fill).
    ///   - distribution: The distribution of the arranged views along the stack view’s axis (default: .fill).
    static func re(
        arrangedSubviews: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0.0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
        stack.distribution = distribution
        return stack
    }
}

public extension Reer where Base: UIStackView {
    /// SwifterSwift: Adds array of views to the end of the arrangedSubviews array.
    ///
    /// - Parameter views: views array.
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            base.addArrangedSubview(view)
        }
    }

    /// SwifterSwift: Removes all views in stack’s array of arranged subviews.
    func removeArrangedSubviews() {
        for view in base.arrangedSubviews {
            base.removeArrangedSubview(view)
        }
    }
    
    /// SwifterSwift: Exchanges two views of the arranged subviews.
    /// - Parameters:
    ///   - view1: first view to swap.
    ///   - view2: second view to swap.
    ///   - animated: set true to animate swap (default is true).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - delay: animation delay in seconds (default is 1 second).
    ///   - options: animation options (default is AnimationOptions.curveLinear).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func swap(
        _ view1: UIView,
        _ view2: UIView,
        animated: Bool = false,
        duration: TimeInterval = 0.25,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = .curveLinear,
        completion: ((Bool) -> Void)? = nil
    ) {
        func swapViews(_ view1: UIView, _ view2: UIView) {
            guard let view1Index = base.arrangedSubviews.firstIndex(of: view1),
                  let view2Index = base.arrangedSubviews.firstIndex(of: view2)
            else { return }
            base.removeArrangedSubview(view1)
            base.insertArrangedSubview(view1, at: view2Index)

            base.removeArrangedSubview(view2)
            base.insertArrangedSubview(view2, at: view1Index)
        }
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
                swapViews(view1, view2)
                base.layoutIfNeeded()
            }, completion: completion)
        } else {
            swapViews(view1, view2)
        }
    }
}

#endif

