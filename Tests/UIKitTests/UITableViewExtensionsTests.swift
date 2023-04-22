//
//  UITableViewExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UITableViewExtensionsTests: XCTestCase {
    let tableView = UITableView()
    let emptyTableView = UITableView()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        tableView.dataSource = self
        emptyTableView.dataSource = self
        tableView.reloadData()
    }

    func testIndexPathForLastRow() {
        XCTAssertNotNil(tableView.re.indexPathForLastRow)
        XCTAssertEqual(tableView.re.indexPathForLastRow, IndexPath(row: 7, section: 1))
        XCTAssertNil(emptyTableView.re.indexPathForLastRow)
        XCTAssertNil(emptyTableView.re.indexPathForLastRow(inSection: 0))
    }

    func testLastSection() {
        XCTAssertEqual(tableView.re.lastSection, 1)
        XCTAssertNil(emptyTableView.re.lastSection)
    }

    func testNumberOfRows() {
        XCTAssertEqual(tableView.re.numberOfRows(), 13)
        XCTAssertEqual(emptyTableView.re.numberOfRows(), 0)
    }

    func testIndexPathForLastRowInSection() {
        XCTAssertNil(tableView.re.indexPathForLastRow(inSection: -1))
        XCTAssertNil(emptyTableView.re.indexPathForLastRow(inSection: -1))
        XCTAssertEqual(tableView.re.indexPathForLastRow(inSection: 0), IndexPath(row: 4, section: 0))
        XCTAssertEqual(UITableView().re.indexPathForLastRow(inSection: 0), IndexPath(row: 0, section: 0))
    }

    func testReloadData() {
        let exp = expectation(description: "reloadCallback")
        tableView.re.reloadData {
            XCTAssert(true)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

    func testRemoveTableFooterView() {
        tableView.tableFooterView = UIView()
        XCTAssertNotNil(tableView.tableFooterView)
        tableView.re.removeTableFooterView()
        XCTAssertNil(tableView.tableFooterView)
    }

    func testRemoveTableHeaderView() {
        tableView.tableHeaderView = UIView()
        XCTAssertNotNil(tableView.tableHeaderView)
        tableView.re.removeTableHeaderView()
        XCTAssertNil(tableView.tableHeaderView)
    }

    func testDequeueReusableCellWithClass() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        let cell = tableView.re.dequeueReusableCell(withClass: UITableViewCell.self)
        XCTAssertNotNil(cell)
    }

    func testDequeueReusableCellWithClassForIndexPath() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        let indexPath = tableView.re.indexPathForLastRow!
        let cell = tableView.re.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
        XCTAssertNotNil(cell)
    }

    func testDequeueReusableHeaderFooterView() {
        tableView.register(UITableViewHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        let headerFooterView = tableView.re.dequeueReusableHeaderFooterView(withClass: UITableViewHeaderFooterView.self)
        XCTAssertNotNil(headerFooterView)
    }

    func testIsValidIndexPath() {
        let validIndexPath = IndexPath(row: 0, section: 0)
        XCTAssert(tableView.re.isValidIndexPath(validIndexPath))

        let invalidIndexPath = IndexPath(row: 10, section: 0)
        XCTAssertFalse(tableView.re.isValidIndexPath(invalidIndexPath))

        let negativeIndexPath = IndexPath(row: -1, section: 0)
        XCTAssertFalse(tableView.re.isValidIndexPath(negativeIndexPath))
    }

    func testSafeScrollToIndexPath() {
        let validIndexPathTop = IndexPath(row: 0, section: 0)

        tableView.contentOffset = .init(x: 0, y: 100)
        XCTAssertNotEqual(tableView.contentOffset, .zero)

        tableView.re.scrollToRow(at: validIndexPathTop, at: .top, animated: false)
        XCTAssertEqual(tableView.contentOffset, .zero)

        let validIndexPathBottom = IndexPath(row: 7, section: 1)
        let bottomOffset = CGPoint(x: 0, y: tableView.contentSize.height - tableView.bounds.size.height)

        tableView.contentOffset = .init(x: 0, y: 200)
        XCTAssertNotEqual(tableView.contentOffset, bottomOffset)

        tableView.re.scrollToRow(at: validIndexPathBottom, at: .bottom, animated: false)
        #if os(tvOS)
        XCTAssertEqual(bottomOffset.y, tableView.contentOffset.y, accuracy: 15.0)
        #else
        XCTAssertEqual(bottomOffset.y, tableView.contentOffset.y, accuracy: 2.0)
        #endif

        let invalidIndexPath = IndexPath(row: 213, section: 21)
        tableView.contentOffset = .zero

        tableView.re.scrollToRow(at: invalidIndexPath, at: .bottom, animated: false)
        XCTAssertEqual(tableView.contentOffset, .zero)
    }

    #if os(iOS)
    func testRegisterReusableViewWithClassAndNib() {
        let nib = UINib(nibName: "UITableViewHeaderFooterView", bundle: Bundle(for: UITableViewExtensionsTests.self))
        tableView.re.register(nib: nib, withHeaderFooterViewClass: UITableViewHeaderFooterView.self)
        let view = tableView.re.dequeueReusableHeaderFooterView(withClass: UITableViewHeaderFooterView.self)
        XCTAssertNotNil(view)
    }
    #endif

    func testRegisterReusableViewWithClass() {
        tableView.re.register(headerFooterViewClassWith: UITableViewHeaderFooterView.self)
        let view = tableView.re.dequeueReusableHeaderFooterView(withClass: UITableViewHeaderFooterView.self)
        XCTAssertNotNil(view)
    }

    func testRegisterCellWithClass() {
        tableView.re.register(cellWithClass: UITableViewCell.self)
        let cell = tableView.re.dequeueReusableCell(withClass: UITableViewCell.self)
        XCTAssertNotNil(cell)
    }

    #if os(iOS)
    func testRegisterCellWithClassAndNib() {
        let nib = UINib(nibName: "UITableViewCell", bundle: Bundle(for: UITableViewExtensionsTests.self))
        tableView.re.register(nib: nib, withCellClass: UITableViewCell.self)
        let cell = tableView.re.dequeueReusableCell(withClass: UITableViewCell.self)
        XCTAssertNotNil(cell)
    }
    #endif

    #if os(iOS)
    func testRegisterCellWithNibUsingClass() {
        tableView.re.register(nibWithCellClass: UITableViewCell.self, at: UITableViewExtensionsTests.self)
        let cell = tableView.re.dequeueReusableCell(withClass: UITableViewCell.self)
        XCTAssertNotNil(cell)
    }
    #endif
}

extension UITableViewExtensionsTests: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == emptyTableView ? 0 : 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == emptyTableView {
            return 0
        } else {
            return section == 0 ? 5 : 8
        }
    }

    func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

#endif