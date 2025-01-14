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

#if canImport(UIKit) && canImport(AVFoundation)
import AVFoundation
import UIKit
#endif

public extension ReerForEquatable where Base == URL {
    /// ReerKit: Dictionary of the URL's query parameters.
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: base, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems
        else { return nil }

        var items: [String: String] = [:]

        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }

        return items
    }

    /// ReerKit: URL with appending query parameters.
    ///
    ///        let url = URL(string: "https://google.com")!
    ///        let param = ["q": "Hello Swift"]
    ///        url.appendingQueries(params) -> "https://google.com?q=Hello%20Swift"
    ///
    /// - Returns: URL with appending given query parameters.
    func appendingQueries(_ queries: [String: String]) -> URL {
        var urlComponents = URLComponents(url: base, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queries
            .map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url ?? base
    }
    
    /// ReerKit: URL with removing query parameters.
    ///
    ///        let url = URL(string: "https://google.com?q=Hello%20Swift")!
    ///        url.removingQueries(["q"]) -> "https://google.com"
    ///
    /// - Returns: URL with appending given query parameters.
    func removingQueries(_ queries: [String]) -> URL {
        var urlComponents = URLComponents(url: base, resolvingAgainstBaseURL: true)!
        guard let queryItems = urlComponents.queryItems else { return base }
        let filtered = queryItems.filter { !queries.contains($0.name) }
        urlComponents.queryItems = filtered.isEmpty ? nil : filtered
        return urlComponents.url ?? base
    }

    /// ReerKit: Get value of a query key.
    ///
    ///    var url = URL(string: "https://google.com?code=12345")!
    ///    queryValue(for: "code") -> "12345"
    ///
    /// - Parameter key: The key of a query value.
    func queryValue(for key: String) -> String? {
        return URLComponents(string: base.absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    /// ReerKit: Returns a new URL by removing all the path components.
    ///
    ///     let url = URL(string: "https://domain.com/path/other")!
    ///     print(url.deletingAllPathComponents()) // prints "https://domain.com/"
    ///
    /// - Returns: URL with all path components removed.
    func deletingAllPathComponents() -> URL {
        guard !base.pathComponents.isEmpty else { return base }

        var url: URL = base
        for _ in 0..<base.pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    /// ReerKit: Generates new URL that does not have scheme.
    ///
    ///        let url = URL(string: "https://domain.com")!
    ///        print(url.droppedScheme()) // prints "domain.com"
    func droppedScheme() -> URL? {
        if let scheme = base.scheme {
            let droppedScheme = String(base.absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }

        guard base.host != nil else { return base }

        let droppedScheme = String(base.absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }

    #if os(iOS) || os(tvOS)
    /// ReerKit: Generate a thumbnail image from given url. Returns nil if no thumbnail could be created. This function may take some time to complete. It's recommended to dispatch the call if the thumbnail is not generated from a local resource.
    ///
    ///     var url = URL(string: "https://video.golem.de/files/1/1/20637/wrkw0718-sd.mp4")!
    ///     var thumbnail = url.thumbnail()
    ///     thumbnail = url.thumbnail(fromTime: 5)
    ///
    ///     DisptachQueue.main.async {
    ///         someImageView.image = url.thumbnail()
    ///     }
    ///
    /// - Parameter time: Seconds into the video where the image should be generated.
    /// - Returns: The UIImage result of the AVAssetImageGenerator
    func thumbnail(fromTime time: Float64 = 0) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: base))
        let time = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        var actualTime = CMTimeMake(value: 0, timescale: 0)

        guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    #endif
}

extension URL: ReerReferenceCompatible {}
public extension ReerReference where Base == URL {
    /// ReerKit: Append query parameters to URL.
    ///
    ///        var url = URL(string: "https://google.com")!
    ///        let param = ["q": "Hello Swift"]
    ///        url.appendQueryParameters(params)
    ///        print(url) // prints "https://google.com?q=Hello%20Swift"
    ///
    mutating func appendQueries(_ queries: [String: String]) {
        base.pointee = base.pointee.re.appendingQueries(queries)
    }
    
    /// ReerKit: Remove query parameters to URL.
    ///
    ///        let url = URL(string: "https://google.com?q=Hello%20Swift")!
    ///        url.removeQueries(["q"])
    ///        print(url) // "https://google.com"
    ///
    mutating func removeQueries(_ queries: [String]) {
        base.pointee = base.pointee.re.removingQueries(queries)
    }

    /// ReerKit: Remove all the path components from the URL.
    ///
    ///        var url = URL(string: "https://domain.com/path/other")!
    ///        url.deleteAllPathComponents()
    ///        print(url) // prints "https://domain.com/"
    mutating func deleteAllPathComponents() {
        guard !base.pointee.pathComponents.isEmpty else { return }

        for _ in 0..<base.pointee.pathComponents.count - 1 {
            base.pointee.deleteLastPathComponent()
        }
    }
}

// MARK: - Initializer

public extension URL {
    static func re(string: String?, relativeTo url: URL? = nil) -> URL? {
        guard var string = string?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
        
        if let directURL = URL(string: string, relativeTo: url) {
            return directURL
        }
        
        var scheme = "", host = "", path = "", query = "", fragment = ""
        
        if let schemeRange = string.range(of: "://") {
            scheme = String(string[..<schemeRange.lowerBound])
            string = String(string[schemeRange.upperBound...])
        }
        
        if let fragmentRange = string.range(of: "#") {
            fragment = String(string[fragmentRange.upperBound...])
            string = String(string[..<fragmentRange.lowerBound])
        }
        
        if let queryRange = string.range(of: "?") {
            query = String(string[queryRange.upperBound...])
            string = String(string[..<queryRange.lowerBound])
        }
        
        let components = string.split(separator: "/", maxSplits: 1)
        host = String(components.first ?? "")
        path = components.count > 1 ? "/" + components[1] : ""
        
        let encodedHost = encodeHost(host)
        let encodedPath = encodePath(path)
        let encodedQuery = encodeQuery(query)
        let encodedFragment = encodeFragment(fragment)
        
        var urlString = ""
        if !scheme.isEmpty { urlString += "\(scheme)://" }
        urlString += encodedHost
        urlString += encodedPath
        if !encodedQuery.isEmpty { urlString += "?\(encodedQuery)" }
        if !encodedFragment.isEmpty { urlString += "#\(encodedFragment)" }
        
        return URL(string: urlString, relativeTo: url)
    }
    
    private static func encodeHost(_ host: String) -> String {
        return host.re.idnaEncoded ?? host
    }
    
    private static func encodePath(_ path: String) -> String {
        let allowedCharacters = CharacterSet.urlPathAllowed.subtracting(.init(charactersIn: "/"))
        return path
            .components(separatedBy: "/")
            .map { $0.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? $0 }
            .joined(separator: "/")
    }
    
    private static func encodeQuery(_ query: String) -> String {
        guard !query.isEmpty else { return "" }
        
        return query
            .components(separatedBy: "&")
            .compactMap { component -> String? in
                let parts = component.components(separatedBy: "=")
                guard let key = parts.first, !key.isEmpty else { return nil }
                
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                
                if parts.count > 1 {
                    let value = parts[1]
                    let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
                    return "\(encodedKey)=\(encodedValue)"
                } else {
                    return encodedKey
                }
            }
            .joined(separator: "&")
    }
    
    private static func encodeFragment(_ fragment: String) -> String {
        return fragment.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? fragment
    }
}

#endif
