//
//  Synchronizing.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/16.
//  Copyright © 2022 reers. All rights reserved.
//

#if canImport(ObjectiveC)
import ObjectiveC

/// ReerKit: Use just like objective-c `@synchronized`.
///
///     let obj = NSObject()
///     synchronized(obj) {
///         // do something
///     }
/// - Parameters:
///   - token: A reference type object.
///   - execute: An action need to be executed synchronizely.
public func synchronized<Result>(_ token: AnyObject, execute: () throws -> Result) rethrows -> Result {
    objc_sync_enter(token)
    defer { objc_sync_exit(token) }
    return try execute()
}
#endif
