//
//  Copyright © 2015 ibireme
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

#if canImport(UIKit) && canImport(ObjectiveC) && canImport(CoreFoundation) && !os(watchOS) && !os(tvOS) && !os(visionOS)
import UIKit
import ObjectiveC
import CoreFoundation

// MARK: - KeyboardObserver

/// The protocol defines the method you can use
/// to receive system keyboard change information.
public protocol KeyboardObserver: AnyObject {
    func keyboardChanged(with transition: KeyboardTransition)
}

// MARK: - KeyboardTransition

/// System keyboard transition information.
/// Use `convert(rect:toView:)` to convert frame to specified view.
public struct KeyboardTransition {
    public var toHidden: Bool
    public var toVisible: Bool
    public var fromFrame: CGRect
    public var toFrame: CGRect
    public var animationDuration: TimeInterval
    public var animationCurve: UIView.AnimationCurve
    public var animationOption: UIView.AnimationOptions
    
    fileprivate static var `default`: Self {
        return Self(
            toHidden: false,
            toVisible: false,
            fromFrame: .zero,
            toFrame: .zero,
            animationDuration: 0,
            animationCurve: .easeInOut,
            animationOption: .curveEaseInOut
        )
    }
}

// MARK: - KeyboardManager

/// A KeyboardManager object lets you get the system keyboard information,
/// and track the keyboard visible/frame/transition.
///
/// You should access this class in main thread and add observer before keyboard will show.
public final class KeyboardManager: NSObject {
    
    // MARK: - Properties
    
    private var observers: WeakSet<AnyObject> = []
    private var fromFrame = CGRect.zero
    private var toHidden = false
    private var fromOrientation = UIInterfaceOrientation.portrait
    private var notificationFromFrame = CGRect.zero
    private var notificationToFrame = CGRect.zero
    private var notificationDuration: TimeInterval = 0
    private var notificationCurve: UIView.AnimationCurve = .easeInOut
    private var hasNotification = false
    private var observedToFrame = CGRect.zero
    private var hasObservedChange = false
    private var lastIsNotification = false
    
    // MARK: - Init
    
    public static let shared = KeyboardManager()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardFrameWillChangeNotification(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        // for iPad
        if systemVersion >= 9 {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardFrameDidChangeNotification(_:)),
                name: UIResponder.keyboardDidChangeFrameNotification,
                object: nil
            )
        }
    }
    
    // MARK: - Public
    
    /// Get the keyboard window. nil if there's no keyboard window.
    public var keyboardWindow: UIWindow? {
        var window: UIWindow? = nil
        for window in UIApplication.re.windows {
            if let _ = getKeyboardViewFromWindow(window: window) {
                return window
            }
        }
        window = UIApplication.re.keyWindow
        if let _ = getKeyboardViewFromWindow(window: window) {
            return window
        }
        var keyboardWindows: [UIWindow] = []
        for window in UIApplication.re.windows {
            // Get the window
            let windowName = String(describing: type(of: window))
            if systemVersion < 16 {
                // UIRemoteKeyboardWindow
                if windowName.count == 22,
                   windowName.hasPrefix("UI"),
                   windowName.hasSuffix("RemoteKeyboardWindow") {
                    keyboardWindows.append(window)
                }
            } else {
                // UITextEffectsWindow
                if windowName.count == 19,
                   windowName.hasPrefix("UI"),
                   windowName.hasSuffix("TextEffectsWindow") {
                    keyboardWindows.append(window)
                }
            }
        }
        if keyboardWindows.count == 1 {
            return keyboardWindows.first
        }
        return nil
    }
    
    /// Get the keyboard view. nil if there's no keyboard view.
    public var keyboardView: UIView? {
        var window: UIWindow? = nil
        var view: UIView? = nil
        for window in UIApplication.re.windows {
            view = getKeyboardViewFromWindow(window: window)
            if view != nil { return view }
        }
        window = UIApplication.re.keyWindow
        view = getKeyboardViewFromWindow(window: window)
        if view != nil { return view }
        return nil
    }
    
    /// Whether the keyboard is visible.
    public var isKeyboardVisible: Bool {
        guard let window = keyboardWindow else { return false }
        guard let view = keyboardView else { return false }
        let rect = window.bounds.intersection(view.frame)
        if rect.isNull { return false }
        if rect.isInfinite { return false }
        return rect.width > 0 && rect.height > 0
    }
    
    /// Get the keyboard frame. CGRect.null if there's no keyboard view.
    /// Use convert(rect:toView:) to convert frame to specified view.
    public var keyboardFrame: CGRect {
        guard let keyboard = keyboardView else { return .null }
        var frame = CGRect.null
        if let window = keyboard.window {
            frame = window.convert(keyboard.frame, to: nil)
        } else {
            frame = keyboard.frame
        }
        return frame
    }
    
    /// Add an observer to manager to get keyboard change information.
    /// This method makes a weak reference to the observer.
    public func addObserver(_ observer: KeyboardObserver) {
        observers.add(observer)
    }
    
    /// Remove an observer from manager.
    /// No need to remove observer in `deinit` method, ``KeyboardManager`` will remove observer automatically.
    public func removeObserver(_ observer: KeyboardObserver) {
        observers.remove(observer)
    }
    
    public func convertRect(_ rect: CGRect, toView view: UIView?) -> CGRect {
        if rect.isNull || rect.isInfinite { return rect }
        var rect = rect
        guard let mainWindow = UIApplication.re.keyWindow ?? UIApplication.re.windows.first else {
            if let view = view {
                return view.convert(rect, from: nil)
            } else {
                return rect
            }
        }
        rect = mainWindow.convert(rect, from: nil)
        guard let view = view else { return mainWindow.convert(rect, to: nil) }
        if view == mainWindow { return rect }
        let toWindow = (view is UIWindow) ? (view as? UIWindow) : view.window
        if toWindow == nil { return mainWindow.convert(rect, to: view) }
        guard let toWindow = (view is UIWindow) ? (view as? UIWindow) : view.window else {
            return mainWindow.convert(rect, to: view)
        }
        if mainWindow == toWindow { return mainWindow.convert(rect, to: view) }
        // In a different window
        rect = mainWindow.convert(rect, to: mainWindow)
        rect = toWindow.convert(rect, from: mainWindow)
        rect = view.convert(rect, from: toWindow)
        return rect
    }
    
    // MARK: - Private
    
    private func initFrameObserver() {
        guard let view = keyboardView else { return }
        var observer = KeyboardViewFrameObserver.observer(forView: view)
        if observer == nil {
            observer = KeyboardViewFrameObserver()
            observer?.notifyBlock = { [weak self] keyboard in
                guard let self = self else { return }
                self.keyboardFrameChanged(view)
            }
            observer?.addToKeyboardView(view)
        }
    }
    
    @objc
    private func keyboardFrameWillChangeNotification(_ notif: Notification) {
        guard notif.name == UIResponder.keyboardWillChangeFrameNotification, let info = notif.userInfo else {
            return
        }
        initFrameObserver()
        guard let beforeValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
              let afterValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let curveNumber = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
              let durationNumber = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        else {
            return
        }
        let before = beforeValue.cgRectValue
        let after = afterValue.cgRectValue
        let curve = UIView.AnimationCurve(rawValue: curveNumber.intValue) ?? .easeInOut
        let duration = durationNumber.doubleValue
        // ignore zero end frame
        if after.size.width <= 0 && after.size.height <= 0 { return }
        notificationFromFrame = before
        notificationToFrame = after
        notificationCurve = curve
        notificationDuration = duration
        hasNotification = true
        lastIsNotification = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(notifyAllObservers), object: nil)
        if duration == 0 {
            perform(#selector(notifyAllObservers), with: nil, afterDelay: 0, inModes: [RunLoop.Mode.common])
        } else {
            notifyAllObservers()
        }
    }
    
    @objc
    private func keyboardFrameDidChangeNotification(_ notif: Notification) {
        guard notif.name == UIResponder.keyboardDidChangeFrameNotification, let info = notif.userInfo else {
            return
        }
        initFrameObserver()
        guard let afterValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let after = afterValue.cgRectValue
        // ignore zero end frame
        if after.size.width <= 0 && after.size.height <= 0 { return }
        notificationToFrame = after
        notificationCurve = .easeInOut
        notificationDuration = 0
        hasNotification = true
        lastIsNotification = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(notifyAllObservers), object: nil)
        perform(#selector(notifyAllObservers), with: nil, afterDelay: 0, inModes: [RunLoop.Mode.common])
    }
    
    private func keyboardFrameChanged(_ keyboard: UIView) {
        if keyboard != keyboardView { return }
        if let window = keyboard.window {
            observedToFrame = window.convert(keyboard.frame, to: nil)
        } else {
            observedToFrame = keyboard.frame
        }
        hasObservedChange = true
        lastIsNotification = false
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(notifyAllObservers), object: nil)
        perform(#selector(notifyAllObservers), with: nil, afterDelay: 0, inModes: [RunLoop.Mode.common])
    }
    
    @objc
    private func notifyAllObservers() {
        guard let keyboard = keyboardView,
              let window = keyboard.window ?? UIApplication.re.keyWindow ?? UIApplication.re.windows.first
        else {
            return
        }
        var trans = KeyboardTransition.default
        // from, first notify
        if fromFrame.size.width == 0 && fromFrame.size.height == 0 {
            fromFrame.size.width = window.bounds.size.width
            fromFrame.size.height = trans.toFrame.size.height
            fromFrame.origin.x = trans.toFrame.origin.x
            fromFrame.origin.y = window.bounds.size.height
        }
        trans.fromFrame = fromFrame
        trans.toHidden = toHidden
        // to
        if lastIsNotification || (hasObservedChange && observedToFrame.equalTo(notificationToFrame)) {
            trans.toFrame = notificationToFrame
            trans.animationDuration = notificationDuration
            trans.animationCurve = notificationCurve
            trans.animationOption = UIView.AnimationOptions(rawValue: UInt(notificationCurve.rawValue << 16))
        } else {
            trans.toFrame = observedToFrame
        }
        if trans.toFrame.size.width > 0 && trans.toFrame.size.height > 0 {
            let rect = window.bounds.intersection(trans.toFrame)
            if !rect.isNull && !rect.isEmpty {
                trans.toVisible = true
            }
        }
        if trans.toFrame != fromFrame {
            for observer in observers {
                (observer as? KeyboardObserver)?.keyboardChanged(with: trans)
            }
        }
        hasNotification = false
        hasObservedChange = false
        fromFrame = trans.toFrame
        toHidden = trans.toVisible
        fromOrientation = UIApplication.shared.statusBarOrientation
    }
    
    private func getKeyboardViewFromWindow(window: UIWindow?) -> UIView? {
        guard let window = window else { return nil }
        // Get the window
        let windowName = String(describing: type(of: window))
        if systemVersion < 16 {
            // UIRemoteKeyboardWindow
            guard windowName.count == 22,
                  windowName.hasPrefix("UI"),
                  windowName.hasSuffix("RemoteKeyboardWindow")
            else { return nil }
            return findUIInputSetHostViewInWindow(window)
        } else {
            // UITextEffectsWindow
            guard windowName.count == 19,
                  windowName.hasPrefix("UI"),
                  windowName.hasSuffix("TextEffectsWindow")
            else { return nil }
            return findUIInputSetHostViewInWindow(window)
        }
    }
    
    private func findUIInputSetHostViewInWindow(_ window: UIWindow) -> UIView? {
        // UIInputSetContainerView
        for view in window.subviews {
            let viewName = String(describing: type(of: view))
            if viewName.count != 23 { continue }
            if !viewName.hasPrefix("UI") { continue }
            if !viewName.hasSuffix("InputSetContainerView") { continue }
            // UIInputSetHostView
            for subView in view.subviews {
                let subViewName = String(describing: type(of: subView))
                if subViewName.count != 18 { continue }
                if !subViewName.hasPrefix("UI") { continue }
                if !subViewName.hasSuffix("InputSetHostView") { continue }
                return subView
            }
        }
        return nil
    }
    
    private let systemVersion = (UIDevice.current.systemVersion as NSString).floatValue
}

// MARK: - KeyboardViewFrameObserver

/// Observer for view's frame/bounds/center/transform
final fileprivate class KeyboardViewFrameObserver: NSObject {
    var notifyBlock: ((UIView) -> Void)?
    weak var keyboardView: UIView?
    private static let keyboardViewObserverKey = AssociationKey()
    
    var frameToken: NSKeyValueObservation?
    var centerToken: NSKeyValueObservation?
    var boundsToken: NSKeyValueObservation?
    var transformToken: NSKeyValueObservation?
    
    deinit {
        removeFrameObserver()
    }
    
    func addToKeyboardView(_ keyboardView: UIView) {
        if self.keyboardView == keyboardView { return }
        if let keyboardView = self.keyboardView {
            removeFrameObserver()
            keyboardView.re.setAssociatedValue(nil, forKey: Self.keyboardViewObserverKey)
        }
        self.keyboardView = keyboardView
        addFrameObserver()
        keyboardView.re.setAssociatedValue(self, forKey: Self.keyboardViewObserverKey)
    }
    
    static func observer(forView keyboardView: UIView) -> Self? {
        return keyboardView.re.associatedValue(forKey: Self.keyboardViewObserverKey)
    }
    
    func removeFrameObserver() {
        frameToken?.invalidate()
        centerToken?.invalidate()
        boundsToken?.invalidate()
        transformToken?.invalidate()
    }

    func addFrameObserver() {
        guard let keyboardView = keyboardView else { return }
        frameToken = keyboardView.observe(\.frame) { [weak self] view, change in
            self?.handle(change: change)
        }
        centerToken = keyboardView.observe(\.center) { [weak self] view, change in
            self?.handle(change: change)
        }
        boundsToken = keyboardView.observe(\.bounds) { [weak self] view, change in
            self?.handle(change: change)
        }
        transformToken = keyboardView.observe(\.transform) { [weak self] view, change in
            self?.handle(change: change)
        }
    }
    
    func handle<Value>(change: NSKeyValueObservedChange<Value>) {
        guard let keyboardView = keyboardView else { return }
        if change.isPrior { return }
        if change.kind != .setting { return }
        notifyBlock?(keyboardView)
    }
}
#endif
