//
//  UIView+REExtensions.swift
//  ReerKit
//
//  Created by phoenix on 2022/6/12.
//

#if canImport(UIKit)
import UIKit

// MARK: - Frame
public extension UIView {
    /// ReerKit: Shortcut for frame.origin.x
    var x: CGFloat {
        get { frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.y
    var y: CGFloat {
        get { frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.size.width
    var width: CGFloat {
        get { frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.size.height
    var height: CGFloat {
        get { frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.x
    var left: CGFloat {
        get { frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.x + frame.size.width
    var right: CGFloat {
        get { frame.origin.x + frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.y
    var top: CGFloat {
        get { frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.origin.y + frame.size.height
    var bottom: CGFloat {
        get { frame.origin.y + frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for center.x
    var centerX: CGFloat {
        get { center.x }
        set { center = CGPoint.init(x: newValue, y: center.y) }
    }
    
    /// ReerKit: Shortcut for center.y
    var centerY: CGFloat {
        get { center.y }
        set { center = CGPoint.init(x: center.x, y: newValue) }
    }
    
    /// ReerKit: Shortcut for frame.origin
    var origin: CGPoint {
        get { frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    /// ReerKit: Shortcut for frame.size
    var size: CGSize {
        get { frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
}
#endif
