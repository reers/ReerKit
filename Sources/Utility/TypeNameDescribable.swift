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

import Foundation

/// Return type name of an instance or a type, using by conforming this protocol.
public protocol TypeNameDescribable {

    var typeName: String { get }
    static var typeName: String { get }

    var fullTypeName: String { get }
    static var fullTypeName: String { get }
}

extension TypeNameDescribable {

    /// Return type name of an instance without module name prefix.
    ///
    ///     ModuleA.Foo().typeName -> "Foo"
    public var typeName: String {
        return String(describing: type(of: self))
    }

    /// Return type name of a type without module name prefix.
    ///
    ///     ModuleA.Foo.typeName -> "Foo"
    public static var typeName: String {
        return String(describing: self)
    }

    /// Return full type name of a type with module name prefix.
    /// But if the instance is an objective-c class object, it still return a name without module name prefix.
    ///
    ///     ModuleA.Foo().typeName -> "ModuleA.Foo"
    public var fullTypeName: String {
        return String(reflecting: type(of: self))
    }

    /// Return full type name of a type with module name prefix.
    /// But if the type is an objective-c class, it still return a name without module name prefix.
    ///
    ///     ModuleA.Foo().typeName -> "ModuleA.Foo"
    public static var fullTypeName: String {
        return String(reflecting: self)
    }
}

/// Get module name from a swift file ID.
/// - Parameter fileId: No need to pass it, just use the default.
/// - Returns: Module name, return `""` if failed.
public func moduleName(fileId: String = #fileID) -> String {
    return fileId.firstIndex(of: "/").flatMap { String(fileId[fileId.startIndex..<$0]) } ?? ""
}
