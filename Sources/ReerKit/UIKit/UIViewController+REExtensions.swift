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

public extension Reer where Base: UIViewController {
    
    /// ReerKit: Check if ViewController is onscreen and not hidden.
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return base.isViewLoaded && base.view.window != nil
    }
    
    /// ReerKit: Instantiate UIViewController from storyboard.
    ///
    /// - Parameters:
    ///   - storyboard: Name of the storyboard where the UIViewController is located.
    ///   - bundle: Bundle in which storyboard is located.
    ///   - identifier: UIViewController's storyboard identifier.
    /// - Returns: Custom UIViewController instantiated from storyboard.
    static func instantiate(from storyboard: String = "Main", bundle: Bundle? = nil, identifier: String? = nil) -> Base {
        let viewControllerIdentifier = identifier ?? String(describing: Base.self)
        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        guard let viewController = storyboard
            .instantiateViewController(withIdentifier: viewControllerIdentifier) as? Base else {
            preconditionFailure(
                "Unable to instantiate view controller with identifier \(viewControllerIdentifier) as type \(type(of: Base.self))")
        }
        return viewController
    }

    /// ReerKit: Assign as listener to notification.
    ///
    /// - Parameters:
    ///   - name: notification name.
    ///   - selector: selector to run with notified.
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(base, selector: selector, name: name, object: nil)
    }

    /// ReerKit: Unassign as listener to notification.
    ///
    /// - Parameter name: notification name.
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(base, name: name, object: nil)
    }

    /// ReerKit: Unassign as listener from all notifications.
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(base)
    }

    /// ReerKit: Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert.
    ///
    /// - Parameters:
    ///   - title: title of the alert.
    ///   - message: message/body of the alert.
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this parameter is nil.
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted.
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument.
    /// - Returns: UIAlertController object (discardable).
    @discardableResult
    func showAlert(
        title: String?,
        message: String?,
        buttonTitles: [String]? = nil,
        highlightedButtonIndex: Int? = nil,
        completion: ((Int) -> Void)? = nil
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        base.present(alertController, animated: true, completion: nil)
        return alertController
    }

    /// ReerKit: Helper method to add a UIViewController as a childViewController.
    ///
    /// - Parameters:
    ///   - child: the view controller to add as a child.
    ///   - containerView: the containerView for the child viewController's root view.
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        base.addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: base)
    }

    /// ReerKit: Helper method to remove a UIViewController from its parent.
    func removeViewAndControllerFromParentViewController() {
        guard base.parent != nil else { return }

        base.willMove(toParent: nil)
        base.removeFromParent()
        base.view.removeFromSuperview()
    }
    
    /// ReerKit: Helper method for a UIViewController to close itself.
    func closeSelf(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController = base.navigationController, navigationController.viewControllers.count > 1 {
            navigationController.re.popViewController(animated: animated, completion)
        } else if let presentingViewController = base.presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: completion)
        }
    }

    #if os(iOS)
    /// ReerKit: Helper method to present a UIViewController as a popover.
    ///
    /// - Parameters:
    ///   - popoverContent: the view controller to add as a popover.
    ///   - sourcePoint: the point in which to anchor the popover.
    ///   - size: the size of the popover. Default uses the popover preferredContentSize.
    ///   - delegate: the popover's presentationController delegate. Default is nil.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - completion: The block to execute after the presentation finishes. Default is nil.
    func presentPopover(
        _ popoverContent: UIViewController,
        sourcePoint: CGPoint,
        size: CGSize? = nil,
        delegate: UIPopoverPresentationControllerDelegate? = nil,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        popoverContent.modalPresentationStyle = .popover

        if let size = size {
            popoverContent.preferredContentSize = size
        }

        if let popoverPresentationVC = popoverContent.popoverPresentationController {
            popoverPresentationVC.sourceView = base.view
            popoverPresentationVC.sourceRect = CGRect(origin: sourcePoint, size: .zero)
            popoverPresentationVC.delegate = delegate
        }

        base.present(popoverContent, animated: animated, completion: completion)
    }
    #endif
}

#endif
