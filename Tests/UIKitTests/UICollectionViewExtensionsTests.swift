//
//  UICollectionViewExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/19.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

private final class TestCell: UICollectionViewCell {}

final class UICollectionViewExtensionsTests: XCTestCase {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let emptyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let flowLayoutCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 10, height: 10)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        let collection = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 10, height: 15),
            collectionViewLayout: layout)
        if #available(iOS 11, tvOS 11, *) {
            collection.insetsLayoutMarginsFromSafeArea = false
        }
        collection.contentInset = .zero
        return collection
    }()

    override func setUp() {
        super.setUp()

        collectionView.dataSource = self
        collectionView.reloadData()

        emptyCollectionView.dataSource = self
        emptyCollectionView.reloadData()

        flowLayoutCollectionView.dataSource = self
        flowLayoutCollectionView.reloadData()
    }

    func testIndexPathForLastRow() {
        XCTAssertEqual(collectionView.re.indexPathForLastItem, IndexPath(item: 0, section: 1))
    }

    func testLastSection() {
        XCTAssertEqual(collectionView.re.lastSection, 1)
        XCTAssertEqual(emptyCollectionView.re.lastSection, 0)
    }

    func testNumberOfRows() {
        XCTAssertEqual(collectionView.re.numberOfItems(), 5)
        XCTAssertEqual(emptyCollectionView.re.numberOfItems(), 0)
    }

    func testIndexPathForLastRowInSection() {
        XCTAssertNil(collectionView.re.indexPathForLastItem(inSection: -1))
        XCTAssertNil(collectionView.re.indexPathForLastItem(inSection: 2))
        XCTAssertEqual(collectionView.re.indexPathForLastItem(inSection: 0), IndexPath(item: 4, section: 0))
    }

    func testReloadData() {
        var completionCalled = false
        collectionView.re.reloadData {
            completionCalled = true
            XCTAssert(completionCalled)
        }
    }

    #if os(iOS)
    func testRegisterCellWithClass() {
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.re.register(cellWithClass: TestCell.self)
        let cell = collectionView.re.dequeueReusableCell(withClass: TestCell.self, for: indexPath)
        XCTAssertNotNil(cell)
    }
    #endif

    #if os(iOS)
    func testRegisterCellWithNibUsingClass() {
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.re.register(nibWithCellClass: UICollectionViewCell.self, at: UICollectionViewExtensionsTests.self)
        let cell = collectionView.re.dequeueReusableCell(withClass: UICollectionViewCell.self, for: indexPath)
        XCTAssertNotNil(cell)
    }
    #endif

    func testSafeScrollToIndexPath() {
        let validIndexPathTop = IndexPath(row: 0, section: 0)

        flowLayoutCollectionView.contentOffset = CGPoint(x: 0, y: 30)
        XCTAssertNotEqual(flowLayoutCollectionView.contentOffset, .zero)

        flowLayoutCollectionView.re.scrollToItem(at: validIndexPathTop, at: .top, animated: false)
        XCTAssertEqual(flowLayoutCollectionView.contentOffset, .zero)

        let validIndexPathBottom = IndexPath(row: 4, section: 0)

        let bottomOffset = CGPoint(
            x: 0,
            y: flowLayoutCollectionView.collectionViewLayout.collectionViewContentSize.height - flowLayoutCollectionView
                .bounds.size.height)

        flowLayoutCollectionView.contentOffset = CGPoint(x: 0, y: 30)
        XCTAssertNotEqual(flowLayoutCollectionView.contentOffset, bottomOffset)

        flowLayoutCollectionView.re.scrollToItem(at: validIndexPathBottom, at: .bottom, animated: false)

        XCTAssertEqual(bottomOffset.y, flowLayoutCollectionView.contentOffset.y)

        let invalidIndexPath = IndexPath(row: 213, section: 21)
        flowLayoutCollectionView.contentOffset = .zero

        flowLayoutCollectionView.re.scrollToItem(at: invalidIndexPath, at: .bottom, animated: false)
        XCTAssertEqual(flowLayoutCollectionView.contentOffset, .zero)

        let negativeIndexPath = IndexPath(item: -1, section: 0)

        flowLayoutCollectionView.re.scrollToItem(at: negativeIndexPath, at: .bottom, animated: false)
        XCTAssertEqual(flowLayoutCollectionView.contentOffset, .zero)
    }

    func testIsValidIndexPath() {
        let zeroIndexPath = IndexPath(item: 0, section: 0)
        let invalidIndexPath = IndexPath(item: 0, section: 3)
        let validIndexPath = IndexPath(item: 4, section: 0)
        let negativeIndexPath = IndexPath(item: -1, section: 0)

        XCTAssertFalse(emptyCollectionView.re.isValidIndexPath(zeroIndexPath))

        XCTAssertFalse(collectionView.re.isValidIndexPath(negativeIndexPath))
        XCTAssert(collectionView.re.isValidIndexPath(zeroIndexPath))
        XCTAssert(collectionView.re.isValidIndexPath(validIndexPath))
        XCTAssertFalse(collectionView.re.isValidIndexPath(invalidIndexPath))
    }
}

extension UICollectionViewExtensionsTests: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (collectionView == self.collectionView || collectionView == flowLayoutCollectionView) ? 2 : 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == self.collectionView || collectionView == flowLayoutCollectionView) ?
            (section == 0 ? 5 : 0) : 0
    }

    func collectionView(_: UICollectionView, cellForItemAt _: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

#endif
