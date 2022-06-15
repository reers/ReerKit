//
//  Synchronizing.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/16.
//  Copyright © 2022 reers. All rights reserved.
//

#if canImport(Foundation)
import Foundation

public func synchronized<Result>(_ token: AnyObject, execute: () throws -> Result) rethrows -> Result {
    objc_sync_enter(token)
    defer { objc_sync_exit(token) }
    return try execute()
}
#endif
