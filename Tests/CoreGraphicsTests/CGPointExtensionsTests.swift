//
//  CGPointExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/15.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(CoreGraphics)
import CoreGraphics

final class CGPointExtensionsTests: XCTestCase {
    let point1 = CGPoint(x: 10, y: 10)
    let point2 = CGPoint(x: 30, y: 30)

    func testDistanceFromPoint() {
        let distance = point1.re.distance(from: point2)
        XCTAssertEqual(distance, 28.28, accuracy: 0.01)
    }

    func testStaticDistance() {
        let distance = CGPoint.re.distance(from: point2, to: point1)
        XCTAssertEqual(distance, 28.28, accuracy: 0.01)
    }

    func testAdd() {
        let point = point1 + point2
        let result = CGPoint(x: 40, y: 40)
        XCTAssertEqual(point, result)
    }

    func testAddEqual() {
        var point = point1
        point += point2
        let result = CGPoint(x: 40, y: 40)
        XCTAssertEqual(point, result)
    }

    func testSubtract() {
        let point = point1 - point2
        let result = CGPoint(x: -20, y: -20)
        XCTAssertEqual(point, result)
    }

    func testSubtractEqual() {
        var point = point1
        point -= point2
        let result = CGPoint(x: -20, y: -20)
        XCTAssertEqual(point, result)
    }

    func testScalarMultiply() {
        let point = 5 * point1
        let result = CGPoint(x: 50, y: 50)
        XCTAssertEqual(point, result)

        let point2 = 5 * point1
        let result2 = CGPoint(x: 50, y: 50)
        XCTAssertEqual(point2, result2)
    }

    func testScalarMultiplyEqual() {
        var point = point1
        point *= 5
        let result = CGPoint(x: 50, y: 50)
        XCTAssertEqual(point, result)
    }
    
    func testInit() {
        let point: CGPoint = .re(2, 3)
        XCTAssertEqual(point, CGPoint(x: 2, y: 3))
    }
}

#endif
