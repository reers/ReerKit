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

/// ReerKit: Runtime storage helpers used by the `@AssociatedValue` macro on
/// type (`static`/`class`) properties.
///
/// Type properties have no instance to attach to, so the association is hosted
/// on the metatype object (`SomeType.self`), which matches the
/// "one value per type" semantics of type properties.
public enum ReerAssociation {
    /// ReerKit: Returns the value associated with the given host object for a given key.
    ///
    /// - Parameters:
    ///   - host: The object holding the association, e.g. a metatype like `Self.self`.
    ///   - key: The key for the association.
    /// - Returns: The value associated with the key.
    public static func value<Value>(for host: AnyObject, key: AssociationKey) -> Value? {
        return (objc_getAssociatedObject(host, key.address) as? Value?) ?? nil
    }

    /// ReerKit: Returns the value associated with the given host object for a given key,
    /// or the provided default value when no compatible value exists.
    ///
    /// - Parameters:
    ///   - host: The object holding the association, e.g. a metatype like `Self.self`.
    ///   - key: The key for the association.
    ///   - defaultValue: Default value for the result.
    /// - Returns: The value associated with the key.
    public static func value<Value>(
        for host: AnyObject,
        key: AssociationKey,
        default defaultValue: @autoclosure () -> Value
    ) -> Value {
        return value(for: host, key: key) ?? defaultValue()
    }

    /// ReerKit: Sets an associated value for the given host object using a given key
    /// and association policy.
    ///
    /// - Parameters:
    ///   - value: The source value for the association.
    ///   - host: The object holding the association, e.g. a metatype like `Self.self`.
    ///   - key: The key for the association.
    ///   - policy: The policy for the association. For possible values, see `AssociationPolicy`.
    public static func set(
        _ value: Any?,
        for host: AnyObject,
        key: AssociationKey,
        policy: AssociationPolicy = .retain
    ) {
        objc_setAssociatedObject(host, key.address, value, policy.objcPolicy)
    }
}
#endif
