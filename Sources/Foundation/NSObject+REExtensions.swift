//
//  NSObject+REExtensions.swift
//  ReerKit-iOS
//
//  Created by phoenix on 2022/6/12.
//

import Foundation

extension NSObject: TypeNameDescribable {}
extension NSObject: ReerKitCompatible {}

#if canImport(ObjectiveC)
import ObjectiveC

// MARK: - Association

/// ReerKit: Policies related to associative references.
public enum AssociationPolicy {
    /// Specifies a weak reference to the associated object.
    case assign
    /// Specifies a strong reference to the associated object.
    /// The association is not made atomically.
    case retain
    /// Specifies that the associated object is copied.
    /// The association is not made atomically.
    case copy
    /// Specifies a strong reference to the associated object.
    /// The association is made atomically.
    case retainAtomic
    /// Specifies that the associated object is copied.
    /// The association is made atomically.
    case copyAtomic
}

fileprivate extension AssociationPolicy {
    var objcPolicy: objc_AssociationPolicy {
        switch self {
        case .assign: return .OBJC_ASSOCIATION_ASSIGN
        case .retain: return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        case .copy: return .OBJC_ASSOCIATION_COPY_NONATOMIC
        case .retainAtomic: return .OBJC_ASSOCIATION_RETAIN
        case .copyAtomic: return .OBJC_ASSOCIATION_COPY
        }
    }
}

public struct AssociationKey {
    fileprivate let address: UnsafeRawPointer
    
    /// ReerKit: Create an ObjC association key.
    ///
    /// - warning: The key must be uniqued.
    public init() {
        self.address = UnsafeRawPointer(UnsafeMutablePointer<UInt8>.allocate(capacity: 1))
    }
    
    /// ReerKit: Create an ObjC association key from a `StaticString`.
    ///
    ///     let key1 = AssociationKey("SomeString" as StaticString)
    ///     let key2 = AssociationKey(#function as StaticString)
    ///
    /// - precondition: `key` has a pointer representation.
    public init(_ key: StaticString) {
        assert(key.hasPointerRepresentation)
        self.address = UnsafeRawPointer(key.utf8Start)
    }
    
    /// ReerKit: Create an ObjC association key from a `Selector`.
    ///
    ///     @objc var foo: String {
    ///         get {
    ///             re.associatedValue(forKey: AssociationKey(#selector(getter: self.foo)), default: "23")
    ///         }
    ///     }
    ///
    /// - Parameter key: An @objc function or computed property selector.
    public init(_ key: Selector) {
        self.address = UnsafeRawPointer(unsafeBitCast(key, to: UnsafePointer<Int8>.self))
    }
}

public extension ReerKitWrapper where Base: NSObject {
    
    /// ReerKit: Sets an associated value for self using a given key and association policy.
    ///
    ///     let obj = NSObject()
    ///     let key = AssociationKey("bar" as StaticString)
    ///     obj.re.setAssociatedValue(123, forKey: key)
    ///
    /// - Parameters:
    ///   - value: The source value for the association.
    ///   - key: The key for the association.
    ///   - policy: The policy for the association. For possible values, see `AssociationPolicy`
    func setAssociatedValue<Value>(
        _ value: Value,
        forKey key: AssociationKey,
        withPolicy policy: AssociationPolicy = .retain
    ) {
        objc_setAssociatedObject(base, key.address, value, policy.objcPolicy)
    }
    
    /// ReerKit: Returns the value associated on self for a given key.
    ///
    ///     let value: Int? = obj.re.associatedValue(forKey: key)
    ///
    /// - Parameter key: The key for the association.
    /// - Returns: The value associated with the key.
    func associatedValue<Value>(forKey key: AssociationKey) -> Value? {
        return objc_getAssociatedObject(base, key.address) as! Value?
    }
    
    /// ReerKit: Returns the value associated on self for a given key.
    ///
    ///     let value = obj.re.associatedValue(forKey: key, default: 123)
    ///
    /// - Parameters:
    ///   - key: The key for the association.
    ///   - default: Default value for the result.
    /// - Returns: The value associated with the key.
    func associatedValue<Value>(forKey key: AssociationKey, `default`: Value) -> Value {
        return (objc_getAssociatedObject(base, key.address) as! Value?) ?? `default`
    }
    
    /// ReerKit: Sets an associated weak object for self using a given key.
    ///
    ///     let obj = NSObject()
    ///     let key = AssociationKey("bar" as StaticString)
    ///     obj.re.setAssociatedWeakObject(NSObject(), forKey: key)
    ///     let value: Int? = obj.re.associatedValue(forKey: key)
    ///
    /// - Parameters:
    ///   - object: The source object for the association.
    ///   - key: The key for the association.
    func setAssociatedWeakObject<Object: AnyObject>(_ object: Object, forKey key: AssociationKey) {
        let closure = { [weak object] in
            return object;
        }
        objc_setAssociatedObject(base, key.address, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    /// ReerKit: Returns the weak object associated on self for a given key.
    ///
    ///     let obj = obj.re.associatedWeakObject(forKey: key) as NSObject?
    ///
    /// - Parameters:
    ///   - key: The key for the association.
    /// - Returns: The object associated with the key.
    func associatedWeakObject<Object: AnyObject>(forKey key: AssociationKey) -> Object? {
        let closure: (() -> Object?)? = objc_getAssociatedObject(base, key.address) as! (() -> Object?)?
        guard let closure = closure else { return nil }
        return closure()
    }
}
#endif
