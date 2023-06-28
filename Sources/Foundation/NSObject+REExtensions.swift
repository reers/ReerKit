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

#if canImport(Foundation)
import Foundation
#endif

extension NSObject: ReerCompatible {}


// MARK: - TypeName

extension NSObject: TypeNameDescribable {}


// MARK: - Association & Once & Swizzle & Observe Deinit

extension NSObject: AnyObjectExtensionable {}

public extension Reer where Base: NSObject {
    /// ReerKit: Get all instance variables implemented by the class.
    ///
    /// - Returns: An array of instance variables.
    static var ivars: [String] {
        var count: CUnsignedInt = 0
        var ivars: [String] = []
        guard let ivarList = class_copyIvarList(Base.self, &count) else { return ivars }
        for i in 0..<Int(count) {
            let ivar = ivarList[i]
            if let name = ivar_getName(ivar) {
                ivars.append(String(cString: name))
            }
        }
        free(ivarList)
        return ivars
    }
    
    /// ReerKit: Get all selectors implemented by the class.
    ///
    /// - Returns: An array of selectors.
    static var ocSelectors: [Selector]  {
        var count: CUnsignedInt = 0
        var selectors: [Selector] = []
        guard let methodList = class_copyMethodList(Base.self, &count) else { return selectors }
        for i in 0..<Int(count) {
            let method = methodList[i]
            let selector = method_getName(method)
            selectors.append(selector)
        }
        free(methodList)
        return selectors
    }
    
    /// ReerKit: Get all protocols implemented by the class.
    ///
    /// - Returns: An array of protocol names.
    static var ocProtocols: [String] {
        var count: CUnsignedInt = 0
        var protocols: [String] = []
        guard let protocolList = class_copyProtocolList(Base.self, &count) else { return protocols }
        for i in 0..<Int(count) {
            let `protocol` = protocolList[i]
            let name = protocol_getName(`protocol`)
            protocols.append(String(cString: name))
        }
        return protocols
    }

    /// ReerKit: Get all properties implemented by the class.
    ///
    /// - Returns: An array of property names.
    static var ocProperties: [String] {
        var count: CUnsignedInt = 0
        var properties: [String] = []
        guard let propertyList = class_copyPropertyList(Base.self, &count) else { return properties }
        for i in 0..<Int(count) {
            let property = propertyList[i]
            let name = property_getName(property)
            properties.append(String(cString: name))
        }
        free(propertyList)
        return properties
    }
    
    /// ReerKit: Add a selector that is implemented on another object to the current class.
    ///
    /// - Parameters:
    ///   - selector: Selector.
    ///   - originalClass: Object implementing the selector.
    static func addSelector(_ selector: Selector, from originalClass: AnyClass) {
        guard let method = class_getInstanceMethod(originalClass, selector),
              let typeEncoding = method_getTypeEncoding(method)
        else {
            return
        }
        let implementation = method_getImplementation(method),
        _ = class_addMethod(Base.self, selector, implementation, typeEncoding)
    }
    
    #if canImport(Foundation)
    /// ReerKit: Add a custom method to the current class.
    ///
    /// - Parameters:
    ///   - identifier: Selector name.
    ///   - implementation: Implementation as a closure.
    static func addMethod(_ identifier: String, implementation: @convention(block) @escaping () -> Void) {
        let blockObject = unsafeBitCast(implementation, to: AnyObject.self)
        let implementation = imp_implementationWithBlock(blockObject)
        let selector = NSSelectorFromString(identifier)
        let encoding = "v@:f"
        class_addMethod(Base.self, selector, implementation, encoding)
    }
    #endif
    
    /// ReerKit: A convenience method to perform selectors by identifier strings.
    ///
    /// - Parameter identifier: Selector name.
    func performMethod(_ identifier: String) {
        let selector = NSSelectorFromString(identifier)
        if base.responds(to: selector) {
            base.perform(selector)
        }
    }
}

#endif
