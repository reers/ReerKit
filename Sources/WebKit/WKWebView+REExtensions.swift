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

#if canImport(WebKit)
import WebKit

// MARK: - Methods

public extension Reer where Base: WKWebView {
    /// SwifterSwift: Navigate to `url`.
    /// - Parameter url: URL to navigate.
    /// - Returns: A new navigation for given `url`.
    @discardableResult
    func loadURL(_ url: URL) -> WKNavigation? {
        return base.load(URLRequest(url: url))
    }

    /// SwifterSwift: Navigate to url using `String`.
    /// - Parameter urlString: The string specifying the URL to navigate to.
    /// - Returns: A new navigation for given `urlString`.
    @discardableResult
    func loadURLString(_ urlString: String, timeout: TimeInterval? = nil) -> WKNavigation? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        if let timeout = timeout {
          request.timeoutInterval = timeout
        }
        return base.load(request)
    }
}

#endif
