//
//  Invocation.swift
//  ReerKit
//
//  Created by phoenix on 2023/12/11.
//  Copyright © 2023 reers. All rights reserved.
//

#if canImport(Foundation) && canImport(ObjectiveC) 
import ObjectiveC
import Foundation

/// A wrapper for Objective-C `NSInvocation`
public class Invocation {
    
    /// Get instance method for a Objc class.
    /// - Parameters:
    ///   - selector: Method selector
    ///   - classOrInstance: Class instance.
    /// - Returns: A signature, actually a `NSMethodSignature` instance.
    public static func instanceMethodSignatureForSelector(_ selector: Selector, of instance: any NSObjectProtocol) -> Any? {
        guard instance.responds(to: selector) else {
            return nil
        }
        return methodSignatureForSelectorIMP(
            instance,
            NSSelectorFromString("methodSignatureForSelector:"),
            selector
        )
    }
    
    /// Get class method for a Objc class.
    /// - Parameters:
    ///   - selector: Method selector
    ///   - classOrInstance: Class type.
    /// - Returns: A signature, actually a `NSMethodSignature` instance.
    public static func classMethodSignatureForSelector(_ selector: Selector, of cls: AnyClass) -> Any? {
        guard cls.responds(to: selector) else {
            return nil
        }
        return methodSignatureForSelectorIMP(
            cls,
            NSSelectorFromString("methodSignatureForSelector:"),
            selector
        )
    }
    
    private let nsInvocation: NSObject
    
    /// Initializer
    /// - Parameter signature: Method signature returned from invoking ``methodSignatureForSelector(_:of:)``
    public init(signature: Any) {
        nsInvocation = Self.nsInvocationInitIMP(
            Self.nsInvocationClass,
            NSSelectorFromString("invocationWithMethodSignature:"),
            signature
        ) as! NSObject
    }
    
    /// Set selector will be invoking.
    public func setSelector(_ selector: Selector) {
        Self.nsInvocationSetSelectorIMP(
            nsInvocation,
            NSSelectorFromString("setSelector:"),
            selector
        )
    }
    
    /// Set argument for the method.
    /// - Parameters:
    ///   - arg: argument using a inout var as `NSObject`
    ///   - index: usually from 2, 0 is `self`, 1 is `_cmd`
    public func setArgument(_ arg: inout any NSObjectProtocol, atIndex index: Int) {
        withUnsafePointer(to: &arg) { pointer in
            Self.nsInvocationSetArgAtIndexIMP(
                nsInvocation,
                NSSelectorFromString("setArgument:atIndex:"),
                OpaquePointer(pointer),
                index
            )
        }
    }
    
    public func retainArguments() {
        Self.nsInvocationretainArgumentsIMP(nsInvocation, NSSelectorFromString("retainArguments"))
    }
    
    public func invoke(withTarget target: Any) {
        nsInvocation.perform(NSSelectorFromString("invokeWithTarget:"), with: target)
    }
    
    /// Get return value after invoking.
    /// - Parameter ret: return value using a inout var as `NSObject`
    public func getReturnValue(_ ret: inout Any) {
        let retPointer = UnsafeMutableRawPointer.allocate(
            byteCount: MemoryLayout<NSObject>.size,
            alignment: MemoryLayout<NSObject>.alignment
        )
        defer { retPointer.deallocate() }
        
        Self.nsInvocationGetReturnValueIMP(
            nsInvocation,
            NSSelectorFromString("getReturnValue:"),
            OpaquePointer(retPointer)
        )
        
        ret = retPointer.load(as: NSObject.self)
    }
    
    private static let nsInvocationClass: AnyClass = NSClassFromString("NSInvocation")!
    
    private static let nsInvocationInitIMP = unsafeBitCast(
        method_getImplementation(
            class_getClassMethod(
                nsInvocationClass,
                NSSelectorFromString("invocationWithMethodSignature:")
            )!
        ),
        to: (@convention(c) (AnyClass, Selector, Any) -> Any).self
    )
    
    private static let nsInvocationSetSelectorIMP = unsafeBitCast(
        class_getMethodImplementation(
            nsInvocationClass,
            NSSelectorFromString("setSelector:")
        ),
        to:(@convention(c) (Any, Selector, Selector) -> Void).self
    )
    
    private static let nsInvocationSetArgAtIndexIMP = unsafeBitCast(
        class_getMethodImplementation(
            nsInvocationClass,
            NSSelectorFromString("setArgument:atIndex:")
        ),
        to:(@convention(c)(Any, Selector, OpaquePointer, NSInteger) -> Void).self
    )
    
    private static let nsInvocationretainArgumentsIMP = unsafeBitCast(
        class_getMethodImplementation(
            nsInvocationClass,
            NSSelectorFromString("retainArguments")
        ),
        to:(@convention(c)(Any, Selector) -> Void).self
    )
    
    private static let nsInvocationGetReturnValueIMP = unsafeBitCast(
        class_getMethodImplementation(
            nsInvocationClass,
            NSSelectorFromString("getReturnValue:")
        ),
        to:(@convention(c)(Any, Selector, OpaquePointer) -> Void).self
    )
    
    private static let methodSignatureForSelectorIMP = unsafeBitCast(
        NSObject.method(for: NSSelectorFromString("methodSignatureForSelector:"))!,
        to: (@convention(c) (Any, Selector, Selector) -> Any).self
    )
}


#endif
