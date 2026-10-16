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
    private var window: UIWindow!

    override func setUp() {
        super.setUp()
        // UIRefreshControl ignores `beginRefreshing()` (isRefreshing stays false) unless it's in a window.
        // Inside a window, animated offset changes are deferred, so the tests below use `animated: false`.
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        window.makeKeyAndVisible()
    }

    override func tearDown() {
        window.isHidden = true
        window = nil
        super.tearDown()
    }

    func testBeginRefreshAsRefreshControlSubview() {
        let tableView = UITableView()
        window.addSubview(tableView)
        tableView.contentInsetAdjustmentBehavior = .never
        XCTAssertEqual(tableView.contentOffset, .zero)
        let refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.re.beginRefreshing(in: tableView, animated: false)

        XCTAssert(refreshControl.isRefreshing)
        XCTAssertEqual(tableView.contentOffset.y, -refreshControl.frame.height)

        let anotherTableview = UITableView()
        window.addSubview(anotherTableview)
        anotherTableview.contentInsetAdjustmentBehavior = .never
        XCTAssertEqual(anotherTableview.contentOffset, .zero)
        anotherTableview.refreshControl = UIRefreshControl()
        anotherTableview.refreshControl?.re.beginRefreshing(in: anotherTableview, animated: false, sendAction: true)

        XCTAssert(anotherTableview.refreshControl!.isRefreshing)
        XCTAssertEqual(anotherTableview.contentOffset.y, -anotherTableview.refreshControl!.frame.height)
    }

    func testBeginRefreshAsScrollViewSubview() {
        let scrollView = UIScrollView()
        window.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        XCTAssertEqual(scrollView.contentOffset, .zero)
        let refreshControl = UIRefreshControl()
        scrollView.addSubview(refreshControl)
        refreshControl.re.beginRefreshing(animated: false)

        XCTAssert(refreshControl.isRefreshing)
        XCTAssertEqual(scrollView.contentOffset.y, -refreshControl.frame.height)

        let anotherScrollView = UIScrollView()
        window.addSubview(anotherScrollView)
        anotherScrollView.contentInsetAdjustmentBehavior = .never
        XCTAssertEqual(anotherScrollView.contentOffset, .zero)
        anotherScrollView.refreshControl = UIRefreshControl()
        anotherScrollView.refreshControl?.re.beginRefreshing(animated: false, sendAction: true)

        XCTAssert(anotherScrollView.refreshControl!.isRefreshing)
        XCTAssertEqual(anotherScrollView.contentOffset.y, -anotherScrollView.refreshControl!.frame.height)
    }
}

#endif
