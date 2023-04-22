//
//  UINavigationItemExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UINavigationItemExtensionsTests: XCTestCase {
    func testReplaceTitle() {
        let navigationItem = UINavigationItem()
        let image = UIImage()
        navigationItem.re.replaceTitle(with: image)

        let imageView = navigationItem.titleView as? UIImageView
        XCTAssertNotNil(imageView)

        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        XCTAssertEqual(imageView?.frame, frame)

        XCTAssertEqual(imageView?.contentMode, .scaleAspectFit)
        XCTAssertEqual(imageView?.image, image)
    }
}

#endif

