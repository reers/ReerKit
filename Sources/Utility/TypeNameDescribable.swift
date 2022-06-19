//
//  TypeNameDescribable.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/12.
//

import Foundation

/// Return the type name of an instance or a type.
///
///     UIView().typeName // "UIView"
///     UIView.typeName   // "UIView"
public protocol TypeNameDescribable {
    var typeName: String { get }
    static var typeName: String { get }
}

extension TypeNameDescribable {
    public var typeName: String {
        String(describing: type(of: self))
    }

    public static var typeName: String {
        String(describing: self)
    }
}

extension NSObject: TypeNameDescribable {}
