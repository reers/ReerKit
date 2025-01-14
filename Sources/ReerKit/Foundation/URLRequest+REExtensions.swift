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

#if canImport(Foundation)
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Initializers

public extension URLRequest {
    /// ReerKit: Create URLRequest from URL string.
    ///
    /// - Parameter urlString: URL string to initialize URL request from
    static func re(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return .init(url: url)
    }
}

public extension ReerForEquatable where Base == URLRequest {
    /// ReerKit: cURL command representation of this URL request.
    var curlString: String {
        guard let url = base.url else { return "" }

        var baseCommand = "curl \(url.absoluteString)"
        if base.httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]
        if let method = base.httpMethod, method != "GET", method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = base.allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = base.httpBody,
            let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}

#endif
