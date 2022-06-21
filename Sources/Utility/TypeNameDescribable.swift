//
//  TypeNameDescribable.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/12.
//

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
        String(describing: type(of: self))
    }

    /// Return type name of a type without module name prefix.
    ///
    ///     ModuleA.Foo.typeName -> "Foo"
    public static var typeName: String {
        String(describing: self)
    }

    /// Return full type name of a type with module name prefix.
    /// But if the instance is an objective-c class object, it still return a name without module name prefix.
    ///
    ///     ModuleA.Foo().typeName -> "ModuleA.Foo"
    public var fullTypeName: String {
        String(reflecting: type(of: self))
    }

    /// Return full type name of a type with module name prefix.
    /// But if the type is an objective-c class, it still return a name without module name prefix.
    ///
    ///     ModuleA.Foo().typeName -> "ModuleA.Foo"
    public static var fullTypeName: String {
        String(reflecting: self)
    }
}

/// Get module name from a swift file ID.
/// - Parameter fileId: No need to pass it, just use the default.
/// - Returns: Module name, return `""` if failed.
public func moduleName(fileId: String = #fileID) -> String {
    fileId.firstIndex(of: "/").flatMap { String(fileId[fileId.startIndex..<$0]) } ?? ""
}

extension NSObject: TypeNameDescribable {}
