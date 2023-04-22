//
//  UIWindowExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && os(iOS)
import UIKit

final class UIWindowExtensionsTests: XCTestCase {
    func testSwitchRootViewController() {
        let viewController = UIViewController()
        let tableViewController = UITableViewController()

        let window = UIWindow()
        window.rootViewController = viewController

        XCTAssertNotNil(window.rootViewController)
        XCTAssertEqual(window.rootViewController!, viewController)

        window.re.switchRootViewController(to: tableViewController, animated: false)
        XCTAssertNotNil(window.rootViewController)
        XCTAssertEqual(window.rootViewController!, tableViewController)

        let completionExpectation = expectation(description: "Completed")

        window.re.switchRootViewController(to: viewController, animated: true, duration: 0.75) {
            completionExpectation.fulfill()
            XCTAssertNotNil(window.rootViewController)
            XCTAssertEqual(window.rootViewController!, viewController)
        }

        waitForExpectations(timeout: 1)
    }
}

#endif
