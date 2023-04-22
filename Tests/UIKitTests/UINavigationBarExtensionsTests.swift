//
//  UINavigationBarExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UINavigationBarExtensionsTests: XCTestCase {
    func testSetTitleFont() {
        let navigationBar = UINavigationBar()
        let helveticaFont = UIFont(name: "HelveticaNeue", size: 14)!
        navigationBar.re.setTitleFont(helveticaFont, color: .green)
        let color = navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        XCTAssertEqual(color, .green)
        let font = navigationBar.titleTextAttributes?[NSAttributedString.Key.font] as? UIFont
        XCTAssertEqual(font, helveticaFont)

        navigationBar.re.setTitleFont(helveticaFont)
        let defaultColor = navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        XCTAssertEqual(defaultColor, .black)
    }

    func testMakeTransparent() {
        let navigationBar = UINavigationBar()
        navigationBar.re.makeTransparent(withTint: .red)
        XCTAssertNotNil(navigationBar.backgroundImage(for: .default))
        XCTAssertNotNil(navigationBar.shadowImage)
        XCTAssert(navigationBar.isTranslucent)
        XCTAssertEqual(navigationBar.tintColor, .red)
        let color = navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        XCTAssertEqual(color, .red)

        navigationBar.re.makeTransparent()
        let defaultColor = navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        XCTAssertEqual(defaultColor, .white)
    }

    func testSetColors() {
        let navigationBar = UINavigationBar()
        navigationBar.re.setColors(background: .blue, text: .green)
        XCTAssertFalse(navigationBar.isTranslucent)
        XCTAssertEqual(navigationBar.backgroundColor, .blue)
        XCTAssertEqual(navigationBar.barTintColor, .blue)
        XCTAssertNotNil(navigationBar.backgroundImage(for: .default))
        XCTAssertEqual(navigationBar.tintColor, .green)
        let color = navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        XCTAssertEqual(color, .green)
    }
}

#endif
