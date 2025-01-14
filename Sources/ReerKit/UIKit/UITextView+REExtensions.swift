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

// MARK: - Methods

public extension Reer where Base: UITextView {
    /// ReerKit: Clear text.
    func clear() {
        base.text = ""
        base.attributedText = NSAttributedString(string: "")
    }

    /// ReerKit: Scroll to the bottom of text view.
    func scrollToBottom() {
        let range = NSRange(location: (base.text as NSString).length - 1, length: 1)
        base.scrollRangeToVisible(range)
    }

    /// ReerKit: Scroll to the top of text view.
    func scrollToTop() {
        let range = NSRange(location: 0, length: 1)
        base.scrollRangeToVisible(range)
    }

    /// ReerKit: Wrap to the content (Text / Attributed Text).
    func wrapToContent() {
        base.contentInset = .zero
        base.scrollIndicatorInsets = .zero
        base.contentOffset = .zero
        base.textContainerInset = .zero
        base.textContainer.lineFragmentPadding = 0
        base.sizeToFit()
    }
}

#endif
