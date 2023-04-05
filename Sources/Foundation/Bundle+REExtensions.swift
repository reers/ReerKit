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

public extension Reer where Base: Bundle {
    /// ReerKit: Return the main bundle's `CFBundleDisplayName` or `CFBundleName`
    static var appDisplayName: String {
        if let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return displayName
        } else if let name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        }
        return ""
    }
    
    /// ReerKit: Return the main bundle's `CFBundleShortVersionString`
    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// ReerKit: Return the main bundle's bundle identifier.
    static var appBundleID: String {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }
}

#endif
