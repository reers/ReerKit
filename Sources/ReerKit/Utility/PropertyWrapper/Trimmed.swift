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

/// A property wrapper that automatically trims whitespace and newlines from string values
///
/// This wrapper ensures that any string assigned to the wrapped property
/// has leading and trailing whitespace characters and newlines automatically removed.
/// The trimming is performed using `CharacterSet.whitespacesAndNewlines`, which includes
/// spaces, tabs, newlines, and other Unicode whitespace characters.
///
/// **Trimmed Characters:**
/// - Spaces (` `)
/// - Tabs (`\t`)
/// - Newlines (`\n`, `\r`, `\r\n`)
/// - Other Unicode whitespace characters
///
/// **Use Cases:**
/// - User input validation and sanitization
/// - Configuration values from files or network
/// - Form field processing
/// - Data parsing and cleaning
/// - API request/response processing
///
/// Example usage:
/// ```swift
/// struct UserProfile {
///     @Trimmed
///     var username: String = ""
///
///     @Trimmed
///     var email: String = ""
///
///     @Trimmed
///     var displayName: String = ""
///
///     func updateProfile() {
///         username = "  john_doe  "        // Stored as "john_doe"
///         email = "\t user@example.com \n" // Stored as "user@example.com"
///         displayName = "   John Doe   "   // Stored as "John Doe"
///     }
/// }
/// ```
@propertyWrapper
public struct Trimmed {
    private var value: String
    
    public init(wrappedValue: String) {
        self.value = wrappedValue
    }

    public var wrappedValue: String {
        get { return value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
