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

#if canImport(Foundation)
import Foundation

// MARK: - Initializer

public extension URL {
    static func re(string: String?, relativeTo url: URL? = nil) -> URL? {
        guard var string = string else { return nil }
        string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        var result: URL? = nil
        if url != nil {
            result = URL(string: string, relativeTo: url)
        } else {
            result = URL(string: string)
        }
        if result != nil { return result }

        var sourceString = string
        var fragment = ""
        if let fragmentRange = string.range(of: "#") {
            sourceString = String(string[..<fragmentRange.lowerBound])
            fragment = String(string[fragmentRange.lowerBound...])
        }
        let substrings = sourceString.components(separatedBy: "?")
        if substrings.count > 1 {
            let beforeQuery = substrings[0]
            let queryString = substrings[1]
            let params = queryString.components(separatedBy: "&")
            var encodedParams: [String: String] = [:]
            for param in params {
                let keyValue = param.components(separatedBy: "=")
                if keyValue.count > 1 {
                    let key = keyValue[0]
                    var value = keyValue[1]
                    value = decode(with: value)
                    let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .reerURLAllowed)
                    encodedParams[key] = encodedValue
                }
            }
            let encodedURLString = "\(beforeQuery)?\(encodedParams.re.queryString)\(fragment))"
            if let url = url {
                result = URL(string: encodedURLString, relativeTo: url)
            } else {
                result = URL(string: encodedURLString)
            }
        }

        if result == nil {
            if let encodedString = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                result = URL(string: encodedString)
            }
        }
        assert(result != nil, "Fail to create a URL.")
        return result
    }

    private static func decode(with urlString: String) -> String {
        guard let _ = urlString.range(of: "%") else {
            return urlString
        }
        return urlString.removingPercentEncoding ?? urlString
    }
}

private extension CharacterSet {
    static var reerURLAllowed: CharacterSet {
        return CharacterSet(charactersIn: ":/?#@!$&'(){}*+=")
    }
}

#endif
