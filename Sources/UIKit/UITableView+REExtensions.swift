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

public extension Reer where Base: UITableView {
    
   /// ReerKit: Index path of last row in tableView.
    var indexPathForLastRow: IndexPath? {
        guard let lastSection = lastSection else { return nil }
        return indexPathForLastRow(inSection: lastSection)
    }

   /// ReerKit: Index of last section in tableView.
    var lastSection: Int? {
        return base.numberOfSections > 0 ? base.numberOfSections - 1 : nil
    }
    
   /// ReerKit: Number of all rows in all sections of tableView.
    ///
    /// - Returns: The count of all rows in the tableView.
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < base.numberOfSections {
            rowCount += base.numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }

   /// ReerKit: IndexPath for last row in section.
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard base.numberOfSections > 0, section >= 0 else { return nil }
        guard base.numberOfRows(inSection: section) > 0 else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: base.numberOfRows(inSection: section) - 1, section: section)
    }

   /// ReerKit: Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            base.reloadData()
        }, completion: { _ in
            completion()
        })
    }

   /// ReerKit: Remove TableFooterView.
    func removeTableFooterView() {
        base.tableFooterView = nil
    }

   /// ReerKit: Remove TableHeaderView.
    func removeTableHeaderView() {
        base.tableHeaderView = nil
    }

   /// ReerKit: Dequeue reusable UITableViewCell using class name.
    ///
    /// - Parameter name: UITableViewCell type.
    /// - Returns: UITableViewCell object with associated class name.
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = base.dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

   /// ReerKit: Dequeue reusable UITableViewCell using class name for indexPath.
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    func dequeueReusableCell<T: UITableViewCell>(_ name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = base.dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                "Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }

   /// ReerKit: Dequeue reusable UITableViewHeaderFooterView using class name.
    ///
    /// - Parameter name: UITableViewHeaderFooterView type.
    /// - Returns: UITableViewHeaderFooterView object with associated class name.
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ name: T.Type) -> T {
        guard let headerFooterView = base.dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
        }
        return headerFooterView
    }

   /// ReerKit: Register UITableViewHeaderFooterView using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the header or footer view.
    ///   - name: UITableViewHeaderFooterView type.
    func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        base.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

   /// ReerKit: Register UITableViewHeaderFooterView using class name.
    ///
    /// - Parameter name: UITableViewHeaderFooterView type.
    func register<T: UITableViewHeaderFooterView>(headerFooterView name: T.Type) {
        base.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }

   /// ReerKit: Register UITableViewCell using class name.
    ///
    /// - Parameter name: UITableViewCell type.
    func register<T: UITableViewCell>(cell name: T.Type) {
        base.register(T.self, forCellReuseIdentifier: String(describing: name))
    }

   /// ReerKit: Register UITableViewCell using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the tableView cell.
    ///   - name: UITableViewCell type.
    func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        base.register(nib, forCellReuseIdentifier: String(describing: name))
    }

   /// ReerKit: Register UITableViewCell with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and cell class has the same name.
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        base.register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }

   /// ReerKit: Check whether IndexPath is valid within the tableView.
    ///
    /// - Parameter indexPath: An IndexPath to check.
    /// - Returns: Boolean value for valid or invalid IndexPath.
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.row >= 0 &&
        indexPath.section < base.numberOfSections &&
        indexPath.row < base.numberOfRows(inSection: indexPath.section)
    }

   /// ReerKit: Safely scroll to possibly invalid IndexPath.
    ///
    /// - Parameters:
    ///   - indexPath: Target IndexPath to scroll to.
    ///   - scrollPosition: Scroll position.
    ///   - animated: Whether to animate or not.
    func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < base.numberOfSections else { return }
        guard indexPath.row < base.numberOfRows(inSection: indexPath.section) else { return }
        base.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
}

#endif
