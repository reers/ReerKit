//
//  ReerKit.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/12.
//

import Foundation

/// Wrapper for ReerKit compatible types. This type provides an extension point for
/// connivence methods in ReerKit.
public struct ReerKitWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// Represents an object type that is compatible with ReerKit. You can use `re` property to get a
/// value in the namespace of ReerKit.
public protocol ReerKitCompatible: AnyObject {}

/// Represents a value type that is compatible with ReerKit. You can use `re` property to get a
/// value in the namespace of ReerKit.
public protocol ReerKitCompatibleValue {}

extension ReerKitCompatible {
    /// Gets a namespace holder for ReerKit compatible types.
    public var re: ReerKitWrapper<Self> {
        get { return ReerKitWrapper(self) }
        set {}
    }
    
    /// Gets a namespace holder for ReerKit compatible meta types.
    public static var re: ReerKitWrapper<Self>.Type {
        get { return ReerKitWrapper.self }
        set {}
    }
}

extension ReerKitCompatibleValue {
    /// Gets a namespace holder for ReerKit compatible types.
    public var re: ReerKitWrapper<Self> {
        get { return ReerKitWrapper(self) }
        set {}
    }
    
    /// Gets a namespace holder for ReerKit compatible meta types.
    public static var re: ReerKitWrapper<Self>.Type {
        get { return ReerKitWrapper.self }
        set {}
    }
}
