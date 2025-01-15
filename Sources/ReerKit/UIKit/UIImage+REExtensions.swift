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

#if canImport(Accelerate)
import Accelerate
#endif

#if canImport(Darwin)
import Darwin
#endif

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
    
    /// ReerKit: Whether this image has alpha channel.
    var hasAlphaChannel: Bool {
        guard let cgImage = base.cgImage else {
            return false
        }
        let alpha = CGImageAlphaInfo(rawValue: cgImage.alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
        return (alpha == .first
            || alpha == .last
            || alpha == .premultipliedFirst
            || alpha == .premultipliedLast)
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
    
    /// ReerKit: Pick the color at a point of the image.
    /// It will return nil if the point is out of bounds.
    func color(at point: CGPoint) -> UIColor? {
        guard point.x >= 0 && point.x <= base.size.width && point.y >= 0 && point.y <= base.size.height,
              let cgImage = base.cgImage,
              let provider = cgImage.dataProvider,
              let providerData = provider.data,
              let data = CFDataGetBytePtr(providerData)
        else {
            return nil
        }
        
        let width = cgImage.width
        let bytesPerPixel = 4
        
        let pixelDataIndex = ((width * Int(point.y)) + Int(point.x)) * bytesPerPixel
        
        var rIndex = 0
        var gIndex = 1
        var bIndex = 2
        var aIndex = 3
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1.0
        
        var littleEndian = false
        if cgImage.bitmapInfo.contains(.byteOrder32Little) || cgImage.bitmapInfo.contains(.byteOrder16Little) {
            littleEndian = true
        }
        
        let alphaInfo = cgImage.alphaInfo
        
        // Check the alphaInfo
        switch alphaInfo {
            
        // RGB
        case .none:
            // BGR
            if littleEndian {
                rIndex = 2
                gIndex = 1
                bIndex = 0
            }
            r = CGFloat(data[pixelDataIndex + rIndex]) / 255.0
            g = CGFloat(data[pixelDataIndex + gIndex]) / 255.0
            b = CGFloat(data[pixelDataIndex + bIndex]) / 255.0
        
        // A
        case .alphaOnly:
            return .clear
        
        // RGBA or RGBX
        case .last, .premultipliedLast, .noneSkipLast:
            // ABGR or XBGR
            if littleEndian {
                aIndex = 0
                bIndex = 1
                gIndex = 2
                rIndex = 3
            }
            if alphaInfo != .noneSkipLast {
                a = CGFloat(data[pixelDataIndex + aIndex]) / 255.0
            }
            r = CGFloat(data[pixelDataIndex + rIndex]) / 255.0
            g = CGFloat(data[pixelDataIndex + gIndex]) / 255.0
            b = CGFloat(data[pixelDataIndex + bIndex]) / 255.0
            
            if alphaInfo == .premultipliedLast && a != .zero {
                r = r / a
                g = g / a
                b = b / a
            }
        
        // ARGB or XRGB
        case .first, .premultipliedFirst, .noneSkipFirst:
            // BGRA or BGRX
            if littleEndian {
                bIndex = 0
                gIndex = 1
                rIndex = 2
                aIndex = 3
            } else {
                aIndex = 0
                rIndex = 1
                gIndex = 2
                bIndex = 3
            }
            if alphaInfo != .noneSkipFirst {
                a = CGFloat(data[pixelDataIndex + aIndex]) / 255.0
            }
            r = CGFloat(data[pixelDataIndex + rIndex]) / 255.0
            g = CGFloat(data[pixelDataIndex + gIndex]) / 255.0
            b = CGFloat(data[pixelDataIndex + bIndex]) / 255.0
            
            if alphaInfo == .premultipliedFirst && a != .zero {
                r = r / a
                g = g / a
                b = b / a
            }
        default:
            break
        }
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
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

    /// ReerKit: UIImage blended with color.
    ///
    /// - Parameters:
    ///   - color: color to blend image with.
    ///   - mode: how to blend the tint.
    ///   - alpha: alpha value used to draw.
    /// - Returns: UIImage tinted with given color.
    func blend(_ color: UIColor, mode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
        let drawRect = CGRect(origin: .zero, size: base.size)

        #if !os(watchOS)
        if #available(tvOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = base.scale
            return UIGraphicsImageRenderer(size: base.size, format: format).image { context in
                color.setFill()
                context.fill(drawRect)
                base.draw(in: drawRect, blendMode: mode, alpha: alpha)
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
        base.draw(in: drawRect, blendMode: mode, alpha: alpha)
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

    ///  ReerKit: UIImage with rounded corners.
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified.
    ///   - corners: corners
    ///   - borderWidth: borderWidth
    ///   - borderColor: borderColor
    ///   - borderLineJoin: borderLineJoin
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
        if corners != .allCorners {
            var temp: UIRectCorner = []
            if corners.contains(.topLeft) { temp.insert(.bottomLeft) }
            if corners.contains(.topRight) { temp.insert(.bottomRight) }
            if corners.contains(.bottomLeft) { temp.insert(.topLeft) }
            if corners.contains(.bottomRight) { temp.insert(.topRight) }
            corners = temp
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
    
    /// ReerKit: Returns a new image which is edge inset from this image.
    ///
    /// - Parameters:
    ///   - insets: Inset (positive) for each of the edges, values can be negative to 'outset'.
    ///   - color: Extend edge's fill color, nil means clear color.
    /// - Returns: The new image
    func withEdge(byInsets insets: UIEdgeInsets, color: UIColor?) -> UIImage? {
        let allEdgesArePositive = insets.top >= 0 && insets.left >= 0 && insets.bottom >= 0 && insets.right >= 0
        let allEdgesAreNegative = insets.top <= 0 && insets.left <= 0 && insets.bottom <= 0 && insets.right <= 0
        guard allEdgesArePositive || allEdgesAreNegative else { return nil }
        var size = base.size
        size.width -= insets.left + insets.right
        size.height -= insets.top + insets.bottom
        if size.width <= 0 || size.height <= 0 { return nil }
        var rect: CGRect
        if allEdgesArePositive {
            rect = CGRect(x: insets.left, y: insets.top, width: size.width, height: size.height)
        } else {
            rect = CGRect(x: -insets.left, y: -insets.top, width: base.size.width, height: base.size.height)
        }
        UIGraphicsBeginImageContextWithOptions(allEdgesArePositive ? base.size : size, false, base.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        if let color = color {
            context.setFillColor(color.cgColor)
            let path = CGMutablePath()
            if allEdgesArePositive {
                path.addRect(CGRect.init(x: 0, y: 0, width: base.size.width, height: base.size.height))
            } else {
                path.addRect(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
            }
            path.addRect(rect)
            
            context.addPath(path)
            context.fillPath(using: .evenOdd)
        }
        base.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// ReerKit: Base 64 encoded PNG data of the image.
    ///
    /// - Returns: Base 64 encoded PNG data of the image as a String.
    func pngBase64String() -> String? {
        return base.pngData()?.base64EncodedString()
    }

    /// ReerKit: Base 64 encoded JPEG data of the image.
    ///
    /// - Parameter compressionQuality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
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

// MARK: - Transform

public extension Reer where Base: UIImage {
    /// ReerKit: A new image rotated counterclockwise by a quarter‑turn (90°). ⤺
    /// The width and height will be exchanged.
    var rotateLeft90: UIImage? {
        return rotated(by: CGFloat(90.0).re.degreesToRadians, fitSize: true)
    }
    
    /// ReerKit: A new image rotated clockwise by a quarter‑turn (90°). ⤼
    /// The width and height will be exchanged.
    var rotateRight90: UIImage? {
        return rotated(by: CGFloat(-90.0).re.degreesToRadians, fitSize: true)
    }
    
    /// ReerKit: A new image rotated 180° . ↻
    var rotate180: UIImage? {
        return rotated(by: CGFloat(-180.0).re.degreesToRadians, fitSize: true)
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
    func resize(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
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
    func resize(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / base.size.width
        let newHeight = base.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    #if !os(watchOS)
    /// ReerKit: Returns a new image which is scaled from this image.
    /// The image content will be changed with the contentMode.
    ///
    /// - Parameters:
    ///   - size: The new size to be scaled, values should be positive.
    ///   - contentMode: The content mode for image content.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: The new image with the given size.
    func resize(to size: CGSize, contentMode: UIView.ContentMode = .scaleToFill, opaque: Bool = false) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, opaque, base.scale)
        base.re.draw(inRect: CGRect.init(x: 0, y: 0, width: size.width, height: size.height), contentMode: contentMode, clipsToBounds: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// ReerKit: Draws the entire image in the specified rectangle, content changed with
    /// the contentMode.
    ///
    /// - Note: This method draws the entire image in the current graphics context,
    /// respecting the image's orientation setting. In the default coordinate system,
    /// images are situated down and to the right of the origin of the specified
    /// rectangle. This method respects any transforms applied to the current graphics
    /// context, however.
    ///
    /// - Parameters:
    ///   - rect: The rectangle in which to draw the image.
    ///   - contentMode: Draw content mode
    ///   - clipsToBounds: A Boolean value that determines whether content are confined to the rect.
    func draw(inRect rect: CGRect, contentMode: UIView.ContentMode, clipsToBounds: Bool) {
        let drawRect = base.size.re.fit(inRect: rect, mode: contentMode)
        if drawRect.size.width == 0 || drawRect.size.height == 0 {
            return
        }
        if clipsToBounds {
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            context.saveGState()
            context.addRect(rect)
            context.clip()
            base.draw(in: drawRect)
            context.restoreGState()
        }
        else {
            base.draw(in: drawRect)
        }
    }
    #endif
    
    #if canImport(Accelerate)
    /// ReerKit: A vertically flipped image. ⥯
    var flipVertical: UIImage? {
        return flip(horizontal: false, vertical: true)
    }
    
    /// ReerKit: A horizontally flipped image. ⇋
    var flipHorizontal: UIImage? {
        return flip(horizontal: true, vertical: false)
    }
    
    private func flip(horizontal: Bool, vertical: Bool) -> UIImage? {
        guard let cgImage = base.cgImage else {
            return nil
        }
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerRow = width * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo.byteOrderDefault.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        ) else {
            return nil
        }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let data = context.data else {
            return nil
        }
        var src = vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        var dest = vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        if vertical {
            vImageVerticalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        if horizontal {
            vImageHorizontalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        guard let image = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: image, scale: base.scale, orientation: base.imageOrientation)
    }
    #endif
}

// MARK: - Blur
#if canImport(Accelerate) && canImport(Darwin) && !os(watchOS)

public extension Reer where Base: UIImage {
    
    /// ReerKit: Applies a blur effect to this image. Suitable for blur any content.
    var blurSoft: UIImage? {
        return blur(radius: 60, tintColor: UIColor(white: 0.84, alpha: 0.36), tintBlendMode: .normal, saturation: 1.8, maskImage: nil)
    }
    
    /// ReerKit: Applies a blur effect to this image. Suitable for blur any content except pure white.
    /// (same as iOS Control Panel)
    var blurLight: UIImage? {
        return blur(radius: 60, tintColor: UIColor(white: 1.0, alpha: 0.3), tintBlendMode: .normal, saturation: 1.8, maskImage: nil)
    }
    
    /// ReerKit: Applies a blur effect to this image. Suitable for displaying black text.
    /// (same as iOS Navigation Bar White)
    var blurExtraLight: UIImage? {
        return blur(radius: 40, tintColor: UIColor(white: 0.97, alpha: 0.82), tintBlendMode: .normal, saturation: 1.8, maskImage: nil)
    }
    
    /// ReerKit: Applies a blur effect to this image. Suitable for displaying white text.
    /// (same as iOS Notification Center)
    var blurDark: UIImage? {
        return blur(radius: 40, tintColor: UIColor(white: 0.11, alpha: 0.73), tintBlendMode: .normal, saturation: 1.8, maskImage: nil)
    }
    
    /// ReerKit: Applies a blur and tint color to this image.
    ///
    /// - Parameter tintColor: The tint color.
    /// - Returns: The new image
    func blurWithTintColor(_ tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = tintColor.cgColor.numberOfComponents
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        }
        else {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            if tintColor.getRed(&r, green: &g, blue: &b, alpha: nil) {
                effectColor = UIColor(red: r, green: g, blue: b, alpha: effectColorAlpha)
            }
        }
        return blur(radius: 20, tintColor: effectColor, tintBlendMode: .normal, saturation: -1.0, maskImage: nil)
    }
    
    /// ReerKit: Applies a blur, tint color, and saturation adjustment to this image,
    /// optionally within the area specified by @a maskImage.
    ///
    /// - Parameters:
    ///   - radius: The radius of the blur in points, 0 means no blur effect.
    ///   - tintColor: An optional UIColor object that is uniformly blended with
    ///                the result of the blur and saturation operations. The
    ///                alpha channel of this color determines how strong the
    ///                tint is. nil means no tint.
    ///   - tintBlendMode: The @a tintColor blend mode.
    ///                    Default is CGBlendMode.normal.
    ///   - saturation: A value of 1.0 produces no change in the resulting image.
    ///                 Values less than 1.0 will desaturation the resulting image
    ///                 while values greater than 1.0 will have the opposite effect.
    ///                 0 means gray scale.
    ///   - maskImage: If specified, @a inputImage is only modified in the area(s)
    ///                defined by this mask.  This must be an image mask or it
    ///                must meet the requirements of the mask parameter of
    ///                CGContextClipToMask.
    /// - Returns: The blured new Image
    func blur(
        radius: CGFloat,
        tintColor: UIColor? = nil,
        tintBlendMode: CGBlendMode,
        saturation: CGFloat,
        maskImage: UIImage? = nil
    ) -> UIImage? {
        if (base.size.width < 1 || base.size.height < 1) {
            assertionFailure("*** error: invalid size: \(base.size.width) x \(base.size.height). Both dimensions must be >= 1: \(base)")
            return nil
        }
        guard let cgImage = base.cgImage else {
            assertionFailure("*** error: image must be backed by a CGImage: \(base)")
            return nil
        }
        if maskImage != nil && maskImage!.cgImage == nil {
            assertionFailure("*** error: maskImage must be backed by a CGImage: \(String(describing: maskImage))")
            return nil
        }
        #if os(visionOS)
        let screenScale: CGFloat = 1.0
        #else
        let screenScale = UIScreen.main.scale
        #endif
        let imageRect = CGRect(origin: CGPoint.zero, size: base.size)
        var effectImage: UIImage = base
        
        let hasBlur = radius > CGFloat.ulpOfOne
        let hasSaturationChange = Swift.abs(saturation - 1.0) > CGFloat.ulpOfOne
        
        if hasBlur || hasSaturationChange {
            func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
                let data = context.data
                let width = vImagePixelCount(context.width)
                let height = vImagePixelCount(context.height)
                let rowBytes = context.bytesPerRow
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
            }
            
            UIGraphicsBeginImageContextWithOptions(base.size, false, screenScale)
            guard let effectInContext = UIGraphicsGetCurrentContext() else { return  nil }
            
            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -base.size.height)
            effectInContext.draw(cgImage, in: imageRect)
            
            var effectInBuffer = createEffectBuffer(effectInContext)
            
            
            UIGraphicsBeginImageContextWithOptions(base.size, false, screenScale)
            
            guard let effectOutContext = UIGraphicsGetCurrentContext() else { return  nil }
            var effectOutBuffer = createEffectBuffer(effectOutContext)
            
            
            if hasBlur {
                let inputRadius = radius * screenScale
                let d = Darwin.floor(inputRadius * 3.0 * sqrt(2 * CGFloat.pi) / 4 + 0.5)
                var radius = UInt32(d)
                if radius % 2 != 1 {
                    radius += 1
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturation
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,                    1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(base.size, false, screenScale)
        
        guard let outputContext = UIGraphicsGetCurrentContext() else { return nil }
        
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -base.size.height)
        
        outputContext.draw(cgImage, in: imageRect)
        
        if hasBlur {
            outputContext.saveGState()
            if let maskCGImage = maskImage?.cgImage {
                outputContext.clip(to: imageRect, mask: maskCGImage);
            }
            outputContext.draw(effectImage.cgImage!, in: imageRect)
            outputContext.restoreGState()
        }
        
        if let color = tintColor {
            outputContext.saveGState()
            outputContext.setBlendMode(tintBlendMode)
            outputContext.setFillColor(color.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}
#endif

// MARK: - Filter
#if canImport(Accelerate) && canImport(CoreImage)

public struct ImageFilterName: ExpressibleByStringLiteral, Hashable, RawRepresentable {
    
    public static let chrome: Self = "CIPhotoEffectChrome"
    public static let fade: Self = "CIPhotoEffectFade"
    public static let instant: Self = "CIPhotoEffectInstant"
    public static let mono: Self = "CIPhotoEffectMono"
    public static let noir: Self = "CIPhotoEffectNoir"
    public static let process: Self = "CIPhotoEffectProcess"
    public static let tonal: Self = "CIPhotoEffectTonal"
    public static let transfer: Self =  "CIPhotoEffectTransfer"
        
    public typealias StringLiteralType = String
    
    public private(set) var rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

public extension Reer where Base: UIImage {
    /// ReerKit: A grayscaled image.
    var grayscale: UIImage? {
        // A value of experience
        if base.size.width * base.size.height < 670 * 670 {
            guard let cgImage = base.cgImage else { return nil }
            let colorSpace = CGColorSpaceCreateDeviceGray()
            guard let context = CGContext(
                data: nil,
                width: cgImage.width,
                height: cgImage.height,
                bitsPerComponent: 8,
                bytesPerRow: cgImage.width,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.none.rawValue
            ) else { return nil }

            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
            guard let grayscaleImage = context.makeImage() else { return nil }
            return applyAlpha(from: cgImage, to: grayscaleImage)
        } else {
            return with(filter: .mono)
        }
    }
    
    /// ReerKit:
    /// - Parameter filterName: Name of the filter.
    /// - Returns: A filtered image.
    func with(filter filterName: ImageFilterName) -> UIImage? {
        guard let cgImage = base.cgImage,
              let filter = CIFilter(name: filterName.rawValue)
        else { return nil }
        let original = CIImage(cgImage: cgImage)
        filter.setValue(original, forKey: kCIInputImageKey)
        guard let filtered = filter.outputImage else { return nil }
        let context = CIContext(options: nil)
        let cgimage = context.createCGImage(
            filtered,
            from: CGRect(x: 0, y: 0, width: base.size.width * base.scale, height: base.size.height * base.scale)
        )
        return UIImage(cgImage: cgimage!, scale: base.scale, orientation: base.imageOrientation)
    }
    
    private func applyAlpha(from originalCGImage: CGImage, to grayscaleCGImage: CGImage) -> UIImage? {
        guard let alphaData = originalCGImage.alphaData else { return UIImage(cgImage: grayscaleCGImage) }

        guard let context = CGContext(
            data: nil,
            width: originalCGImage.width,
            height: originalCGImage.height,
            bitsPerComponent: 8,
            bytesPerRow: originalCGImage.width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue
        ) else { return nil }

        alphaData.withUnsafeBytes { buffer in
            if let baseAddress = buffer.baseAddress {
                context.data?.copyMemory(from: baseAddress, byteCount: alphaData.count)
            }
        }
        guard let alphaMask = context.makeImage() else { return nil }
        guard let finalCGImage = grayscaleCGImage.masking(alphaMask) else { return nil }
        return UIImage(cgImage: finalCGImage)
    }
}
#endif

// MARK: - Initializers

public extension UIImage {
    /// ReerKit: Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    static func re(color: UIColor, size: CGSize = .init(width: 1, height: 1)) -> UIImage {
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
    
    #if !os(watchOS)
    /// ReerKit: Create an image from a PDF file data or path.
    ///
    /// - Parameter dataOrPath: PDF data in `Data`, or PDF file path in `String`.
    /// - Returns: A new image create from PDF, or nil when an error occurs.
    static func re(pdf dataOrPath: Any) -> UIImage? {
        return image(withPDF: dataOrPath, resize: false, size: CGSize.zero)
    }
    
    /// ReerKit: Create an image from a PDF file data or path.
    ///
    /// - Parameters:
    ///   - dataOrPath: PDF data in `Data`, or PDF file path in `String`.
    ///   - size: The new image's size, PDF's content will be stretched as needed.
    /// - Returns: A new image create from PDF, or nil when an error occurs.
    static func re(pdf dataOrPath: Any, size: CGSize) -> UIImage? {
        return image(withPDF: dataOrPath, resize: true, size: size)
    }
    
    private static func image(withPDF dataOrPath: Any, resize: Bool, size: CGSize) -> UIImage? {
        var pdf: CGPDFDocument?
        if dataOrPath is Data {
            let provider = CGDataProvider(data: dataOrPath as! CFData)
            pdf = CGPDFDocument.init(provider!)
        }
        else if dataOrPath is String {
            pdf = CGPDFDocument.init(URL(fileURLWithPath: dataOrPath as! String) as CFURL)
        }
        if pdf == nil { return nil }
        guard let page = pdf?.page(at: 1) else { return nil }
        let pdfRect = page.getBoxRect(.cropBox)
        let pdfSize = resize ? size : pdfRect.size
        #if os(visionOS)
        let scale: CGFloat = 1.0
        #else
        let scale = UIScreen.main.scale
        #endif
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: Int(pdfSize.width * scale),
            height: Int(pdfSize.height * scale),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo.byteOrderDefault.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        ) else { return nil }
        context.scaleBy(x: CGFloat(context.width) / pdfRect.width, y: CGFloat(context.height) / pdfRect.height)
        context.drawPDFPage(page)
        guard let image = context.makeImage() else { return nil }
        return UIImage(cgImage: image, scale: scale, orientation: .up)
    }
    
    /// ReerKit: Create a square image from apple emoji.
    ///
    /// - Parameters:
    ///   - emoji: single emoji, such as "😄".
    ///   - size: image's size.
    /// - Returns: Image from emoji, or nil when an error occurs.
    static func re(emoji: String, size: CGFloat) -> UIImage? {
        if emoji.count == 0 || size < 1 {
            return nil
        }
        #if os(visionOS)
        let scale: CGFloat = 1.0
        #else
        let scale = UIScreen.main.scale
        #endif
        let font = CTFontCreateWithName("AppleColorEmoji" as CFString, size * scale, nil)
        let str = NSAttributedString(string: emoji, attributes: [kCTFontAttributeName as NSAttributedString.Key: font, kCTForegroundColorAttributeName as NSAttributedString.Key: UIColor.white.cgColor])
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: Int(size * scale),
            height: Int(size * scale),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo:  CGBitmapInfo.byteOrderDefault.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        ) else { return nil }
        
        context.interpolationQuality = .high
        let line = CTLineCreateWithAttributedString(str as CFAttributedString)
        let bounds = CTLineGetBoundsWithOptions(line, .useGlyphPathBounds)
        context.textPosition = CGPoint(x: 0, y: -bounds.origin.y)
        CTLineDraw(line, context)
        guard let cgImage = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
    #endif
}

/// A combination data of every pixel's alpha data.
fileprivate extension CGImage {
    var alphaData: Data? {
        guard let dataProvider = self.dataProvider,
              let data = dataProvider.data,
              let rawData = CFDataGetBytePtr(data)
        else { return nil }

        var alphaData = Data(capacity: width * height)
        let bytesPerPixel = bitsPerPixel / bitsPerComponent
        let alphaOffset: Int

        switch alphaInfo {
        case .premultipliedLast, .last, .noneSkipLast:
            alphaOffset = bytesPerPixel - 1
        case .premultipliedFirst, .first, .noneSkipFirst:
            alphaOffset = 0
        default:
            return nil
        }

        for y in 0 ..< height {
            for x in 0 ..< width {
                let pixelIndex = (width * y + x) * bytesPerPixel
                alphaData.append(rawData[pixelIndex + alphaOffset])
            }
        }

        return alphaData
    }
}

#endif

