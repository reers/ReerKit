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

// MARK: - Codable Support

public extension Reer where Base: UserDefaults {
    
    /// ReerKit: Store a Codable object to UserDefaults.
    ///
    /// - Parameters:
    ///   - object: The Codable object to store.
    ///   - key: The key to associate with the object.
    ///   - encoder: The JSONEncoder to use. Defaults to a new JSONEncoder instance.
    /// - Throws: An error if encoding fails.
    ///
    /// Example:
    /// ```swift
    /// struct User: Codable {
    ///     let name: String
    ///     let age: Int
    /// }
    /// let user = User(name: "John", age: 30)
    /// try UserDefaults.standard.re.set(object: user, forKey: "currentUser")
    /// ```
    func set<T: Encodable>(object: T, forKey key: String, encoder: JSONEncoder = JSONEncoder()) throws {
        let data = try encoder.encode(object)
        base.set(data, forKey: key)
    }
    
    /// ReerKit: Retrieve a Codable object from UserDefaults.
    ///
    /// - Parameters:
    ///   - type: The type of the object to decode.
    ///   - key: The key associated with the object.
    ///   - decoder: The JSONDecoder to use. Defaults to a new JSONDecoder instance.
    /// - Returns: The decoded object, or nil if the key doesn't exist or decoding fails.
    ///
    /// Example:
    /// ```swift
    /// struct User: Codable {
    ///     let name: String
    ///     let age: Int
    /// }
    /// let user = UserDefaults.standard.re.object(User.self, forKey: "currentUser")
    /// ```
    func object<T: Decodable>(_ type: T.Type, forKey key: String, decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = base.data(forKey: key) else { return nil }
        return try? decoder.decode(type, from: data)
    }
    
}

// MARK: - Codable Array Support

public extension Reer where Base: UserDefaults {
    
    /// ReerKit: Store an array of Codable objects to UserDefaults.
    ///
    /// - Parameters:
    ///   - array: The array of Codable objects to store.
    ///   - key: The key to associate with the array.
    ///   - encoder: The JSONEncoder to use. Defaults to a new JSONEncoder instance.
    /// - Throws: An error if encoding fails.
    ///
    /// Example:
    /// ```swift
    /// struct User: Codable {
    ///     let name: String
    ///     let age: Int
    /// }
    /// let users = [User(name: "John", age: 30), User(name: "Jane", age: 25)]
    /// try UserDefaults.standard.re.set(array: users, forKey: "users")
    /// ```
    func set<T: Encodable>(array: [T], forKey key: String, encoder: JSONEncoder = JSONEncoder()) throws {
        let data = try encoder.encode(array)
        base.set(data, forKey: key)
    }
    
    /// ReerKit: Retrieve an array of Codable objects from UserDefaults.
    ///
    /// - Parameters:
    ///   - type: The type of the objects in the array.
    ///   - key: The key associated with the array.
    ///   - decoder: The JSONDecoder to use. Defaults to a new JSONDecoder instance.
    /// - Returns: The decoded array, or nil if the key doesn't exist or decoding fails.
    ///
    /// Example:
    /// ```swift
    /// struct User: Codable {
    ///     let name: String
    ///     let age: Int
    /// }
    /// let users = UserDefaults.standard.re.array(of: User.self, forKey: "users")
    /// ```
    func array<T: Decodable>(of type: T.Type, forKey key: String, decoder: JSONDecoder = JSONDecoder()) -> [T]? {
        guard let data = base.data(forKey: key) else { return nil }
        return try? decoder.decode([T].self, from: data)
    }
    
}

// MARK: - Key Check

public extension Reer where Base: UserDefaults {
    
    /// ReerKit: Check if a key exists in UserDefaults.
    ///
    /// - Parameter key: The key to check.
    /// - Returns: `true` if the key exists, `false` otherwise.
    ///
    /// Example:
    /// ```swift
    /// if UserDefaults.standard.re.hasKey("username") {
    ///     // Key exists
    /// }
    /// ```
    func hasKey(_ key: String) -> Bool {
        return base.object(forKey: key) != nil
    }
}

// MARK: - Date Support with Custom Format

public extension Reer where Base: UserDefaults {
    
    /// ReerKit: Store a Date with a specific DateFormatter.
    ///
    /// - Parameters:
    ///   - date: The Date to store.
    ///   - key: The key to associate with the date.
    ///   - formatter: Optional DateFormatter. If nil, stores as TimeInterval.
    ///
    /// Example:
    /// ```swift
    /// UserDefaults.standard.re.set(date: Date(), forKey: "lastLogin")
    /// ```
    func set(date: Date?, forKey key: String, formatter: DateFormatter? = nil) {
        if let date = date {
            if let formatter = formatter {
                base.set(formatter.string(from: date), forKey: key)
            } else {
                base.set(date.timeIntervalSince1970, forKey: key)
            }
        } else {
            base.removeObject(forKey: key)
        }
    }
    
    /// ReerKit: Retrieve a Date from UserDefaults.
    ///
    /// - Parameters:
    ///   - key: The key associated with the date.
    ///   - formatter: Optional DateFormatter. If nil, interprets value as TimeInterval.
    /// - Returns: The Date, or nil if the key doesn't exist or parsing fails.
    ///
    /// Example:
    /// ```swift
    /// let lastLogin = UserDefaults.standard.re.date(forKey: "lastLogin")
    /// ```
    func date(forKey key: String, formatter: DateFormatter? = nil) -> Date? {
        if let formatter = formatter {
            guard let dateString = base.string(forKey: key) else { return nil }
            return formatter.date(from: dateString)
        } else {
            guard base.object(forKey: key) != nil else { return nil }
            let timeInterval = base.double(forKey: key)
            return Date(timeIntervalSince1970: timeInterval)
        }
    }
}

#endif
