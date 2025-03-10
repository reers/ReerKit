//
//  UIImageExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/19.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit)
import UIKit

final class UIImageExtensionsTests: XCTestCase {
    @available(tvOS 10.0, *)
    func testAverageColor() {
        let size = CGSize(width: 10, height: 5)

        // simple fill test
        XCTAssertEqual(UIColor.blue, UIImage.re(color: .blue, size: size).re.averageColor()!, accuracy: 0.01)
        XCTAssertEqual(UIColor.orange, UIImage.re(color: .orange, size: size).re.averageColor()!, accuracy: 0.01)

        // more interesting - red + green = yellow
        let renderer = UIGraphicsImageRenderer(size: size)
        let yellow = renderer.image {
            var rect = CGRect(x: 0, y: 0, width: size.width / 2, height: size.height)
            for color in [UIColor.red, UIColor.green] {
                $0.cgContext.beginPath()
                $0.cgContext.setFillColor(color.cgColor)
                $0.cgContext.addRect(rect)
                $0.cgContext.fillPath()
                rect.origin.x += rect.size.width
            }
        }
        XCTAssertEqual(UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1), yellow.re.averageColor()!, accuracy: 0.01)
    }
    
    func testPickColor() {
        let targetColor = UIColor.re(argbHex: 0x33bb2391)
        var image: UIImage = .re(color: targetColor, size: .re(20, 20))
        let pickedColor = image.re.color(at: .re(2, 2))!
        XCTAssertTrue(pickedColor.re.rgba.red - targetColor.re.rgba.red < 3)
        XCTAssertTrue(pickedColor.re.rgba.green - targetColor.re.rgba.green < 3)
        XCTAssertTrue(pickedColor.re.rgba.blue - targetColor.re.rgba.blue < 3)
        XCTAssertTrue(pickedColor.re.rgba.alpha - targetColor.re.rgba.alpha < 0.05)
        
        image = .re(color: .blue, size: .re(20, 20))
        let pickedColor2 = image.re.color(at: .re(2, 2))!
        XCTAssertTrue(pickedColor2.re.rgba.red - UIColor.blue.re.rgba.red < 3)
        XCTAssertTrue(pickedColor2.re.rgba.green - UIColor.blue.re.rgba.green < 3)
        XCTAssertTrue(pickedColor2.re.rgba.blue - UIColor.blue.re.rgba.blue < 3)
        XCTAssertTrue(pickedColor2.re.rgba.alpha - UIColor.blue.re.rgba.alpha < 0.05)
        
        image = .re(color: .clear, size: .re(20, 20))
        XCTAssertEqual(image.re.color(at: .re(2, 2))!.re.rgba.alpha, 0)
        
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        let pickedColor3 = image.re.color(at: .re(2, 2))!
        XCTAssertTrue(pickedColor3.re.rgba.red - UIColor.white.re.rgba.red < 3)
        XCTAssertTrue(pickedColor3.re.rgba.green - UIColor.white.re.rgba.green < 3)
        XCTAssertTrue(pickedColor3.re.rgba.blue - UIColor.white.re.rgba.blue < 3)
        XCTAssertTrue(pickedColor3.re.rgba.alpha - UIColor.white.re.rgba.alpha < 0.05)
        
        let targetColor4 = UIColor.re(hex: 0x26125B)
        let pickedColor4 = image.re.color(at: .re(130, 200))!
        XCTAssertTrue(pickedColor4.re.rgba.red - targetColor4.re.rgba.red < 3)
        XCTAssertTrue(pickedColor4.re.rgba.green - targetColor4.re.rgba.green < 3)
        XCTAssertTrue(pickedColor4.re.rgba.blue - targetColor4.re.rgba.blue < 3)
        XCTAssertTrue(pickedColor4.re.rgba.alpha - targetColor4.re.rgba.alpha < 0.05)
        
        let targetColor5 = UIColor.re(hex: 0xBB2E2D)
        let pickedColor5 = image.re.color(at: .re(915, 145))!
        XCTAssertTrue(pickedColor5.re.rgba.red - targetColor5.re.rgba.red < 3)
        XCTAssertTrue(pickedColor5.re.rgba.green - targetColor5.re.rgba.green < 3)
        XCTAssertTrue(pickedColor5.re.rgba.blue - targetColor5.re.rgba.blue < 3)
        XCTAssertTrue(pickedColor5.re.rgba.alpha - targetColor5.re.rgba.alpha < 0.05)
    }

    func testBytesSize() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        XCTAssertEqual(image.re.bytesSize, 99954)
        XCTAssertEqual(UIImage().re.bytesSize, 0)
    }

    func testKilobytesSize() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        XCTAssertEqual(image.re.kilobytesSize, 97)
    }

    func testOriginal() {
        let image = UIImage.re(color: .blue, size: CGSize(width: 20, height: 20))
        XCTAssertEqual(image.re.original, image.withRenderingMode(.alwaysOriginal))
    }

    func testTemplate() {
        let image = UIImage.re(color: .blue, size: CGSize(width: 20, height: 20))
        XCTAssertEqual(image.re.template, image.withRenderingMode(.alwaysTemplate))
    }

    func testCompressed() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        let originalSize = image.re.kilobytesSize
        let compressedImage = image.re.compressed(quality: 0.2)
        XCTAssertNotNil(compressedImage)
        XCTAssertLessThan(compressedImage!.re.kilobytesSize, originalSize)
        XCTAssertNil(UIImage().re.compressed())
    }

    func testCompressedData() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        let originalSize = image.re.bytesSize
        let compressedImageData = image.re.compressedData(quality: 0.2)
        XCTAssertNotNil(compressedImageData)
        XCTAssertLessThan(compressedImageData!.count, originalSize)
        XCTAssertNil(UIImage().re.compressedData())
    }

    func testCropped() {
        let image = UIImage.re(color: .black, size: CGSize(width: 20, height: 20))
        var cropped = image.re.cropped(to: CGRect(x: 0, y: 0, width: 40, height: 40))
        XCTAssertEqual(image, cropped)
        cropped = image.re.cropped(to: CGRect(x: 0, y: 0, width: 10, height: 10))
        let small = UIImage.re(color: .black, size: CGSize(width: 10, height: 10))
        XCTAssertEqual(cropped.re.bytesSize, small.re.bytesSize)

        let equalHeight = image.re.cropped(to: CGRect(x: 0, y: 0, width: 18, height: 20))
        XCTAssertNotEqual(image, equalHeight)

        let equalWidth = image.re.cropped(to: CGRect(x: 0, y: 0, width: 20, height: 18))
        XCTAssertNotEqual(image, equalWidth)

        guard let cgImage = image.cgImage else {
            XCTFail("Get cgImage from image failed")
            return
        }

        let imageWithScale = UIImage(cgImage: cgImage, scale: 2.0, orientation: .up)
        cropped = imageWithScale.re.cropped(to: CGRect(x: 0, y: 0, width: 15, height: 15))
        XCTAssertEqual(imageWithScale, cropped)

        cropped = imageWithScale.re.cropped(to: CGRect(x: 0, y: 0, width: 5, height: 6))
        XCTAssertEqual(imageWithScale.scale, cropped.scale)

        XCTAssertEqual(10, cropped.size.width * cropped.scale)
        XCTAssertEqual(12, cropped.size.height * cropped.scale)
    }

    func testScaledToHeight() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!

        let scaledImage = image.re.resize(toHeight: 300)
        XCTAssertNotNil(scaledImage)
        XCTAssertEqual(scaledImage!.size.height, 300, accuracy: 0.1)
    }

    func testScaledToWidth() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!

        let scaledImage = image.re.resize(toWidth: 300)
        XCTAssertNotNil(scaledImage)
        XCTAssertEqual(scaledImage!.size.width, 300, accuracy: 0.1)
    }
    
    func testResize() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        let ret = image.re.resize(to: .re(100, 400), contentMode: .scaleAspectFill)
        XCTAssertNotNil(ret)
        XCTAssertEqual(ret?.size, CGSize.re(100, 400))
        
        let ret2 = image.re.resize(to: .re(560, 560), contentMode: .scaleToFill)
        XCTAssertEqual(ret2?.size, CGSize.re(560, 560))
    }
    
    func testBlur() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "test_gray", in: bundle, compatibleWith: nil)!

        var start = Date()
        let grayscaleImage = image.re.grayscale
        print(Date().timeIntervalSince(start) * 1000)
        XCTAssertNotNil(grayscaleImage)
        
        start = Date()
        let mono = image.re.with(filter: .mono)
        print(Date().timeIntervalSince(start) * 1000)
        XCTAssertNotNil(mono)
        
        let chrome = image.re.with(filter: .chrome)
        XCTAssertNotNil(chrome)
        
        XCTAssertNil(image.re.with(filter: "xxxx"))
        
        let blurSoftImage = image.re.blurSoft
        XCTAssertNotNil(blurSoftImage)
        
        let blurLightImage = image.re.blurLight
        XCTAssertNotNil(blurLightImage)
        
        let blurExtraLightImage = image.re.blurExtraLight
        XCTAssertNotNil(blurExtraLightImage)
        
        let bluredImage = image.re.blurDark
        XCTAssertNotNil(bluredImage)
        
        let tintImage = image.re.blurWithTintColor(.red)
        XCTAssertNotNil(tintImage)
    }
    
    func testHasAlphaInfo() {
        XCTAssertTrue(UIImage.re(color: .clear).re.hasAlphaChannel)
        let data = UIImage.re(color: .red).re.compressedData()!
        XCTAssertFalse(UIImage(data: data)!.re.hasAlphaChannel)
    }
    
    func testEdge() {
        let image = UIImage.re(color: .red, size: .re(side: 80))
        
        let insideEdgeImage = image.re.withEdge(byInsets: .re(inset: 10), color: .green)
        XCTAssertNotNil(insideEdgeImage)
        
        let outsideEdgeImage = image.re.withEdge(byInsets: .re(inset: -10), color: .green)
        XCTAssertNotNil(outsideEdgeImage)
    }

    @available(tvOS 10.0, watchOS 3.0, *)
    func testRotatedByMeasurement() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!

        let halfRotatedImage = image.re.rotated(by: Measurement(value: 90, unit: .degrees))
        XCTAssertNotNil(halfRotatedImage)
        XCTAssertEqual(halfRotatedImage!.size, CGSize(width: image.size.height, height: image.size.width))

        let rotatedImage = image.re.rotated(by: Measurement(value: 180, unit: .degrees))
        XCTAssertNotNil(rotatedImage)
        XCTAssertEqual(rotatedImage!.size, image.size)
        XCTAssertNotEqual(image.jpegData(compressionQuality: 1), rotatedImage!.jpegData(compressionQuality: 1))
    }
    
    func testRotatedByDegreee() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        
        XCTAssertEqual(image.re.rotateRight90?.size.width, image.size.height)
        XCTAssertEqual(image.re.rotateLeft90?.size.height, image.size.width)
        XCTAssertEqual(image.re.rotate180?.size.height, image.size.height)
        XCTAssertEqual(image.re.rotate180?.size.width, image.size.width)
    }

    func testRotatedByRadians() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
  
        let halfRotatedImage = image.re.rotated(by: .pi / 2, fitSize: true)
        XCTAssertNotNil(halfRotatedImage)
        XCTAssertEqual(halfRotatedImage!.size, CGSize(width: image.size.height, height: image.size.width))

        let rotatedImage = image.re.rotated(by: .pi)
        XCTAssertNotNil(rotatedImage)
        XCTAssertEqual(rotatedImage!.size, image.size)
        XCTAssertNotEqual(image.jpegData(compressionQuality: 1), rotatedImage!.jpegData(compressionQuality: 1))
    }
    
    func testFlip() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        
        let horizontalFlippedImage = image.re.flipHorizontal
        XCTAssertNotNil(horizontalFlippedImage)
        
        let verticalFlippedImage = image.re.flipVertical
        XCTAssertNotNil(verticalFlippedImage)
    }

    func testFilled() {
        let image = UIImage.re(color: .black, size: CGSize(width: 20, height: 20))
        XCTAssertEqual(.yellow, image.re.filled(withColor: .yellow).re.averageColor()!, accuracy: 0.01)

        var emptyImage = UIImage()
        var filledImage = emptyImage.re.filled(withColor: .red)
        XCTAssertEqual(emptyImage, filledImage)

        emptyImage = UIImage.re(color: .yellow, size: CGSize.zero)
        filledImage = emptyImage.re.filled(withColor: .red)
        XCTAssertEqual(emptyImage, filledImage)
    }

    func testBase64() {
        let base64String =
            "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAE0lEQVR42mP8v5JhEwMaYKSBIADNAwvIr8dhZAAAAABJRU5ErkJggg=="
        let image = UIImage.re(base64String: base64String)
        XCTAssertNotNil(image)

        let size = CGSize(width: 5, height: 5)
        XCTAssertEqual(image?.size, size)

        XCTAssertEqual(image?.re.bytesSize, 787)

        let scale = CGFloat(5.0)
        let scaledSize = CGSize(width: size.width / scale, height: size.height / scale)

        let scaledImage = UIImage.re(base64String: base64String, scale: scale)
        XCTAssertEqual(scaledImage?.size, scaledSize)
    }

    func testURL() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        guard let reerLogo = bundle.url(forResource: "TestImage", withExtension: "png") else { XCTAssert(false, "Test Image not available, or url is no longer valid."); return }
        let image = try? UIImage.re(url: reerLogo)
        XCTAssertNotNil(image)

        let size = CGSize(width: 1024, height: 560)
        XCTAssertEqual(image?.size, size)

        let scale: CGFloat = 5.0
        let scaledSize = CGSize(width: size.width / scale, height: size.height / scale)

        let scaledImage = try? UIImage.re(url: reerLogo, scale: scale)
        XCTAssertNotNil(scaledImage)
        XCTAssertEqual(scaledImage?.size, scaledSize)

        guard let throwingURL = URL(string: "ReerKit://fakeurl/image1") else {
            XCTAssert(false, "Fake URL cannot be made")
            return
        }

        XCTAssertThrowsError(try UIImage.re(url: throwingURL))
    }

    func testTinted() {
        let baseImage = UIImage.re(color: .white, size: CGSize(width: 20, height: 20))
        let tintedImage = baseImage.re.blend(.black, mode: .overlay)
        let testImage = UIImage.re(color: .black, size: CGSize(width: 20, height: 20))
        XCTAssertEqual(testImage.re.averageColor()!, tintedImage.re.averageColor()!, accuracy: 0.01)
        
        if #available(iOS 13.0, *) {
            let original = UIImage(systemName: "star")!
            let tinted = original.re.withAlwaysOriginalTintColor(.red)
            XCTAssertNotNil(tinted)
        }
    }

    func testWithBackgroundColor() {
        let size = CGSize(width: 1, height: 1)
        let clearImage = UIImage.re(color: .clear, size: size)
        let imageWithBackgroundColor = clearImage.re.withBackgroundColor(.black)
        XCTAssertNotNil(imageWithBackgroundColor)
        let blackImage = UIImage.re(color: .black, size: size)
        XCTAssertEqual(imageWithBackgroundColor.re.averageColor()!, blackImage.re.averageColor()!, accuracy: 0.01)
    }

    func testWithCornerRadius() {
        let image = UIImage.re(color: .black, size: CGSize(width: 200, height: 200))
        XCTAssertNotNil(image.re.withRoundedCorners())
        XCTAssertNotNil(image.re.withRoundedCorners(radius: 5))
        XCTAssertNotNil(image.re.withRoundedCorners(radius: -10))
        XCTAssertNotNil(image.re.withRoundedCorners(radius: 350))
        
        let result = image.re.withRoundedCorners(radius: 50, corners: [.bottomLeft, .topRight, .topLeft], borderWidth: 10, borderColor: .red, borderLineJoin: .round)
        XCTAssertNotNil(result)
    }

    func testPNGBase64String() {
        let image = UIImage.re(color: .blue, size: CGSize(width: 1, height: 1))
        XCTAssertEqual(
            image.re.pngBase64String(),
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAADhlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAAqACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAADa6r/EAAAADUlEQVQIHWNgYPj/HwADAgH/p+FUpQAAAABJRU5ErkJggg==")
    }

    func testJPEGBase64String() {
        let image = UIImage.re(color: .blue, size: CGSize(width: 1, height: 1))
        XCTAssertEqual(
            image.re.jpegBase64String(compressionQuality: 1),
            "/9j/4AAQSkZJRgABAQAASABIAAD/4QBMRXhpZgAATU0AKgAAAAgAAgESAAMAAAABAAEAAIdpAAQAAAABAAAAJgAAAAAAAqACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/8AAEQgAAQABAwERAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf/dAAQAAf/aAAwDAQACEQMRAD8A/jnr/v4P5XP/2Q==")
    }

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func testWithAlwaysOriginalTintColor() {
        let image = UIImage.re(color: .blue, size: CGSize(width: 20, height: 20))
        XCTAssertEqual(
            image.re.withAlwaysOriginalTintColor(.red),
            image.withTintColor(.red, renderingMode: .alwaysOriginal))
    }
    
    func testPDF() {
        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let path = bundle.path(forResource: "test", ofType: "pdf")!
        let image = UIImage.re(pdf: path)
        XCTAssertNotNil(image)
        let resizedImage = UIImage.re(pdf: path, size: .re(100, 100))
        XCTAssertNotNil(resizedImage)
    }
    
    func testEmoji() {
        let emoji = "😄"
        let image = UIImage.re(emoji: emoji, size: 100)
        XCTAssertNotNil(image)
    }
}

#endif
