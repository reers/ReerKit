//
//  TypeNameDescribable.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/12.
//

import Foundation

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
