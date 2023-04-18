//
//  Copyright © 2020 SwifterSwift
//  Copyright © 2022 reers.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if canImport(UIKit)
import UIKit

public extension Reer where Base: UIImage {
    /// ReerKit: Size in bytes of UIImage.
    var bytesSize: Int {
        return base.jpegData(compressionQuality: 1)?.count ?? 0
    }

    /// ReerKit: Size in kilo bytes of UIImage.
    var kilobytesSize: Int {
        return (base.jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }

    /// ReerKit: UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return base.withRenderingMode(.alwaysOriginal)
    }

    /// ReerKit: UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return base.withRenderingMode(.alwaysTemplate)
    }
    
    /// ReerKit: A new image rotated counterclockwise by a quarter‑turn (90°). ⤺
    /// The width and height will be exchanged.
    var roatatedLeft90: UIImage? {
        return rotated(by: CGFloat(90.0).re.degreesToRadians, fitSize: true)
    }
    
    /// ReerKit: A new image rotated clockwise by a quarter‑turn (90°). ⤼
    /// The width and height will be exchanged.
    var roatatedRight90: UIImage? {
        return rotated(by: CGFloat(-90.0).re.degreesToRadians, fitSize: true)
    }
    
    /// ReerKit: A new image rotated 180° . ↻
    var roatated180: UIImage? {
        return rotated(by: CGFloat(-180.0).re.degreesToRadians, fitSize: true)
    }

    #if canImport(CoreImage)
    /// ReerKit: Average color for this image.
    func averageColor() -> UIColor? {
        // https://stackoverflow.com/questions/26330924
        guard let ciImage = base.ciImage ?? CIImage(image: base) else { return nil }

        // CIAreaAverage returns a single-pixel image that contains the average color for a given region of an image.
        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        // After getting the single-pixel image from the filter extract pixel's RGBA8 data
        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = base.cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )

        // Convert pixel data to UIColor
        return UIColor(
            red: CGFloat(bitmap[0]) / 255.0,
            green: CGFloat(bitmap[1]) / 255.0,
            blue: CGFloat(bitmap[2]) / 255.0,
            alpha: CGFloat(bitmap[3]) / 255.0
        )
    }
    #endif
    
    /// ReerKit: Compressed UIImage from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional UIImage (if applicable).
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = base.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }

    /// ReerKit: Compressed UIImage data from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional Data (if applicable).
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return base.jpegData(compressionQuality: quality)
    }

    /// ReerKit: UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= base.size.width, rect.size.height <= base.size.height else { return base }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: base.scale, y: base.scale))
        guard let image = base.cgImage?.cropping(to: scaledRect) else { return base }
        return UIImage(cgImage: image, scale: base.scale, orientation: base.imageOrientation)
    }

    /// ReerKit: UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / base.size.height
        let newWidth = base.size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// ReerKit: UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / base.size.width
        let newHeight = base.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// ReerKit: Creates a copy of the receiver rotated by the given angle.
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: Measurement(value: 180, unit: .degrees))
    ///
    /// - Parameter angle: The angle measurement by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @available(tvOS 10.0, watchOS 3.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)

        let destRect = CGRect(origin: .zero, size: base.size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(
            x: destRect.origin.x.rounded(),
            y: destRect.origin.y.rounded(),
            width: destRect.width.rounded(),
            height: destRect.height.rounded()
        )

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, base.scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        base.draw(
            in: CGRect(
                origin: CGPoint(x: -base.size.width / 2, y: -base.size.height / 2),
                size: base.size
            )
        )

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// ReerKit: Returns a new rotated image (relative to the center).
    ///
    /// - Parameters:
    ///   - radians: Rotated radians in counterclockwise.⟲
    ///   - fitSize: true: new image's size is extend to fit all content.
    ///              false: image's size will not change, content may be clipped.
    /// - Returns: The new image
    func rotated(by radians: CGFloat, fitSize: Bool = true) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: base.size)
            .applying(fitSize ? CGAffineTransform.init(rotationAngle: radians) : .identity)
        let roundedDestRect = CGRect(
            x: destRect.origin.x.rounded(),
            y: destRect.origin.y.rounded(),
            width: destRect.width.rounded(),
            height: destRect.height.rounded()
        )

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, base.scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        contextRef.setShouldAntialias(true)
        contextRef.setAllowsAntialiasing(true)
        contextRef.interpolationQuality = .high
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: -radians)

        base.draw(
            in: CGRect(
                origin: CGPoint(x: -base.size.width / 2, y: -base.size.height / 2),
                size: base.size
            )
        )

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// ReerKit: UIImage filled with color
    ///
    /// - Parameter color: color to fill image with.
    /// - Returns: UIImage filled with given color.
    func filled(withColor color: UIColor) -> UIImage {
        #if !os(watchOS)
        if #available(tvOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = base.scale
            let renderer = UIGraphicsImageRenderer(size: base.size, format: format)
            return renderer.image { context in
                color.setFill()
                context.fill(CGRect(origin: .zero, size: base.size))
            }
        }
        #endif

        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return base }

        context.translateBy(x: 0, y: base.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        guard let mask = base.cgImage else { return base }
        context.clip(to: rect, mask: mask)
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// ReerKit: UIImage tinted with color.
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint.
    ///   - alpha: alpha value used to draw.
    /// - Returns: UIImage tinted with given color.
    func tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
        let drawRect = CGRect(origin: .zero, size: base.size)

        #if !os(watchOS)
        if #available(tvOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = base.scale
            return UIGraphicsImageRenderer(size: base.size, format: format).image { context in
                color.setFill()
                context.fill(drawRect)
                base.draw(in: drawRect, blendMode: blendMode, alpha: alpha)
            }
        }
        #endif

        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(drawRect)
        base.draw(in: drawRect, blendMode: blendMode, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// ReerKit: UImage with background color.
    ///
    /// - Parameters:
    ///   - backgroundColor: Color to use as background color.
    /// - Returns: UIImage with a background color that is visible where alpha < 1.
    func withBackgroundColor(_ backgroundColor: UIColor) -> UIImage {
        #if !os(watchOS)
        if #available(tvOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = base.scale
            return UIGraphicsImageRenderer(size: base.size, format: format).image { context in
                backgroundColor.setFill()
                context.fill(context.format.bounds)
                base.draw(at: .zero)
            }
        }
        #endif

        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        defer { UIGraphicsEndImageContext() }

        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: base.size))
        base.draw(at: .zero)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// ReerKit: UIImage with rounded corners.
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified.
    /// - Returns: UIImage with all corners rounded.
    func withRoundedCorners(
        radius: CGFloat? = nil,
        corners: UIRectCorner = .allCorners,
        borderWidth: CGFloat = 0,
        borderColor: UIColor? = nil,
        borderLineJoin: CGLineJoin = .miter
    ) -> UIImage {
        let maxRadius = min(base.size.width, base.size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0, radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        var corners = corners
        if corners != .allCorners && corners.contains(.allCorners) {
            corners.remove(.allCorners)
        }

        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return base
        }
        let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.size.height)
        
        let minSize = min(base.size.width, base.size.height)
        if borderWidth < minSize / 2 {
            let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: borderWidth))
            path.close()
            context.saveGState()
            path.addClip()
            guard let cgImage = base.cgImage else {
                return base
            }
            context.draw(cgImage, in: rect)
            context.restoreGState()
        }
        
        if borderColor != nil && borderWidth < minSize / 2 && borderWidth > 0 {
            let strokeInset = (Darwin.floor(borderWidth * base.scale) + 0.5) / base.scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = cornerRadius > base.scale / 2 ? cornerRadius - base.scale / 2 : 0
            let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
            path.close()
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJoin
            borderColor!.setStroke()
            path.stroke()
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? base
    }

    /// ReerKit: Base 64 encoded PNG data of the image.
    ///
    /// - Returns: Base 64 encoded PNG data of the image as a String.
    func pngBase64String() -> String? {
        return base.pngData()?.base64EncodedString()
    }

    /// ReerKit: Base 64 encoded JPEG data of the image.
    ///
    /// - Parameter: compressionQuality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
    /// - Returns: Base 64 encoded JPEG data of the image as a String.
    func jpegBase64String(compressionQuality: CGFloat) -> String? {
        return base.jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
    }

    /// ReerKit: UIImage with color uses .alwaysOriginal rendering mode.
    ///
    /// - Parameters:
    ///   - color: Color of image.
    /// - Returns: UIImage with color.
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func withAlwaysOriginalTintColor(_ color: UIColor) -> UIImage {
        return base.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}

// MARK: - Initializers

public extension UIImage {
    /// ReerKit: Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    static func re(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return UIImage()
        }

        return UIImage(cgImage: aCgImage)
    }

    /// ReerKit: Create a new image from a base 64 string.
    ///
    /// - Parameters:
    ///   - base64String: a base-64 `String`, representing the image
    ///   - scale: The scale factor to assume when interpreting the image data created from the base-64 string. Applying a scale factor of 1.0 results in an image whose size matches the pixel-based dimensions of the image. Applying a different scale factor changes the size of the image as reported by the `size` property.
    static func re(base64String: String, scale: CGFloat = 1.0) -> UIImage? {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: data, scale: scale)
    }

    /// ReerKit: Create a new image from a URL
    ///
    /// - Important:
    ///   Use this method to convert data:// URLs to UIImage objects.
    ///   Don't use this synchronous initializer to request network-based URLs. For network-based URLs, this method can block the current thread for tens of seconds on a slow network, resulting in a poor user experience, and in iOS, may cause your app to be terminated.
    ///   Instead, for non-file URLs, consider using this in an asynchronous way, using `dataTask(with:completionHandler:)` method of the URLSession class or a library such as `AlamofireImage`, `Kingfisher`, `SDWebImage`, or others to perform asynchronous network image loading.
    /// - Parameters:
    ///   - url: a `URL`, representing the image location
    ///   - scale: The scale factor to assume when interpreting the image data created from the URL. Applying a scale factor of 1.0 results in an image whose size matches the pixel-based dimensions of the image. Applying a different scale factor changes the size of the image as reported by the `size` property.
    static func re(url: URL, scale: CGFloat = 1.0) throws -> UIImage? {
        let data = try Data(contentsOf: url)
        return UIImage(data: data, scale: scale)
    }
}

#endif

