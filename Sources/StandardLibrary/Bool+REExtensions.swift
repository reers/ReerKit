//
//  Bool+REExtensions.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/13.
//  Copyright © 2022 reers. All rights reserved.
//

// MARK: - Properties
extension Bool: ReerKitCompatibleValue {}
public extension ReerKitWrapper where Base == Bool {
    
    /// ReerKit: Return 1 if true, or 0 if false.
    ///
    ///     false.int -> 0
    ///     true.int -> 1
    ///
    var int: Int {
        return base ? 1 : 0
    }
    
    /// ReerKit: Return "true" if true, or "false" if false.
    ///
    ///     false.string -> "false"
    ///     true.string -> "true"
    ///
    var string: String {
        return base.description
    }
}
