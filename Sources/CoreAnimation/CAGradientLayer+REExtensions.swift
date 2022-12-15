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

#if !os(watchOS) && !os(Linux) && canImport(QuartzCore)
import QuartzCore

public extension CAGradientLayer {
    /// ReerKit: Creates a CAGradientLayer with the specified colors, location, startPoint, endPoint, and type.
    ///
    /// - Parameters:
    ///   - colors: An array of colors defining the color of each gradient stop.
    ///   - locations: An array of NSNumber defining the location of each
    ///                gradient stop as a value in the range [0, 1]. The values must be
    ///                monotonically increasing. If a nil array is given, the stops are
    ///                assumed to spread uniformly across the [0, 1] range. When rendered,
    ///                the colors are mapped to the output colorspace before being
    ///                interpolated (default is nil).
    ///   - startPoint: start point corresponds to the first gradient stop (I.e. [0,0] is the bottom-corner of the layer, [1,1] is the top-right corner).
    ///   - endPoint: end point corresponds to the last gradient stop
    ///   - type: The kind of gradient that will be drawn. Currently, the only allowed values are `axial' (the default value), `radial', and `conic'.
    static func re(
        colors: [REColor],
        locations: [CGFloat]? = nil,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1),
        type: CAGradientLayerType = .axial
    ) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map(\.cgColor)
        gradient.locations = locations?.map { NSNumber(value: Double($0)) }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.type = type
        return gradient
    }
}

#endif
