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

public extension Reer where Base: UICollectionView {
    /// ReerKit: Index path of last item in collectionView.
    var indexPathOfLastItem: IndexPath? {
        return indexPathOfLastItem(inSection: lastSection)
    }
    
    /// ReerKit: Index of last section in collectionView.
    var lastSection: Int {
        return base.numberOfSections > 0 ? base.numberOfSections - 1 : 0
    }
    
    /// ReerKit: Number of all items in all sections of collectionView.
    ///
    /// - Returns: The count of all rows in the collectionView.
    func numberOfItems() -> Int {
        var section = 0
        var itemsCount = 0
        while section < base.numberOfSections {
            itemsCount += base.numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }

    /// ReerKit: IndexPath for last item in section.
    ///
    /// - Parameter section: section to get last item in.
    /// - Returns: optional last indexPath for last item in section (if applicable).
    func indexPathOfLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard section < base.numberOfSections else {
            return nil
        }
        guard base.numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: base.numberOfItems(inSection: section) - 1, section: section)
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

    /// ReerKit: Dequeue reusable UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - name: UICollectionViewCell type.
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionViewCell object with associated class name.
    func dequeueReusableCell<T: UICollectionViewCell>(_ name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = base.dequeueReusableCell(
            withReuseIdentifier: String(describing: name),
            for: indexPath
        ) as? T else {
            fatalError(
                "Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }
        return cell
    }

    /// ReerKit: Dequeue reusable UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionReusableView object with associated class name.
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String, withClass name: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = base.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: name),
            for: indexPath
        ) as? T else {
            fatalError(
                "Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }
        return cell
    }

    /// ReerKit: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
        base.register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    /// ReerKit: Register UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the collectionView cell.
    ///   - name: UICollectionViewCell type.
    func register<T: UICollectionViewCell>(nib: UINib?, forCellWithClass name: T.Type) {
        base.register(nib, forCellWithReuseIdentifier: String(describing: name))
    }

    /// ReerKit: Register UICollectionViewCell using class name.
    ///
    /// - Parameter name: UICollectionViewCell type.
    func register<T: UICollectionViewCell>(cell name: T.Type) {
        base.register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    /// ReerKit: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the reusable view.
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    func register<T: UICollectionReusableView>(
        nib: UINib?, forSupplementaryViewOfKind kind: String,
        withClass name: T.Type
    ) {
        base.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }

    /// ReerKit: Register UICollectionViewCell with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and cell class has the same name.
    ///
    /// - Parameters:
    ///   - name: UICollectionViewCell type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    func register<T: UICollectionViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        base.register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }

    /// ReerKit: Safely scroll to possibly invalid IndexPath.
    ///
    /// - Parameters:
    ///   - indexPath: Target IndexPath to scroll to.
    ///   - scrollPosition: Scroll position.
    ///   - animated: Whether to animate or not.
    func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item >= 0,
              indexPath.section >= 0,
              indexPath.section < base.numberOfSections,
              indexPath.item < base.numberOfItems(inSection: indexPath.section)
        else {
            return
        }
        base.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }

    /// ReerKit: Check whether IndexPath is valid within the CollectionView.
    ///
    /// - Parameter indexPath: An IndexPath to check.
    /// - Returns: Boolean value for valid or invalid IndexPath.
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0
            && indexPath.item >= 0
            && indexPath.section < base.numberOfSections
            && indexPath.item < base.numberOfItems(inSection: indexPath.section)
    }
}

#endif
