//
//  UIGestureRecognizerExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/19.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if os(iOS) && !os(watchOS)
import UIKit

final class UIGestureRecognizerExtensionsTests: XCTestCase {
    func testRemoveFromView() {
        let view = UIImageView()
        let tap = UITapGestureRecognizer()

        // First Baseline Assertion
        XCTAssertNil(view.gestureRecognizers)
        XCTAssertNil(tap.view)

        view.addGestureRecognizer(tap)

        // Verify change
        XCTAssertNotNil(view.gestureRecognizers)
        XCTAssertNotNil(tap.view)

        // Second Baseline Assertion
        XCTAssertNotEqual(view.gestureRecognizers?.count, 0)
        XCTAssertFalse(view.gestureRecognizers?.isEmpty ?? true)

        tap.re.removeFromView()

        // Verify change
        XCTAssertEqual(view.gestureRecognizers?.count, 0)
        XCTAssert(view.gestureRecognizers?.isEmpty ?? false)
        XCTAssertNil(tap.view)
    }
}

#endif
