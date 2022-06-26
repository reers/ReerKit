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

#if canImport(UIKit)
import UIKit

// MARK: - Frame

public extension ReerKitWrapper where Base: UIView {
    
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

public extension ReerKitWrapper where Base: UIView {
    
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

extension ReerKitWrapper where Base: UIView {
    
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
}

// MARK: - Method

public extension ReerKitWrapper where Base: UIView {
    
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
    func ancestorView(matching condition: (UIView) -> Bool) -> UIView? {
        guard let superview = base.superview else { return nil }
        if condition(superview) {
            return superview
        }
        return superview.re.ancestorView(matching: condition)
    }
    
    /// ReerKit: Search all superviews until a view with this class is found.
    ///
    /// - Parameter name: type of the view to search.
    func ancestorView<T: UIView>(ofType _: T.Type) -> T? {
        guard let superview = base.superview else { return nil }
        if superview is T {
            return superview as? T
        }
        return superview.re.ancestorView(ofType: T.self)
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
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
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
}
#endif
