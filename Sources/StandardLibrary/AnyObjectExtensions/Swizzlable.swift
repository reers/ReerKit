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

/// The ability to swizzle method conveniently.
/// You must conform this protocol by yourself if your class is NOT inheriting from `NSObject`.
public protocol Swizzlable: ReerCompatible {}

public extension Reer where Base: AnyObject {
    
    
    /// ReerKit: Swizzle instance method of the class.
    /// Also you can use ability from Apple, see `@_dynamicReplacement(for: )`
    ///
    /// - Parameters:
    ///   - originalSelector: The selector must be a `@objc dynamic` method.
    ///   - swizzledSelector: The selector must be a `@objc` method.
    /// - Returns: Successful or not.
    @discardableResult
    static func swizzleInstanceMethod(_ originalSelector: Selector, with swizzledSelector: Selector) -> Bool {
        guard let originalMethod = class_getInstanceMethod(Base.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(Base.self, swizzledSelector)
        else { return false }
        let addMethodSuccess = class_addMethod(
            Base.self,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        if addMethodSuccess {
            class_replaceMethod(
                Base.self,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        return true
    }
    
    /// ReerKit: Swizzle class method of the class.
    /// Also you can use ability from Apple, see `@_dynamicReplacement(for: )`
    ///
    /// - Parameters:
    ///   - originalSelector: The selector must be a `@objc dynamic` method.
    ///   - swizzledSelector: The selector must be a `@objc` method.
    /// - Returns: Successful or not.
    @discardableResult
    static func swizzleClassMethod(_ originalSelector: Selector, with swizzledSelector: Selector) -> Bool {
        guard let originalMethod = class_getClassMethod(Base.self, originalSelector),
              let swizzledMethod = class_getClassMethod(Base.self, swizzledSelector)
        else { return false }
        let metaCls = objc_getMetaClass(class_getName(Base.self))
        let addMethodSuccess = class_addMethod(
            metaCls as? AnyClass,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        if addMethodSuccess {
            class_replaceMethod(
                metaCls as? AnyClass,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        return true
    }
}
#endif
