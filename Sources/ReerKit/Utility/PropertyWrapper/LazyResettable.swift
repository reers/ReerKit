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


/// A property wrapper that provides lazy initialization with reset capability
///
/// This wrapper creates instances on first access and allows resetting to trigger
/// re-initialization on subsequent access. Useful for expensive objects that may
/// need to be recreated during the lifetime of the containing object.
///
/// **Key Advantage over Swift's `lazy` keyword:**
///
/// Swift's native `lazy` has limitations with optional types:
/// ```swift
/// // ❌ Swift's lazy - once set to nil, stays nil forever
/// lazy var test: String? = { "hello" }()
/// print(test)     // Optional("hello") - factory called
/// test = nil      // Set to nil
/// print(test)     // nil - factory NOT called again
/// ```
///
/// This wrapper solves that problem:
/// ```swift
/// // ✅ LazyResettable - can re-initialize after reset
/// @LazyResettable({ "hello" })
/// var test: String?
/// print(test)     // Optional("hello") - factory called
/// test = nil      // Triggers reset behavior
/// print(test)     // Optional("hello") - factory called AGAIN!
/// ```
///
/// **For non-optional types:** Use `$property.reset()` to trigger re-initialization on next access.
///
/// Example usage:
/// ```swift
/// class MyViewController: UIViewController {
///     // Optional type - setting to nil triggers re-initialization
///     @LazyResettable(UISelectionFeedbackGenerator())
///     private var feedbackGenerator: UISelectionFeedbackGenerator?
///
///     // Non-optional type - use reset() method for re-initialization
///     @LazyResettable(DateFormatter())
///     private var formatter: DateFormatter
///
///     func handleTap() {
///         feedbackGenerator?.selectionChanged()  // Auto-creates if needed
///         let date = formatter.string(from: Date())  // Auto-creates if needed
///     }
///
///     func resetComponents() {
///         feedbackGenerator = nil       // Reset optional - next access re-creates
///         // or
///         $feedbackGenerator.reset()
///
///         $formatter.reset()            // Reset non-optional - next access re-creates
///     }
/// }
/// ```
@propertyWrapper
public struct LazyResettable<T> {
    /// Represents the initialization state of the wrapped value
    private enum State {
        case uninitialized
        case initialized(T)
    }
    
    /// Current state of the wrapped value
    private var state: State = .uninitialized
    
    /// Factory closure that creates new instances
    private let factory: () -> T
    
    /// Initialize with a closure factory
    /// - Parameter factory: A closure that creates new instances of T
    public init(_ factory: @escaping () -> T) {
        self.factory = factory
    }
    
    /// Initialize with an autoclosure factory (for simple expressions)
    /// - Parameter factory: An autoclosure that creates new instances of T
    public init(_ factory: @escaping @autoclosure () -> T) {
        self.factory = factory
    }
    
    /// The wrapped value - lazily initialized on first access
    /// Getting: Creates instance if uninitialized, returns existing instance otherwise
    /// Setting: Directly sets the value, bypassing factory
    public var wrappedValue: T {
        mutating get {
            switch state {
            case .uninitialized:
                let value = factory()
                state = .initialized(value)
                return value
            case .initialized(let value):
                return value
            }
        }
        set {
            if newValue is ExpressibleByNilLiteral {
                let mirror = Mirror(reflecting: newValue)
                if mirror.displayStyle == .optional, mirror.children.first == nil {
                    state = .uninitialized
                } else {
                    state = .initialized(newValue)
                }
            } else {
                state = .initialized(newValue)
            }
        }
    }
    
    /// Projected value provides access to the wrapper itself for operations
    public var projectedValue: LazyResettable<T> {
        get { self }
        set { self = newValue }
    }
    
    /// Resets the value to uninitialized state, causing re-initialization on next access
    public mutating func reset() {
        state = .uninitialized
    }
    
    /// Check if the value has been initialized
    public var isInitialized: Bool {
        switch state {
        case .uninitialized:
            return false
        case .initialized:
            return true
        }
    }
}
