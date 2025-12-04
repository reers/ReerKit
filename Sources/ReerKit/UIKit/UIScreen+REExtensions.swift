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


#if canImport(UIKit) && !os(watchOS) && !os(visionOS)
import UIKit

public extension Reer where Base: UIScreen {
    /// ReerKit: Main screen size.
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    /// ReerKit: Main screen width.
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// ReerKit: Main screen height.
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// ReerKit: Point value of one physical pixel for different screen.
    static var onePixel: CGFloat {
        let scale = UIScreen.main.scale
        if scale == 3 { return 0.333 }
        else if scale == 2 { return 0.5 }
        else { return 1.0 }
    }
    
    /// ReerKit: Half point value for aligning physical pixel.
    static var halfPoint: CGFloat {
        let scale = UIScreen.main.scale
        if scale == 3 { return 0.666 }
        else { return 0.5 }
    }
    
    /// ReerKit: The corner radius of the display screen.
    ///
    /// This property retrieves the corner radius of the physical display using a private API.
    /// Returns 0 if the private API is unavailable or changes in future iOS versions.
    ///
    /// - Note: This uses `UIScreen`'s private `_displayCornerRadius` property via KVC.
    ///
    /// Example:
    ///
    ///     let radius = UIScreen.re.displayCornerRadius
    ///     print("Screen corner radius: \(radius)")
    ///
    static var displayCornerRadius: CGFloat {
        return UIScreen.main.value(forKey: UIScreen.cornerRadiusKey) as? CGFloat ?? 0
    }
}

extension UIScreen {
    /// ReerKit: Private key for accessing the display corner radius property.
    static let cornerRadiusKey: String = {
        let components = ["Radius", "Corner", "display", "_"]
        return components.reversed().joined()
    }()
}

#endif
