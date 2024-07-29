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

#if canImport(SwiftUI)
import SwiftUI
#endif

#if canImport(CoreImage)
import CoreImage
#endif

// MARK: - Frame

public extension Reer where Base: UIView {
    
    /// ReerKit: Shortcut for frame.origin.x
    var x: CGFloat {
        get { return base.frame.origin.x }
        set {
            var frame = base.frame
            frame.origin.x = newValue
            base.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.y
    var y: CGFloat {
        get { return base.frame.origin.y }
        set {
            var frame = base.frame
            frame.origin.y = newValue
            base.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.size.width
    var width: CGFloat {
        get { return base.frame.size.width }
        set {
            var frame = base.frame
            frame.size.width = newValue
            base.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.size.height
    var height: CGFloat {
        get { return base.frame.size.height }
        set {
            var frame = base.frame
            frame.size.height = newValue
            base.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.x
    var left: CGFloat {
        get { return base.frame.origin.x }
        set {
            var frame = base.frame
            frame.origin.x = newValue
            base.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.x + frame.size.width
    var right: CGFloat {
        get { return base.frame.origin.x + base.frame.size.width }
        set {
            var frame = base.frame
            frame.origin.x = newValue - frame.size.width
            base.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.y
    var top: CGFloat {
        get { return base.frame.origin.y }
        set {
            var frame = base.frame
            frame.origin.y = newValue
            base.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.y + frame.size.height
    var bottom: CGFloat {
        get { return base.frame.origin.y + base.frame.size.height }
        set {
            var frame = base.frame
            frame.origin.y = newValue - frame.size.height
            base.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for center.x
    var centerX: CGFloat {
        get { return base.center.x }
        set { base.center = CGPoint.init(x: newValue, y: base.center.y) }
    }
    
    /// ReerKit: Shortcut for center.y
    var centerY: CGFloat {
        get { return base.center.y }
        set { base.center = CGPoint.init(x: base.center.x, y: newValue) }
    }
    
    /// ReerKit: Shortcut for frame.origin
    var origin: CGPoint {
        get { return base.frame.origin }
        set {
            var frame = base.frame
            frame.origin = newValue
            base.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.size
    var size: CGSize {
        get { return base.frame.size }
        set {
            var frame = base.frame
            frame.size = newValue
            base.frame = frame
        }
    }
}

// MARK: - CALayer Bridge

public extension Reer where Base: UIView {
    
    /// ReerKit: Border color of view.
    var borderColor: UIColor? {
        get {
            guard let color = base.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { base.layer.borderColor = newValue?.cgColor }
    }
    
    /// ReerKit: Border width of view.
    var borderWidth: CGFloat {
        get { return base.layer.borderWidth }
        set { base.layer.borderWidth = newValue }
    }
    
    /// ReerKit: Corner radius of view.
    var cornerRadius: CGFloat {
        get { return base.layer.cornerRadius }
        set {
            base.layer.masksToBounds = true
            base.layer.cornerRadius = Swift.abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    /// ReerKit: Shadow color of view.
    var shadowColor: UIColor? {
        get {
            guard let color = base.layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { base.layer.shadowColor = newValue?.cgColor }
    }
    
    /// ReerKit: Shadow offset of view.
    var shadowOffset: CGSize {
        get { return base.layer.shadowOffset }
        set { base.layer.shadowOffset = newValue }
    }
    
    /// ReerKit: Shadow opacity of view.
    var shadowOpacity: Float {
        get { return base.layer.shadowOpacity }
        set { base.layer.shadowOpacity = newValue }
    }
    
    /// ReerKit: Shadow radius of view.
    var shadowRadius: CGFloat {
        get { return base.layer.shadowRadius }
        set { base.layer.shadowRadius = newValue }
    }
    
    /// ReerKit: Shadow path of view.
    var shadowPath: UIBezierPath? {
        get {
            guard let cgPath = base.layer.shadowPath else { return nil }
            return UIBezierPath(cgPath: cgPath)
        }
        set { base.layer.shadowPath = newValue?.cgPath }
    }
}

// MARK: - Properties

public extension Reer where Base: UIView {
    
    /// ReerKit: Create a snapshot image of the complete view hierarchy.
    var snapshotImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// ReerKit: Find the first responder in its subviews recursively.
    var firstResponder: UIView? {
        var views: [UIView] = [base]
        var index = 0
        while index < views.count {
            let view = views[index]
            if view.isFirstResponder { return view }
            views += view.subviews
            index += 1
        }
        return nil
    }
    
    /// ReerKit: Get view's ViewController that belongs to.
    var viewController: UIViewController? {
        var nextResponder: UIResponder? = base.next
        while nextResponder != nil {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }
    
    #if canImport(CoreImage)
    var isGrayModeEnabled: Bool {
        get {
            return base.re.associatedValue(forKey: AssociationKey(#function as StaticString), default: false)
        }
        set {
            if newValue {
                // CAFilter
                let clsName = String("retliFAC".reversed())
                // colorSaturate
                var filterName: NSObjectProtocol = String("etarutaSroloc".reversed()) as NSObjectProtocol
                // inputAmount
                let keyPath = String("tnuomAtupni".reversed())
                let cls: AnyClass? = NSClassFromString(clsName)
                let sel = NSSelectorFromString("filterWithName:")
                if let cls, let sig = Invocation.classMethodSignatureForSelector(sel, of: cls) {
                    let invocation = Invocation(signature: sig)
                    invocation.setSelector(sel)
                    invocation.setArgument(&filterName, atIndex: 2)
                    invocation.retainArguments()
                    invocation.invoke(withTarget: cls)
                    var ret: Any = NSObject()
                    invocation.getReturnValue(&ret)
                    if let filter = ret as? NSObject {
                        filter.setValue(0, forKey: keyPath)
                        base.layer.filters = [filter]
                        base.re.setAssociatedValue(true, forKey: AssociationKey(#function as StaticString))
                    }
                }
            } else {
                base.layer.filters = nil
                base.re.setAssociatedValue(false, forKey: AssociationKey(#function as StaticString))
            }
        }
    }
    #endif
}

// MARK: - Method

public extension Reer where Base: UIView {
    
    /// ReerKit: Create a snapshot image of the complete view hierarchy.
    /// It's faster than `snapshotImage`, but may cause screen updates.
    ///
    /// - Parameter afterUpdates: A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated. Specify the value false if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes.
    /// - Returns: a snapshot image of view
    func snapshot(afterScreenUpdates afterUpdates: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        defer { UIGraphicsEndImageContext() }
        base.drawHierarchy(in: base.bounds, afterScreenUpdates: afterUpdates)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// ReerKit: Pick the color at a point of the view.
    /// It will return nil if the point is out of bounds.
    func color(at point: CGPoint) -> UIColor? {
        guard base.bounds.contains(point) else { return nil }
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) {
            context.translateBy(x: -point.x, y: -point.y)
            base.layer.render(in: context)
            return UIColor(
                red: CGFloat(pixel[0]) / 255.0,
                green: CGFloat(pixel[1]) / 255.0,
                blue: CGFloat(pixel[2]) / 255.0,
                alpha: CGFloat(pixel[3]) / 255.0
            )
        }
        return nil
    }
    
    /// ReerKit: Add array of views to the view.
    ///
    /// - Parameter subviews: array of subviews to add to view.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { base.addSubview($0) }
    }
    
    /// ReerKit: Remove all subviews
    func removeAllSubviews() {
        base.subviews.forEach { $0.removeFromSuperview() }
    }
    
    /// ReerKit: Returns all the subviews of a given type.
    ///
    /// - Parameters:
    ///   - ofType: Class of the view to search.
    ///   - recursive: Whether to find recursively in the view hierarchy.
    /// - Returns: All subviews with a specified type.
    func subviews<T>(ofType _: T.Type, recursive: Bool = false) -> [T] {
        var views: [T] = []
        for subview in base.subviews {
            if let view = subview as? T {
                views.append(view)
            } else if recursive && !subview.subviews.isEmpty {
                views += subview.re.subviews(ofType: T.self, recursive: true)
            }
        }
        return views
    }
    
    /// ReerKit: Returns the first subview of a given type.
    ///
    /// - Parameters:
    ///   - ofType: Class of the view to search.
    ///   - recursive: Whether to find it recursively in the view hierarchy.
    /// - Returns: All subviews with a specified type.
    func firstSubview<T>(ofType _: T.Type, recursive: Bool = false) -> T? {
        for subview in base.subviews {
            if let view = subview as? T {
                return view
            } else if recursive && !subview.subviews.isEmpty {
                return subview.re.firstSubview(ofType: T.self, recursive: true)
            }
        }
        return nil
    }
    
    /// ReerKit: Return all the subviews matching the condition.
    /// - Parameters:
    ///   - condition: condition to evaluate each subview against.
    ///   - recursive: Whether to find it recursively in the view hierarchy.
    /// - Returns: All subviews that matching the condition.
    func subviews(matching condition: (UIView) -> Bool, recursive: Bool = false) -> [UIView] {
        var views: [UIView] = []
        for subview in base.subviews {
            if condition(subview) {
                views.append(subview)
            } else if recursive && !subview.subviews.isEmpty {
                views += subview.re.subviews(matching: condition, recursive: true)
            }
        }
        return views
    }
    
    /// ReerKit: Return the first subview matching the condition.
    /// - Parameters:
    ///   - condition: condition to evaluate each subview against.
    ///   - recursive: Whether to find it recursively in the view hierarchy.
    /// - Returns: The first subview that matching the condition.
    func firstSubview(matching condition: (UIView) -> Bool, recursive: Bool = false) -> UIView? {
        for subview in base.subviews {
            if condition(subview) {
                return subview
            } else if recursive && !subview.subviews.isEmpty {
                return subview.re.firstSubview(matching: condition, recursive: true)
            }
        }
        return nil
    }
    
    /// ReerKit: Search all superviews until a view with the condition is found.
    ///
    /// - Parameter predicate: predicate to evaluate on superviews.
    func superview(matching condition: (UIView) -> Bool) -> UIView? {
        guard let superview = base.superview else { return nil }
        if condition(superview) {
            return superview
        }
        return superview.re.superview(matching: condition)
    }
    
    /// ReerKit: Search all superviews until a view with this class is found.
    ///
    /// - Parameter name: type of the view to search.
    func superview<T: UIView>(ofType _: T.Type) -> T? {
        guard let superview = base.superview else { return nil }
        if superview is T {
            return superview as? T
        }
        return superview.re.superview(ofType: T.self)
    }
    
    /// ReerKit: Converts a point from the receiver's coordinate system to that of the specified view or window.
    ///
    /// - Parameters:
    ///   - point: A point specified in the local coordinate system (bounds) of the receiver.
    ///   - view: The view or window into whose coordinate system point is to be converted.
    ///           If view is nil, this method instead converts to window base coordinates.
    /// - Returns: The point converted to the coordinate system of view.
    func convert(point: CGPoint, toViewOrWindow view: UIView?) -> CGPoint {
        guard let view = view else {
            if let window = base as? UIWindow {
                return window.convert(point, to: nil)
            } else {
                return base.convert(point, to: nil)
            }
        }
        var point = point
        let from = base is UIWindow ? (base as? UIWindow) : base.window
        let to = view is UIWindow ? (view as? UIWindow) : view.window
        if (from == nil || to == nil) || (from == to) {
            return base.convert(point, to: view)
        }
        point = base.convert(point, to: from!)
        point = to!.convert(point, from: from!)
        point = view.convert(point, from: to!)
        return point
    }
    
    /// ReerKit: Converts a point from the coordinate system of a given view or window to that of the receiver.
    ///
    /// - Parameters:
    ///   - point: A point specified in the local coordinate system (bounds) of view.
    ///   - view: The view or window with point in its coordinate system.
    ///           If view is nil, this method instead converts from window base coordinates.
    /// - Returns: The point converted to the local coordinate system (bounds) of the receiver.
    func convert(point: CGPoint, fromViewOrWindow view: UIView?) -> CGPoint {
        guard let view = view else {
            if let window = base as? UIWindow {
                return window.convert(point, from: nil)
            } else {
                return base.convert(point, from: nil)
            }
        }
        var point = point
        let from = view is UIWindow ? (view as? UIWindow) : view.window
        let to = base is UIWindow ? (base as? UIWindow) : base.window
        if (from == nil || to == nil) || (from == to) {
            return base.convert(point, from: view)
        }
        point = from!.convert(point, from: view)
        point = to!.convert(point, from: from!)
        point = base.convert(point, from: view)
        return point
    }
    
    /// ReerKit: Converts a rectangle from the receiver's coordinate system to that of another view or window.
    ///
    /// - Parameters:
    ///   - rect: A rectangle specified in the local coordinate system (bounds) of the receiver.
    ///   - view: The view or window that is the target of the conversion operation.
    ///           If view is nil, this method instead converts to window base coordinates.
    /// - Returns: The converted rectangle.
    func convert(rect: CGRect, toViewOrWindow view: UIView?) -> CGRect {
        guard let view = view else {
            if let window = base as? UIWindow {
                return window.convert(rect, to: nil)
            } else {
                return base.convert(rect, to: nil)
            }
        }
        var rect = rect
        let from = base is UIWindow ? (base as? UIWindow) : base.window
        let to = view is UIWindow ? (view as? UIWindow) : view.window
        if (from == nil || to == nil) || (from == to) {
            return base.convert(rect, to: view)
        }
        rect = base.convert(rect, to: from!)
        rect = to!.convert(rect, from: from!)
        rect = view.convert(rect, from: to!)
        return rect
    }
    
    /// ReerKit: Converts a rectangle from the coordinate system of another view or window to that of the receiver.
    ///
    /// - Parameters:
    ///   - rect: A rectangle specified in the local coordinate system (bounds) of view.
    ///   - view: The view or window with rect in its coordinate system.
    ///           If view is nil, this method instead converts from window base coordinates.
    /// - Returns: The converted rectangle.
    func convert(rect: CGRect, fromViewOrWindow view: UIView?) -> CGRect {
        guard let view = view else {
            if let window = base as? UIWindow {
                return window.convert(rect, from: nil)
            } else {
                return base.convert(rect, from: nil)
            }
        }
        var rect = rect
        let from = view is UIWindow ? (view as? UIWindow) : view.window
        let to = base is UIWindow ? (base as? UIWindow) : base.window
        if (from == nil || to == nil) || (from == to) {
            return base.convert(rect, from: view)
        }
        rect = from!.convert(rect, from: view)
        rect = to!.convert(rect, from: from!)
        rect = base.convert(rect, from: view)
        return rect
    }
    
    /// ReerKit: Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner = .allCorners, radius: CGFloat) {
        var caCorners = CACornerMask()
        if corners.contains(.allCorners) {
            caCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            if corners.contains(.topLeft) { caCorners.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { caCorners.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { caCorners.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { caCorners.insert(.layerMaxXMaxYCorner) }
        }
        base.layer.maskedCorners = caCorners
        base.layer.cornerRadius = radius
    }
    
    /// ReerKit: Set some or all corners radiuses of view with a continuous curve.
    /// It will make the rectangle to squircle, just like the iPhone/iPad...and all of Apple products's rounded corner.
    /// https://medium.com/minimal-notes/rounded-corners-in-the-apple-ecosystem-1b3f45e18fcc
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    @available(iOS 13.0, tvOS 13.0, *)
    func squircleRoundCorners(_ corners: UIRectCorner = .allCorners, radius: CGFloat) {
        var caCorners = CACornerMask()
        if corners.contains(.allCorners) {
            caCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            if corners.contains(.topLeft) { caCorners.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { caCorners.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { caCorners.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { caCorners.insert(.layerMaxXMaxYCorner) }
        }
        base.layer.maskedCorners = caCorners
        base.layer.cornerRadius = radius
        base.layer.cornerCurve = .continuous
    }
    
    /// ReerKit: Add shadow to view.
    ///
    /// - Note: This method only works with non-clear background color, or if the view has a `shadowPath` set.
    /// See parameter `opacity` for detail.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5). It will also be affected by the `alpha` of `backgroundColor`.
    func addShadow(
        ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5,
        path: CGPath? = nil
    ) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowOffset = offset
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.shadowPath = path
        base.layer.masksToBounds = false
    }
    
    /// ReerKit: Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if base.isHidden {
            base.isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            base.alpha = 1
        }, completion: completion)
    }

    /// ReerKit: Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if base.isHidden {
            base.isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            base.alpha = 0
        }, completion: completion)
    }
    
    /// ReerKit: Load view from nib.
    ///
    /// - Parameters:
    ///   - name: nib name.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: optional UIView (if applicable).
    static func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

    /// ReerKit: Load view of a certain type from nib
    ///
    /// - Parameters:
    ///   - withClass: UIView type.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: UIView
    static func loadFromNib<T: UIView>(withClass name: T.Type, bundle: Bundle? = nil) -> T {
        let named = String(describing: name)
        guard let view = UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? T else {
            fatalError("First element in xib file \(named) is not of type \(named)")
        }
        return view
    }
    
    /// ReerKit: Remove all gesture recognizers from view.
    func removeGestureRecognizers() {
        base.gestureRecognizers?.forEach(base.removeGestureRecognizer)
    }

    /// ReerKit: Attaches gesture recognizers to the view. Attaching gesture recognizers to a view defines the scope of the represented gesture, causing it to receive touches hit-tested to that view and all of its subviews. The view establishes a strong reference to the gesture recognizers.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be added to the view.
    func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            base.addGestureRecognizer(recognizer)
        }
    }

    /// ReerKit: Detaches gesture recognizers from the receiving view. This method releases gestureRecognizers in addition to detaching them from the view.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be removed from the view.
    func removeGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            base.removeGestureRecognizer(recognizer)
        }
    }
}

// MARK: - Layout

public extension Reer where Base: UIView {
    /// ReerKit: Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, macCatalyst 13.0, tvOS 10.0, *) {
            return base.effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }
    
    /// ReerKit: Add Visual Format constraints.
    ///
    /// - Parameters:
    ///   - withFormat: visual Format language.
    ///   - views: array of views which will be accessed starting with index 0 (example: [v0], [v1], [v2]..).
    func addConstraints(withFormat: String, views: UIView...) {
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        base.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: withFormat,
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: viewsDictionary))
    }

    /// ReerKit: Anchor all sides of the view into it's superview.
    func fillToSuperview() {
        base.translatesAutoresizingMaskIntoConstraints = false
        if let superview = base.superview {
            let left = base.leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = base.rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = base.topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = base.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }

    /// ReerKit: Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    ///
    /// - Parameters:
    ///   - top: current view's top anchor will be anchored into the specified anchor.
    ///   - left: current view's left anchor will be anchored into the specified anchor.
    ///   - bottom: current view's bottom anchor will be anchored into the specified anchor.
    ///   - right: current view's right anchor will be anchored into the specified anchor.
    ///   - topConstant: current view's top anchor margin.
    ///   - leftConstant: current view's left anchor margin.
    ///   - bottomConstant: current view's bottom anchor margin.
    ///   - rightConstant: current view's right anchor margin.
    ///   - widthConstant: current view's width.
    ///   - heightConstant: current view's height.
    /// - Returns: array of newly added constraints (if applicable).
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leftConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        rightConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0
    ) -> [NSLayoutConstraint] {
        base.translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top = top {
            anchors.append(base.topAnchor.constraint(equalTo: top, constant: topConstant))
        }

        if let left = left {
            anchors.append(base.leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }

        if let bottom = bottom {
            anchors.append(base.bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }

        if let right = right {
            anchors.append(base.rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }

        if widthConstant > 0 {
            anchors.append(base.widthAnchor.constraint(equalToConstant: widthConstant))
        }

        if heightConstant > 0 {
            anchors.append(base.heightAnchor.constraint(equalToConstant: heightConstant))
        }

        anchors.forEach { $0.isActive = true }

        return anchors
    }

    /// ReerKit: Anchor center X into current view's superview with a constant margin value.
    ///
    /// - Parameter constant: constant of the anchor constraint (default is 0).
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        base.translatesAutoresizingMaskIntoConstraints = false
        if let anchor = base.superview?.centerXAnchor {
            base.centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /// ReerKit: Anchor center Y into current view's superview with a constant margin value.
    ///
    /// - Parameter withConstant: constant of the anchor constraint (default is 0).
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        base.translatesAutoresizingMaskIntoConstraints = false
        if let anchor = base.superview?.centerYAnchor {
            base.centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /// ReerKit: Anchor center X and Y into current view's superview.
    func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    /// ReerKit: Search constraints until we find one for the given view
    /// and attribute. This will enumerate ancestors since constraints are
    /// always added to the common ancestor.
    ///
    /// - Parameter attribute: the attribute to find.
    /// - Parameter at: the view to find.
    /// - Returns: matching constraint.
    func findConstraint(attribute: NSLayoutConstraint.Attribute, for view: UIView) -> NSLayoutConstraint? {
        let constraint = base.constraints.first {
            ($0.firstAttribute == attribute && $0.firstItem as? UIView == view) ||
                ($0.secondAttribute == attribute && $0.secondItem as? UIView == view)
        }
        return constraint ?? base.superview?.re.findConstraint(attribute: attribute, for: view)
    }

    /// ReerKit: First width constraint for this view.
    var widthConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .width, for: base)
    }

    /// ReerKit: First height constraint for this view.
    var heightConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .height, for: base)
    }

    /// ReerKit: First leading constraint for this view.
    var leadingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .leading, for: base)
    }

    /// ReerKit: First trailing constraint for this view.
    var trailingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .trailing, for: base)
    }

    /// ReerKit: First top constraint for this view.
    var topConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .top, for: base)
    }

    /// ReerKit: First bottom constraint for this view.
    var bottomConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .bottom, for: base)
    }
}

#if canImport(SwiftUI)

@available(iOS 13.0, tvOS 13.0, *)
public extension Reer where Base: UIView {
    
    /// ReerKit: Adds a SwiftUI view to the end of the receiver’s list of subviews.
    /// - Parameter view: The SwiftUI view to be added. After being added, this view appears on top of any other subviews.
    /// - Returns: A UIKit view that represent a SwiftUI view hierarchy.
    func addSwiftUIView(_ view: some View) -> UIView {
        let childVC = UIHostingController(rootView: view)
        base.addSubview(childVC.view)
        return childVC.view
    }
    
    /// ReerKit: Inserts a SwiftUI at the specified index.
    /// - Parameters:
    ///   - view: The SwiftUI view to insert.
    ///   - index: The index in the array of the subviews property at which to insert the view. Subview indices start at 0 and cannot be greater than the number of subviews.
    /// - Returns: A UIKit view that represent a SwiftUI view hierarchy.
    func insertSwiftUIView(_ view: some View, at index: Int) -> UIView {
        let childVC = UIHostingController(rootView: view)
        base.insertSubview(childVC.view, at: index)
        return childVC.view
    }
    
    /// ReerKit: Inserts a SwiftUI view below another view in the view hierarchy.
    /// - Parameters:
    ///   - view: The SwiftUI view to insert below another view. It’s removed from its superview if it’s not a sibling of siblingSubview.
    ///   - siblingSubview: The sibling view that will be above the inserted view.
    /// - Returns: A UIKit view that represent a SwiftUI view hierarchy.
    func insertSwiftUIView(_ view: some View, belowSubview siblingSubview: UIView) -> UIView {
        let childVC = UIHostingController(rootView: view)
        base.insertSubview(childVC.view, belowSubview: siblingSubview)
        return childVC.view
    }
    
    /// ReerKit: Inserts a view above another view in the view hierarchy.
    /// - Parameters:
    ///   - view: The SwiftUI view to insert. It’s removed from its superview if it’s not a sibling of siblingSubview.
    ///   - siblingSubview: The sibling view that will be behind the inserted view.
    /// - Returns: A UIKit view that represent a SwiftUI view hierarchy.
    func insertSwiftUIView(_ view: some View, aboveSubview siblingSubview: UIView) -> UIView {
        let childVC = UIHostingController(rootView: view)
        base.insertSubview(childVC.view, aboveSubview: siblingSubview)
        return childVC.view
    }
}

#endif

#endif
