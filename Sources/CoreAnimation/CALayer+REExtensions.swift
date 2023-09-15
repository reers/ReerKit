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

#if !os(watchOS) && !os(Linux) && canImport(QuartzCore) && canImport(UIKit)
import QuartzCore
import UIKit

public extension Reer where Base: CALayer {
    
    /// ReerKit: Add shadow to layer.
    ///
    /// - Note: This method only works with non-clear background color, or if the view has a `shadowPath` set.
    /// See parameter `opacity` for detail.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5). It will also be affected by the `alpha` of `backgroundColor`.
    func addShadow(
        ofColor color: REColor = REColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5,
        path: CGPath? = nil
    ) {
        base.shadowColor = color.cgColor
        base.shadowOffset = offset
        base.shadowRadius = radius
        base.shadowOpacity = opacity
        base.shadowPath = path
        base.masksToBounds = false
    }
}

#endif
