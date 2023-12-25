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

#if canImport(ObjectiveC)
import ObjectiveC

/// The ability to execute a closure once.
/// You must conform this protocol by yourself if your class is NOT inheriting from `NSObject`.
public protocol OnceExecutable: ReerCompatible {}

public typealias OnceKey = AssociationKey

public extension Reer where Base: AnyObject {
    
    /// ReerKit: Execute the passed closure once by a key during the object life time.
    ///
    ///     let obj = NSObject()
    ///     func test() {
    ///         obj.re.executeOnce(byKey: key) { print("once") }
    ///     }
    ///     test()
    ///     test()
    ///     obj.re.executeOnce(byKey: key) { print("once") }
    ///     // output: once
    func executeOnce<Result>(byKey key: OnceKey, _ execute: @escaping () throws -> Result) rethrows -> Result {
        if let lastExecutedResult = objc_getAssociatedObject(base, key.address) as! Result? {
            return lastExecutedResult
        } else {
            let result = try execute()
            defer { objc_setAssociatedObject(base, key.address, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
            return result
        }
    }
    
    /// ReerKit: Execute the passed closure once by a auto generated key during the object life time.
    ///
    ///     let obj = NSObject()
    ///     func test() {
    ///         obj.re.executeOnce { print("once") }
    ///     }
    ///     test()
    ///     test()
    ///     // output: once
    func executeOnce<Result>(
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line,
        _ execute: @escaping () throws -> Result
    ) rethrows -> Result {
        var keyDict: [String: OnceKey]
        if let dict = objc_getAssociatedObject(base, &keyOfOnceKeyDict) as? [String: OnceKey] {
            keyDict = dict
        } else {
            keyDict = .init()
        }
        let key = "\(fileID)_\(function)_\(line)"
        let onceKey: OnceKey = keyDict[key] ?? .init()
        keyDict[key] = onceKey
        objc_setAssociatedObject(base, &keyOfOnceKeyDict, keyDict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        if let lastExecutedResult = objc_getAssociatedObject(base, onceKey.address) as! Result? {
            return lastExecutedResult
        } else {
            let result = try execute()
            defer { objc_setAssociatedObject(base, onceKey.address, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
            return result
        }
    }
}

fileprivate var keyOfOnceKeyDict: UInt8 = 0

#endif
