//
//  Once.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/22.
//  Copyright © 2022 reers. All rights reserved.
//

/// ReerKit: An once token type that wrapped an internal string.
public struct OnceToken: Hashable {
    private let value: String
    
    /// Create a token with an internal pointer.
    public init() {
        let address = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
        self.value = String(describing: address)
    }

    // Create a token with an external string.
    public init(_ value: String) {
        self.value = value
    }
}

fileprivate var tokens = Set<OnceToken>()
fileprivate let lock = UnfairLock()

/// ReerKit: Invoke the passed closure only once during the life time of the process.
/// It will create an once token by combining #fileID, #function, #line.
///
///     once {
///         print("do something")
///     }
///
/// - Parameters:
///   - fileID: No need to pass it, just use the default.
///   - function: No need to pass it, just use the default.
///   - line: No need to pass it, just use the default.
///   - execute: The closure need to be executed.
public func once(
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line,
    execute: () -> Void
) {
    let token = OnceToken("\(fileID)_\(function)_\(line)")
    once(token, execute: execute)
}

/// ReerKit: Invoke the passed closure only once during the life time of the process.
/// It need an once token parameter, seealso `OnceToken`.
///
///     let token = OnceToken()
///     once(token) {
///         print("do something")
///     }
///
/// - Parameters:
///   - token: An unique once token.
///   - execute: The closure need to be executed.
public func once(_ token: OnceToken, execute: () -> Void) {
    lock.lock()
    if tokens.contains(token) {
        lock.unlock()
        return
    }
    tokens.insert(token)
    lock.unlock()

    execute()
}

/// ReerKit: Cancel the once token mark, that means you can execute the action again with the same token.
/// - Parameter token: The token that need to cancel marking.
public func deonce(_ token: OnceToken) {
    lock.lock()
    tokens.remove(token)
    lock.unlock()
}
