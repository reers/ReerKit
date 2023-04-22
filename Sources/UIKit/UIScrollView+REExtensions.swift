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

public extension Reer where Base: UIScrollView {
    
    /// SwifterSwift: Takes a snapshot of an entire ScrollView.
    ///
    ///    AnySubclassOfUIScrollView().snapshot
    ///    UITableView().snapshot
    ///
    /// - Returns: Snapshot as UIImage for rendered ScrollView.
    var snapshot: UIImage? {
        // Original Source: https://gist.github.com/thestoics/1204051
        UIGraphicsBeginImageContextWithOptions(base.contentSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = base.frame
        base.frame = CGRect(origin: base.frame.origin, size: base.contentSize)
        base.layer.render(in: context)
        base.frame = previousFrame
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// SwifterSwift: The currently visible region of the scroll view.
    var visibleRect: CGRect {
        let contentWidth = base.contentSize.width - base.contentOffset.x
        let contentHeight = base.contentSize.height - base.contentOffset.y
        return CGRect(
            origin: base.contentOffset,
            size: CGSize(
                width: min(min(base.bounds.size.width, base.contentSize.width), contentWidth),
                height: min(min(base.bounds.size.height, base.contentSize.height), contentHeight)
            )
        )
    }
    
    /// SwifterSwift: Scroll to the top-most content offset.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make the transition immediate.
    func scrollToTop(animated: Bool = true) {
        base.setContentOffset(CGPoint(x: base.contentOffset.x, y: -base.contentInset.top), animated: animated)
    }

    /// SwifterSwift: Scroll to the left-most content offset.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make the transition immediate.
    func scrollToLeft(animated: Bool = true) {
        base.setContentOffset(CGPoint(x: -base.contentInset.left, y: base.contentOffset.y), animated: animated)
    }

    /// SwifterSwift: Scroll to the bottom-most content offset.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make the transition immediate.
    func scrollToBottom(animated: Bool = true) {
        base.setContentOffset(
            CGPoint(x: base.contentOffset.x, y: max(0, base.contentSize.height - base.bounds.height) + base.contentInset.bottom),
            animated: animated)
    }

    /// SwifterSwift: Scroll to the right-most content offset.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make the transition immediate.
    func scrollToRight(animated: Bool = true) {
        base.setContentOffset(
            CGPoint(x: max(0, base.contentSize.width - base.bounds.width) + base.contentInset.right, y: base.contentOffset.y),
            animated: animated)
    }

    /// SwifterSwift: Scroll up one page of the scroll view.
    /// If `isPagingEnabled` is `true`, the previous page location is used.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make the transition immediate.
    func scrollUp(animated: Bool = true) {
        let minY = -base.contentInset.top
        var y = max(minY, base.contentOffset.y - base.bounds.height)
        #if !os(tvOS)
        if base.isPagingEnabled,
           base.bounds.height != 0 {
            let page = max(0, ((y + base.contentInset.top) / base.bounds.height).rounded(.down))
            y = max(minY, page * base.bounds.height - base.contentInset.top)
        }
        #endif
        base.setContentOffset(CGPoint(x: base.contentOffset.x, y: y), animated: animated)
    }

    /// SwifterSwift: Scroll left one page of the scroll view.
    /// If `isPagingEnabled` is `true`, the previous page location is used.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make the transition immediate.
    func scrollLeft(animated: Bool = true) {
        let minX = -base.contentInset.left
        var x = max(minX, base.contentOffset.x - base.bounds.width)
        #if !os(tvOS)
        if base.isPagingEnabled,
           base.bounds.width != 0 {
            let page = ((x + base.contentInset.left) / base.bounds.width).rounded(.down)
            x = max(minX, page * base.bounds.width - base.contentInset.left)
        }
        #endif
        base.setContentOffset(CGPoint(x: x, y: base.contentOffset.y), animated: animated)
    }

    /// SwifterSwift: Scroll down one page of the scroll view.
    /// If `isPagingEnabled` is `true`, the next page location is used.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make the transition immediate.
    func scrollDown(animated: Bool = true) {
        let maxY = max(0, base.contentSize.height - base.bounds.height) + base.contentInset.bottom
        var y = min(maxY, base.contentOffset.y + base.bounds.height)
        #if !os(tvOS)
        if base.isPagingEnabled,
           base.bounds.height != 0 {
            let page = ((y + base.contentInset.top) / base.bounds.height).rounded(.down)
            y = min(maxY, page * base.bounds.height - base.contentInset.top)
        }
        #endif
        base.setContentOffset(CGPoint(x: base.contentOffset.x, y: y), animated: animated)
    }

    /// SwifterSwift: Scroll right one page of the scroll view.
    /// If `isPagingEnabled` is `true`, the next page location is used.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make the transition immediate.
    func scrollRight(animated: Bool = true) {
        let maxX = max(0, base.contentSize.width - base.bounds.width) + base.contentInset.right
        var x = min(maxX, base.contentOffset.x + base.bounds.width)
        #if !os(tvOS)
        if base.isPagingEnabled,
           base.bounds.width != 0 {
            let page = ((x + base.contentInset.left) / base.bounds.width).rounded(.down)
            x = min(maxX, page * base.bounds.width - base.contentInset.left)
        }
        #endif
        base.setContentOffset(CGPoint(x: x, y: base.contentOffset.y), animated: animated)
    }
}

#endif
