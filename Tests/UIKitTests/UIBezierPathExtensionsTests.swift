//
//  UIBezierPathExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/18.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit)
import UIKit

final class UIBezierPathExtensionsTests: XCTestCase {
    func testInitPathFromTo() {
        let fromPoint = CGPoint(x: -1, y: 2)
        let toPoint = CGPoint(x: 2, y: 4)
        let path = UIBezierPath.re(from: fromPoint, to: toPoint)
        XCTAssertEqual(path.points, [fromPoint, toPoint])
    }

    func testInitWithPoints() {
        let emptyPath = UIBezierPath.re(points: [])
        XCTAssert(emptyPath.points.isEmpty)

        let points = [
            CGPoint(x: -1, y: 2),
            CGPoint(x: 2, y: 4),
            CGPoint(x: 3, y: -3)
        ]
        let path = UIBezierPath.re(points: points)
        XCTAssertEqual(path.points, points)
    }

    func testInitPolygonWithPoints() {
        let insufficientPoints = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: -1, y: 2)
        ]
        XCTAssertNil(UIBezierPath.re(polygonWithPoints: insufficientPoints))

        let firstPoint = CGPoint.zero
        let points = [
            firstPoint,
            CGPoint(x: -1, y: 2),
            CGPoint(x: 2, y: 4),
            CGPoint(x: 3, y: -3)
        ]
        let path = UIBezierPath.re(polygonWithPoints: points)
        XCTAssertNotNil(path)
        XCTAssertEqual(path!.points, points + [firstPoint])
    }

    func testInitOvalOfSize() {
        let width: CGFloat = 100
        let height: CGFloat = 50
        let size = CGSize(width: width, height: height)

        let centeredPath = UIBezierPath.re(ovalOf: size, centered: true)
        XCTAssertEqual(
            centeredPath,
            UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: -width / 2, y: -height / 2), size: size)))

        let uncenteredPath = UIBezierPath.re(ovalOf: size, centered: false)
        XCTAssertEqual(uncenteredPath, UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)))
    }

    func testInitRectOfSize() {
        let width: CGFloat = 100
        let height: CGFloat = 50
        let size = CGSize(width: width, height: height)

        let centeredPath = UIBezierPath.re(rectOf: size, centered: true)
        XCTAssertEqual(
            centeredPath,
            UIBezierPath(rect: CGRect(origin: CGPoint(x: -width / 2, y: -height / 2), size: size)))

        let uncenteredPath = UIBezierPath.re(rectOf: size, centered: false)
        XCTAssertEqual(uncenteredPath, UIBezierPath(rect: CGRect(origin: .zero, size: size)))
    }
}

fileprivate extension UIBezierPath {
    // Only works for straight lines
    var points: [CGPoint] {
        var points = [CGPoint]()
        if #available(iOS 11.0, tvOS 11.0, *) {
            cgPath.applyWithBlock { pointer in
                let element = pointer.pointee
                var point = CGPoint.zero
                switch element.type {
                case .moveToPoint: point = element.points[0]
                case .addLineToPoint: point = element.points[0]
                default: break
                }
                points.append(point)
            }
        }
        return points
    }
}

#endif
