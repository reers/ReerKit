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

// MARK: - Initializers

public extension UIBezierPath {
    /// ReerKit: Initializes a UIBezierPath with a line from a CGPoint to another CGPoint.
    ///
    /// - Parameters:
    ///   - from: The point from which to path should start.
    ///   - otherPoint: The point where the path should end.
    static func re(from: CGPoint, to otherPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: otherPoint)
        return path
    }

    /// ReerKit: Initializes a UIBezierPath connecting the given CGPoints with straight lines.
    ///
    /// - Parameter points: The points of which the path should consist.
    static func re(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        if !points.isEmpty {
            path.move(to: points[0])
            for point in points[1...] {
                path.addLine(to: point)
            }
        }
        return path
    }

    /// ReerKit: Initializes a polygonal UIBezierPath with the given CGPoints. At least 3 points must be given.
    ///
    /// - Parameter points: The points of the polygon which the path should form.
    static func re(polygonWithPoints points: [CGPoint]) -> UIBezierPath? {
        guard points.count > 2 else { return nil }
        let path = UIBezierPath()
        path.move(to: points[0])
        for point in points[1...] {
            path.addLine(to: point)
        }
        path.close()
        return path
    }

    /// ReerKit: Initializes a UIBezierPath with an oval path of given size.
    ///
    /// - Parameters:
    ///   - size: The width and height of the oval.
    ///   - centered: Whether the oval should be centered in its coordinate space.
    static func re(ovalOf size: CGSize, centered: Bool) -> UIBezierPath {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        return UIBezierPath(ovalIn: CGRect(origin: origin, size: size))
    }

    /// ReerKit: Initializes a UIBezierPath with a  rectangular path of given size.
    ///
    /// - Parameters:
    ///   - size: The width and height of the rect.
    ///   - centered: Whether the oval should be centered in its coordinate space.
    static func re(rectOf size: CGSize, centered: Bool) -> UIBezierPath {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        return UIBezierPath(rect: CGRect(origin: origin, size: size))
    }
}

#endif

