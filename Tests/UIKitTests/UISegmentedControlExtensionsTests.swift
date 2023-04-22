//
//  UISegmentedControlExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UISegmentedControlExtensionsTests: XCTestCase {
    func testSegmentTitles() {
        let segmentControl = UISegmentedControl()
        XCTAssert(segmentControl.re.segmentTitles.isEmpty)
        let titles = ["Title1", "Title2"]
        segmentControl.re.segmentTitles = titles
        XCTAssertEqual(segmentControl.re.segmentTitles, titles)
    }

    func testSegmentImages() {
        let segmentControl = UISegmentedControl()
        XCTAssert(segmentControl.re.segmentImages.isEmpty)
        let images = [UIImage(), UIImage()]
        segmentControl.re.segmentImages = images
        XCTAssertEqual(segmentControl.re.segmentImages, images)
    }
}

#endif
