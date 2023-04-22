//
//  UIImageViewExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UIImageViewExtensionsTests: XCTestCase {
    func testDownload() {
        // Success
        let imageView = UIImageView()
        let url = URL(string: "https://developer.apple.com/swift/images/swift-og.png")!
        let placeHolder = UIImage()
        let downloadExpectation = expectation(description: "Download success")
        imageView.re.download(from: url, contentMode: .scaleAspectFill, placeholder: placeHolder) { image in
            XCTAssertEqual(imageView.image, image)
            downloadExpectation.fulfill()
        }
        XCTAssertEqual(imageView.image, placeHolder)
        XCTAssertEqual(imageView.contentMode, .scaleAspectFill)

        // Failure
        let failImageView = UIImageView()
        let failingURL = URL(string: "https://developer.apple.com/")!
        let failExpectation = expectation(description: "Download failure")
        failImageView.image = nil
        failImageView.re.download(from: failingURL, contentMode: .center, placeholder: nil) { image in
            XCTAssertNil(image)
            DispatchQueue.main.async {
                XCTAssertNil(failImageView.image)
            }
            failExpectation.fulfill()
        }
        XCTAssertEqual(failImageView.contentMode, .center)
        XCTAssertNil(failImageView.image)
        waitForExpectations(timeout: 15)
    }

    func testBlur() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
        imageView.re.blur(withStyle: .dark)

        let blurView = imageView.subviews.first as? UIVisualEffectView
        XCTAssertNotNil(blurView)
        XCTAssertNotNil(blurView?.effect)
        XCTAssertEqual(blurView?.frame, imageView.bounds)
        XCTAssertEqual(blurView?.autoresizingMask, [.flexibleWidth, .flexibleHeight])
        XCTAssert(imageView.clipsToBounds)
    }

    func testBlurred() {
        let imageView = UIImageView()
        let blurredImageView = imageView.re.blurred(withStyle: .extraLight)
        XCTAssertEqual(blurredImageView, imageView)
    }
}

#endif
