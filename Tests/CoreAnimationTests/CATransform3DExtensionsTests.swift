//
//  CATransform3DExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/15.
//  Copyright © 2022 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(QuartzCore)

#if canImport(CoreGraphics)
import CoreGraphics
#endif

final class CATransform3DExtensionsTests: XCTestCase {
    let x = CGFloat(5)
    let y = CGFloat(10)
    let z = CGFloat(20)
    let angle = CGFloat.pi / 3

    var translation: CATransform3D { CATransform3DMakeTranslation(x, y, z) }
    var scale: CATransform3D { CATransform3DMakeScale(x, y, z) }
    var rotation: CATransform3D { CATransform3DMakeRotation(angle, x, y, z) }

    func testIdentity() {
        XCTAssertEqual(CATransform3D.re.identity, CATransform3DIdentity)
        XCTAssertNotEqual(translation, CATransform3D.re.identity)
        XCTAssertNotEqual(scale, CATransform3D.re.identity)
        XCTAssertNotEqual(rotation, CATransform3D.re.identity)
    }

    func testInitTranslation() {
        XCTAssertEqual(CATransform3D.re(translationX: x, y: y, z: z), translation)
    }

    func testInitScale() {
        XCTAssertEqual(CATransform3D.re(scaleX: x, y: y, z: z), scale)
    }

    func testInitRotation() {
        XCTAssertEqual(CATransform3D.re(rotationAngle: angle, x: x, y: y, z: z), rotation)
    }

    func testIsIdentity() {
        XCTAssert(CATransform3DIdentity.re.isIdentity)
        XCTAssertFalse(translation.re.isIdentity)
        XCTAssertFalse(scale.re.isIdentity)
        XCTAssertFalse(rotation.re.isIdentity)
    }

    func testTranslated() {
        XCTAssertEqual(CATransform3DIdentity.re.translatedBy(x: x, y: y, z: z), translation)
    }

    func testScaled() {
        XCTAssertEqual(CATransform3DIdentity.re.scaledBy(x: x, y: y, z: z), scale)
    }

    func testRotated() {
        XCTAssertEqual(CATransform3DIdentity.re.rotated(by: angle, x: x, y: y, z: z), rotation)
    }

    func testInverted() {
        XCTAssertEqual(CATransform3DIdentity, CATransform3DIdentity.re.inverted())
        XCTAssertEqual(translation.re.inverted(), CATransform3DInvert(translation))
        XCTAssertEqual(scale.re.inverted(), CATransform3DInvert(scale))
        XCTAssertEqual(rotation.re.inverted(), CATransform3DInvert(rotation))
    }

    func testConcatenated() {
        XCTAssertEqual(CATransform3DIdentity.re.concatenating(translation), translation)
        XCTAssertEqual(CATransform3DIdentity.re.concatenating(scale), scale)
        XCTAssertEqual(CATransform3DIdentity.re.concatenating(rotation), rotation)
    }

    func testTranslate() {
        var transform = CATransform3DIdentity
        transform.re.translateBy(x: x, y: y, z: z)
        XCTAssertEqual(transform, translation)
    }

    func testScale() {
        var transform = CATransform3DIdentity
        transform.re.scaleBy(x: x, y: y, z: z)
        XCTAssertEqual(transform, scale)
    }

    func testRotate() {
        var transform = CATransform3DIdentity
        transform.re.rotate(by: angle, x: x, y: y, z: z)
        XCTAssertEqual(transform, rotation)
    }

    func testInvert() {
        var transform = CATransform3DIdentity
        transform.re.invert()
        XCTAssertEqual(transform, CATransform3DIdentity)

        transform = translation
        transform.re.invert()
        XCTAssertEqual(transform, CATransform3DInvert(translation))

        transform = scale
        transform.re.invert()
        XCTAssertEqual(transform, CATransform3DInvert(scale))

        transform = rotation
        transform.re.invert()
        XCTAssertEqual(transform, CATransform3DInvert(rotation))
    }

    func testConcatenate() {
        var transform = CATransform3DIdentity
        transform.re.concatenate(translation)
        XCTAssertEqual(transform, translation)

        transform = CATransform3DIdentity
        transform.re.concatenate(scale)
        XCTAssertEqual(transform, scale)

        transform = CATransform3DIdentity
        transform.re.concatenate(rotation)
        XCTAssertEqual(transform, rotation)
    }

    #if canImport(CoreGraphics)

    func testIsAffine() {
        XCTAssert(CATransform3DIdentity.re.isAffine)
        XCTAssertFalse(CATransform3DMakeTranslation(0, 0, 1).re.isAffine)
    }

    func testAffineTransform() {
        XCTAssertEqual(CATransform3DIdentity.re.affineTransform(), CGAffineTransform.identity)
        XCTAssertEqual(
            CATransform3DMakeTranslation(x, y, 1).re.affineTransform(),
            CGAffineTransform(translationX: x, y: y))
    }

    #endif
}

#endif

