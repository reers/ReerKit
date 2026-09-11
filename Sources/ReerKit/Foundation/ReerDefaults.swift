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

#if canImport(Foundation)
import Foundation

/// ReerKit: Runtime storage helpers used by the `@Defaults` macro.
public enum ReerDefaults {
    /// ReerKit: Returns a stored value, or the provided default value when no compatible value exists.
    public static func value<Value>(
        forKey key: String,
        default defaultValue: @autoclosure () -> Value,
        container: UserDefaults = .standard
    ) -> Value {
        return value(forKey: key, container: container) ?? defaultValue()
    }

    /// ReerKit: Returns a stored optional value.
    public static func value<Value>(
        forKey key: String,
        container: UserDefaults = .standard
    ) -> Value? {
        if Value.self == URL.self {
            return container.url(forKey: key) as? Value
        }

        guard let object = container.object(forKey: key) else {
            return nil
        }

        if let value = object as? Value {
            return value
        }

        if Value.self == UUID.self,
           let string = object as? String {
            return UUID(uuidString: string) as? Value
        }

        if Value.self == Decimal.self {
            if let decimal = object as? Decimal {
                return decimal as? Value
            }
            if let number = object as? NSNumber {
                return number.decimalValue as? Value
            }
            if let string = object as? String,
               let decimal = Decimal(string: string) {
                return decimal as? Value
            }
        }

        return nil
    }

    /// ReerKit: Stores a value.
    public static func set<Value>(
        _ value: Value,
        forKey key: String,
        container: UserDefaults = .standard
    ) {
        switch value {
        case let url as URL:
            container.set(url, forKey: key)
        case let uuid as UUID:
            container.set(uuid.uuidString, forKey: key)
        case let decimal as Decimal:
            container.set(NSDecimalNumber(decimal: decimal).stringValue, forKey: key)
        default:
            container.set(value, forKey: key)
        }
    }

    /// ReerKit: Stores an optional value, removing the key when the value is `nil`.
    public static func set<Value>(
        _ value: Value?,
        forKey key: String,
        container: UserDefaults = .standard
    ) {
        guard let value else {
            container.removeObject(forKey: key)
            return
        }
        set(value, forKey: key, container: container)
    }
}

#endif
