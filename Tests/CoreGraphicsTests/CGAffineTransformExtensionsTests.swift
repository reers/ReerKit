//
//  CGAffineTransformExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/15.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(CoreGraphics)
import CoreGraphics

#if canImport(QuartzCore)
import QuartzCore
#endif

final class CGAffineTransformExtensionsTests: XCTestCase {
    #if canImport(QuartzCore)
    func testTransform3D() {
        XCTAssertEqual(CGAffineTransform.identity.re.transform3D(), CATransform3DIdentity)

        let x = CGFloat(5)
        let y = CGFloat(10)
        let angle = CGFloat.pi / 3

        XCTAssertEqual(CGAffineTransform(translationX: x, y: y).re.transform3D(), CATransform3DMakeTranslation(x, y, 0))
        XCTAssertEqual(CGAffineTransform(scaleX: x, y: y).re.transform3D(), CATransform3DMakeScale(x, y, 1))
        XCTAssertEqual(CGAffineTransform(rotationAngle: angle).re.transform3D(), CATransform3DMakeRotation(angle, 0, 0, 1))
    }
    #endif
}

#endif
