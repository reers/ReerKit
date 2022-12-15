//
//  CAGradientLayerExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/15.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest

@testable import ReerKit
import XCTest

#if !os(watchOS) && !os(Linux)

final class CAGradientLayerExtensionsTests: XCTestCase {
    func testInitWithGradientAttributes() {
        let colors: [REColor] = [.red, .blue, .orange, .yellow]
        let locations: [CGFloat]? = [0, 0.3, 0.6, 1]
        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5)
        let gradientLayerType = CAGradientLayerType.axial

        let gradientLayer = CAGradientLayer.re(
            colors: colors,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint,
            type: gradientLayerType
        )

        XCTAssertEqual(gradientLayer.colors?.count, colors.count)
        XCTAssertEqual(gradientLayer.locations as? [CGFloat], locations)
        XCTAssertEqual(gradientLayer.startPoint, startPoint)
        XCTAssertEqual(gradientLayer.endPoint, endPoint)
        XCTAssertEqual(gradientLayer.type, gradientLayerType)
    }
}

#endif
