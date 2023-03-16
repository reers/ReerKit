//
//  EdgeInsetsExtensionsTests.swift
//  ReerKit
//
//  Created by phoenix on 2023/3/17.
//  Copyright © 2023 reers. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)

@testable import ReerKit
import XCTest

final class EdgeInsetsExtensionsTests: XCTestCase {
    func testHorizontal() {
        let inset = REEdgeInsets(top: 30.0, left: 5.0, bottom: 5.0, right: 10.0)
        XCTAssertEqual(inset.re.horizontal, 15.0)
    }

    func testVertical() {
        let inset = REEdgeInsets(top: 10.0, left: 10.0, bottom: 5.0, right: 10.0)
        XCTAssertEqual(inset.re.vertical, 15.0)
    }

    func testInitInset() {
        let inset = REEdgeInsets.re(inset: 5.0)
        XCTAssertEqual(inset.top, 5.0)
        XCTAssertEqual(inset.bottom, 5.0)
        XCTAssertEqual(inset.right, 5.0)
        XCTAssertEqual(inset.left, 5.0)
    }


    func testInsetByTop() {
        let inset = REEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let insetByTop = inset.re.insetBy(top: 5.0)
        XCTAssertNotEqual(inset, insetByTop)
        XCTAssertEqual(insetByTop.top, 15.0)
        XCTAssertEqual(insetByTop.left, 10.0)
        XCTAssertEqual(insetByTop.bottom, 10.0)
        XCTAssertEqual(insetByTop.right, 10.0)

        let negativeInsetByTop = inset.re.insetBy(top: -5.0)
        XCTAssertNotEqual(inset, negativeInsetByTop)
        XCTAssertEqual(negativeInsetByTop.top, 5.0)
        XCTAssertEqual(negativeInsetByTop.left, 10.0)
        XCTAssertEqual(negativeInsetByTop.bottom, 10.0)
        XCTAssertEqual(negativeInsetByTop.right, 10.0)
    }

    func testInsetByLeft() {
        let inset = REEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let insetByLeft = inset.re.insetBy(left: 5.0)
        XCTAssertNotEqual(inset, insetByLeft)
        XCTAssertEqual(insetByLeft.top, 10.0)
        XCTAssertEqual(insetByLeft.left, 15.0)
        XCTAssertEqual(insetByLeft.bottom, 10.0)
        XCTAssertEqual(insetByLeft.right, 10.0)

        let negativeInsetByLeft = inset.re.insetBy(left: -5.0)
        XCTAssertNotEqual(inset, negativeInsetByLeft)
        XCTAssertEqual(negativeInsetByLeft.top, 10.0)
        XCTAssertEqual(negativeInsetByLeft.left, 5.0)
        XCTAssertEqual(negativeInsetByLeft.bottom, 10.0)
        XCTAssertEqual(negativeInsetByLeft.right, 10.0)
    }

    func testInsetByBottom() {
        let inset = REEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let insetByBottom = inset.re.insetBy(bottom: 5.0)
        XCTAssertNotEqual(inset, insetByBottom)
        XCTAssertEqual(insetByBottom.top, 10.0)
        XCTAssertEqual(insetByBottom.left, 10.0)
        XCTAssertEqual(insetByBottom.bottom, 15.0)
        XCTAssertEqual(insetByBottom.right, 10.0)

        let negativeInsetByBottom = inset.re.insetBy(bottom: -5.0)
        XCTAssertNotEqual(inset, negativeInsetByBottom)
        XCTAssertEqual(negativeInsetByBottom.top, 10.0)
        XCTAssertEqual(negativeInsetByBottom.left, 10.0)
        XCTAssertEqual(negativeInsetByBottom.bottom, 5.0)
        XCTAssertEqual(negativeInsetByBottom.right, 10.0)
    }

    func testInsetByRight() {
        let inset = REEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let insetByRight = inset.re.insetBy(right: 5.0)
        XCTAssertNotEqual(inset, insetByRight)
        XCTAssertEqual(insetByRight.top, 10.0)
        XCTAssertEqual(insetByRight.left, 10.0)
        XCTAssertEqual(insetByRight.bottom, 10.0)
        XCTAssertEqual(insetByRight.right, 15.0)

        let negativeInsetByRight = inset.re.insetBy(right: -5.0)
        XCTAssertNotEqual(inset, negativeInsetByRight)
        XCTAssertEqual(negativeInsetByRight.top, 10.0)
        XCTAssertEqual(negativeInsetByRight.left, 10.0)
        XCTAssertEqual(negativeInsetByRight.bottom, 10.0)
        XCTAssertEqual(negativeInsetByRight.right, 5.0)
    }

    func testAddition() {
        XCTAssertEqual(REEdgeInsets.zero + REEdgeInsets.zero, REEdgeInsets.zero)

        let insets1 = REEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        let insets2 = REEdgeInsets(top: 5, left: 6, bottom: 7, right: 8)
        let expected = REEdgeInsets(top: 6, left: 8, bottom: 10, right: 12)
        XCTAssertEqual(insets1 + insets2, expected)

        let negativeInsets1 = REEdgeInsets(top: -1, left: -2, bottom: -3, right: -4)
        let negativeInsets2 = REEdgeInsets(top: -5, left: -6, bottom: -7, right: -8)
        let negativeExpected = REEdgeInsets(top: -6, left: -8, bottom: -10, right: -12)
        XCTAssertEqual(negativeInsets1 + negativeInsets2, negativeExpected)
    }

    func testInPlaceAddition() {
        var zero = REEdgeInsets.zero
        zero += REEdgeInsets.zero
        XCTAssertEqual(zero, REEdgeInsets.zero)

        var insets = REEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        insets += REEdgeInsets(top: 5, left: 6, bottom: 7, right: 8)
        let expected = REEdgeInsets(top: 6, left: 8, bottom: 10, right: 12)
        XCTAssertEqual(insets, expected)

        var negativeInsets = REEdgeInsets(top: -1, left: -2, bottom: -3, right: -4)
        negativeInsets += REEdgeInsets(top: -5, left: -6, bottom: -7, right: -8)
        let negativeExpected = REEdgeInsets(top: -6, left: -8, bottom: -10, right: -12)
        XCTAssertEqual(negativeInsets, negativeExpected)
    }
}

#endif
