//
//  UIStoryboardExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if os(iOS)
import UIKit

final class UIStoryboardExtensionsTests: XCTestCase {
    func testMainStoryboard() {
        XCTAssertNil(UIStoryboard.re.main)
    }

    func testInstantiateViewController() {
        let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: UIStoryboardExtensionsTests.self))
        let viewController = storyboard.re.instantiateViewController(withClass: UIViewController.self)
        XCTAssertNotNil(viewController)
    }
}

#endif
