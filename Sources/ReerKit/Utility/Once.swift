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

#if os(Linux)
fileprivate let lock = MutexLock()
#else
fileprivate let lock = UnfairLock()
#endif

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
