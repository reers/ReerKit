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

#if os(iOS)
import UIKit

// MARK: - Methods

public extension Reer where Base: UIRefreshControl {
    /// ReerKit: Programmatically begin refresh control inside of UITableView.
    ///
    /// - Parameters:
    ///   - tableView: UITableView instance, inside which the refresh control is contained.
    ///   - animated: Boolean, indicates that is the content offset changing should be animated or not.
    ///   - sendAction: Boolean, indicates that should it fire sendActions method for valueChanged UIControlEvents.
    func beginRefreshing(in tableView: UITableView, animated: Bool, sendAction: Bool = false) {
        assert(base.superview == tableView, "Refresh control does not belong to the receiving table view")

        base.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -base.frame.height)
        tableView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            base.sendActions(for: .valueChanged)
        }
    }

    /// ReerKit: Programmatically begin refresh control inside of UIScrollView.
    ///
    /// - Parameters:
    ///   - animated: Boolean, indicates that is the content offset changing should be animated or not.
    ///   - sendAction: Boolean, indicates that should it fire sendActions method for valueChanged UIControlEvents.
    func beginRefreshing(animated: Bool, sendAction: Bool = false) {
        guard let scrollView = base.superview as? UIScrollView else {
            assert(false, "Refresh control does not belong to a scroll view")
            return
        }

        base.beginRefreshing()
        let offsetPoint = CGPoint(x: 0, y: -base.frame.height)
        scrollView.setContentOffset(offsetPoint, animated: animated)

        if sendAction {
            base.sendActions(for: .valueChanged)
        }
    }
}

#endif
