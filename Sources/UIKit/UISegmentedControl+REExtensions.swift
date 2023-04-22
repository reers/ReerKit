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

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Properties

public extension Reer where Base: UISegmentedControl {
    /// ReerKit: Segments titles.
    var segmentTitles: [String] {
        get {
            let range = 0..<base.numberOfSegments
            return range.compactMap { base.titleForSegment(at: $0) }
        }
        set {
            base.removeAllSegments()
            for (index, title) in newValue.enumerated() {
                base.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }

    /// ReerKit: Segments images.
    var segmentImages: [UIImage] {
        get {
            let range = 0..<base.numberOfSegments
            return range.compactMap { base.imageForSegment(at: $0) }
        }
        set {
            base.removeAllSegments()
            for (index, image) in newValue.enumerated() {
                base.insertSegment(with: image, at: index, animated: false)
            }
        }
    }
}

#endif
