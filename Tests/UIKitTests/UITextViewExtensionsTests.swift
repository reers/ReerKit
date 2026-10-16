//
//  UITextViewExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UITextViewExtensionsTests: XCTestCase {
    var textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    override func setUp() {
        super.setUp()
    }

    func testClear() {
        textView.text = "Hello"
        textView.re.clear()
        XCTAssertEqual(textView.text, "")
        XCTAssertEqual(textView.attributedText?.string, "")
    }

    func testScroll() {
        let text =
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation."
        textView.text = text
        textView.re.scrollToBottom()
        XCTAssertGreaterThan(textView.contentOffset.y, 0.0)

        textView.re.scrollToTop()
        XCTAssertNotEqual(textView.contentOffset.y, 0.0)
    }

    func testWrapToContent() {
        let text =
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

        // initial setting
        textView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 20))
        textView.font = UIFont.systemFont(ofSize: 20.0)
        textView.text = text

        // before setting wrap, content won't be equal to bounds
        XCTAssertNotEqual(textView.bounds.size, textView.contentSize)

        // calling the wrap extension method
        textView.re.wrapToContent()

        XCTAssertEqual(textView.contentInset, .zero)
        XCTAssertEqual(textView.textContainerInset, .zero)
        XCTAssertEqual(textView.textContainer.lineFragmentPadding, 0)

        #if !targetEnvironment(macCatalyst)
        // TextKit 2 lays out lazily and only estimates `contentSize` for off-screen text,
        // so compare against an explicit measurement instead of `contentSize`.
        let boundingBox = text.boundingRect(
            with: CGSize(width: 100, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: textView.font!],
            context: nil
        )
        XCTAssertEqual(textView.bounds.width, 100, accuracy: 1)
        XCTAssertEqual(textView.bounds.height, ceil(boundingBox.height), accuracy: 1)
        #endif
    }
}

#endif
