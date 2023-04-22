//
//  UIRefreshControlExtensionTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && os(iOS)
import UIKit

final class UIRefreshControlExtensionTests: XCTestCase {
    func testBeginRefreshAsRefreshControlSubview() {
        let tableView = UITableView()
        XCTAssertEqual(tableView.contentOffset, .zero)
        let refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.re.beginRefreshing(in: tableView, animated: true)

        XCTAssert(refreshControl.isRefreshing)
        XCTAssertEqual(tableView.contentOffset.y, -refreshControl.frame.height)

        let anotherTableview = UITableView()
        XCTAssertEqual(anotherTableview.contentOffset, .zero)
        anotherTableview.refreshControl = UIRefreshControl()
        anotherTableview.refreshControl?.re.beginRefreshing(in: anotherTableview, animated: true, sendAction: true)

        XCTAssert(anotherTableview.refreshControl!.isRefreshing)
        XCTAssertEqual(anotherTableview.contentOffset.y, -anotherTableview.refreshControl!.frame.height)
    }

    func testBeginRefreshAsScrollViewSubview() {
        let scrollView = UIScrollView()
        XCTAssertEqual(scrollView.contentOffset, .zero)
        let refreshControl = UIRefreshControl()
        scrollView.addSubview(refreshControl)
        refreshControl.re.beginRefreshing(animated: true)

        XCTAssert(refreshControl.isRefreshing)
        XCTAssertEqual(scrollView.contentOffset.y, -refreshControl.frame.height)

        let anotherScrollView = UIScrollView()
        XCTAssertEqual(anotherScrollView.contentOffset, .zero)
        anotherScrollView.refreshControl = UIRefreshControl()
        anotherScrollView.refreshControl?.re.beginRefreshing(animated: true, sendAction: true)

        XCTAssert(anotherScrollView.refreshControl!.isRefreshing)
        XCTAssertEqual(anotherScrollView.contentOffset.y, -anotherScrollView.refreshControl!.frame.height)
    }
}

#endif
