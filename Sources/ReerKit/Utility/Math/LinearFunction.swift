//
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

#if canImport(CoreGraphics)

import CoreGraphics

/// ReerKit: Represents a linear function of the form y = mx + b
public struct LinearFunction: CustomStringConvertible {
    
    /// The slope (m) of the linear function
    public let slope: Double
    
    /// The y-intercept (b) of the linear function
    public let intercept: Double
    
    /// Initializes a LinearFunction with a given slope and y-intercept
    /// - Parameters:
    ///   - slope: The slope of the line
    ///   - intercept: The y-intercept of the line
    public init(slope: Double, intercept: Double) {
        self.slope = slope
        self.intercept = intercept
    }
    
    /// Initializes a LinearFunction from two points on the line
    /// - Parameters:
    ///   - point1: The first point on the line
    ///   - point2: The second point on the line
    public init(point1: CGPoint, point2: CGPoint) {
        self.slope = (point2.y - point1.y) / (point2.x - point1.x)
        self.intercept = point1.y - (self.slope * point1.x)
    }
    
    /// Calculates the y value for a given x value
    ///
    ///     let linear = LinearFunction(slope: 2, intercept: 5)
    ///     let y = linear(x: 3)
    ///
    /// - Parameter x: The x value
    /// - Returns: The corresponding y value
    public func callAsFunction(x: Double) -> Double {
        return slope * x + intercept
    }
    
    /// Calculates the x value for a given y value
    ///
    ///     let linear = LinearFunction(slope: 2, intercept: 5)
    ///     let x = linear(y: 11)
    ///
    /// - Parameter y: The y value
    /// - Returns: The corresponding x value
    public func callAsFunction(y: Double) -> Double {
        return (y - intercept) / slope
    }
    
    /// A string representation of the linear function
    public var description: String {
        return "y = \(String(format: "%.2f", slope))x + \(String(format: "%.2f", intercept))"
    }
}

#endif
