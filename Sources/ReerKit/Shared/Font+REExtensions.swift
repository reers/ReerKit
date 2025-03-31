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

#if !os(Linux)

#if canImport(UIKit)
import UIKit
/// ReerKit: Font
public typealias REFont = UIFont
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
/// ReerKit: Font
public typealias REFont = NSFont
#endif

public extension REFont {
    /// Ultra Light weight (W1)
    /// Weight value: 100
    static func re(ultraLight fontSize: CGFloat) -> REFont {
        return REFont.systemFont(ofSize: fontSize, weight: .ultraLight)
    }
    
    /// Thin weight (W2)
    /// Weight value: 200
    static func re(thin fontSize: CGFloat) -> REFont {
        return REFont.systemFont(ofSize: fontSize, weight: .thin)
    }
    
    /// Light weight (W3)
    /// Weight value: 300
    static func re(light fontSize: CGFloat) -> REFont {
        return REFont.systemFont(ofSize: fontSize, weight: .light)
    }
    
    /// Regular weight (W4)
    /// Weight value: 400
    /// This is the default system font weight
    static func re(regular fontSize: CGFloat) -> REFont {
        return REFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    /// Medium weight (W5)
    /// Weight value: 500
    static func re(medium fontSize: CGFloat) -> REFont {
        return REFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    /// Semibold weight (W6)
    /// Weight value: 600
    /// Also known as Demibold
    static func re(semibold fontSize: CGFloat) -> REFont {
        return REFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    
    /// Bold weight (W7)
    /// Weight value: 700
    static func re(bold fontSize: CGFloat) -> REFont {
        return REFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    /// Heavy weight (W8)
    /// Weight value: 800
    /// Also known as Extra Bold
    static func re(heavy fontSize: CGFloat) -> REFont {
        return REFont.systemFont(ofSize: fontSize, weight: .heavy)
    }
    
    /// Black weight (W9)
    /// Weight value: 900
    /// The heaviest weight
    static func re(black fontSize: CGFloat) -> REFont {
        return REFont.systemFont(ofSize: fontSize, weight: .black)
    }
}

#endif
