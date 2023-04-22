//
//  UIScrollViewExtensionsTest.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UIScrollViewExtensionsTest: XCTestCase {
    let scroll = UIScrollView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))

    override func setUp() {
        super.setUp()

        scroll.contentSize = CGSize(width: 500, height: 500)
        scroll.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
    }

    func testSnapshot() {
        let snapshot = scroll.re.snapshot
        XCTAssertNotNil(snapshot)
        let view = UIScrollView()
        XCTAssertNil(view.re.snapshot)
    }

    func testVisibleRect() {
        XCTAssertEqual(scroll.re.visibleRect, CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))

        scroll.contentOffset = CGPoint(x: 50, y: 50)
        XCTAssertEqual(scroll.re.visibleRect, CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: 100, height: 100)))

        let offset = CGPoint(x: 490, y: 480)
        scroll.contentOffset = offset
        XCTAssertEqual(scroll.re.visibleRect, CGRect(origin: offset, size: CGSize(width: 10, height: 20)))
    }

    func testScrollToTop() {
        scroll.contentOffset = CGPoint(x: 50, y: 50)
        scroll.re.scrollToTop(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: 50, y: -10))
    }

    func testScrollToLeft() {
        scroll.contentOffset = CGPoint(x: 50, y: 50)
        scroll.re.scrollToLeft(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: -20, y: 50))
    }

    func testScrollToBottom() {
        scroll.contentOffset = CGPoint(x: 50, y: 50)
        scroll.re.scrollToBottom(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: 50, y: scroll.contentSize.height - scroll.bounds.height + 30))
    }

    func testScrollToRight() {
        scroll.contentOffset = CGPoint(x: 50, y: 50)
        scroll.re.scrollToRight(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: scroll.contentSize.width - scroll.bounds.height + 40, y: 50))
    }

    func testScrollUp() {
        let offset = CGPoint(x: 50, y: 250)
        scroll.contentOffset = offset
        scroll.re.scrollUp(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: offset.x, y: 150))
        scroll.re.scrollUp(animated: false)
        scroll.re.scrollUp(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: offset.x, y: -10))

        let scrollView = UIScrollView()
        scrollView.re.scrollUp(animated: false)
        XCTAssertEqual(scrollView.contentOffset, .zero)

        #if !os(tvOS)
        scroll.isPagingEnabled = true
        scroll.contentOffset = offset
        scroll.re.scrollUp(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: offset.x, y: 90))

        scrollView.isPagingEnabled = true
        scrollView.re.scrollUp(animated: false)
        XCTAssertEqual(scrollView.contentOffset, .zero)
        #endif
    }

    func testScrollLeft() {
        let offset = CGPoint(x: 250, y: 50)
        scroll.contentOffset = offset
        scroll.re.scrollLeft(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: 150, y: offset.y))
        scroll.re.scrollLeft(animated: false)
        scroll.re.scrollLeft(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: -20, y: offset.y))

        let scrollView = UIScrollView()
        scrollView.re.scrollLeft(animated: false)
        XCTAssertEqual(scrollView.contentOffset, .zero)

        #if !os(tvOS)
        scroll.isPagingEnabled = true
        scroll.contentOffset = offset
        scroll.re.scrollLeft(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: 80, y: offset.y))

        scrollView.isPagingEnabled = true
        scrollView.re.scrollLeft(animated: false)
        XCTAssertEqual(scrollView.contentOffset, .zero)
        #endif
    }

    func testScrollDown() {
        let offset = CGPoint(x: 50, y: 250)
        scroll.contentOffset = offset
        scroll.re.scrollDown(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: offset.x, y: 350))
        scroll.re.scrollDown(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: offset.x, y: 430))

        let scrollView = UIScrollView()
        scrollView.re.scrollDown(animated: false)
        XCTAssertEqual(scrollView.contentOffset, .zero)

        #if !os(tvOS)
        scroll.isPagingEnabled = true
        scroll.contentOffset = offset
        scroll.re.scrollDown(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: offset.x, y: 290))

        scrollView.isPagingEnabled = true
        scrollView.re.scrollDown(animated: false)
        XCTAssertEqual(scrollView.contentOffset, .zero)
        #endif
    }

    func testScrollRight() {
        let offset = CGPoint(x: 250, y: 50)
        scroll.contentOffset = offset
        scroll.re.scrollRight(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: 350, y: offset.y))
        scroll.re.scrollRight(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: 440, y: offset.y))

        let scrollView = UIScrollView()
        scrollView.re.scrollRight(animated: false)
        XCTAssertEqual(scrollView.contentOffset, .zero)

        #if !os(tvOS)
        scroll.isPagingEnabled = true
        scroll.contentOffset = offset
        scroll.re.scrollRight(animated: false)
        XCTAssertEqual(scroll.contentOffset, CGPoint(x: 280, y: offset.y))

        scrollView.isPagingEnabled = true
        scrollView.re.scrollRight(animated: false)
        XCTAssertEqual(scrollView.contentOffset, .zero)
        #endif
    }
}

#endif
