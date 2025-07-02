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

/// A property wrapper that automatically clamps values to a specified range
///
/// This wrapper ensures that any value assigned to the wrapped property
/// is automatically constrained to fall within the specified closed range.
/// Values below the minimum are set to the minimum, and values above the
/// maximum are set to the maximum.
///
/// **Type Requirements:**
/// - The wrapped value type must conform to `Comparable`
/// - Works with any comparable type: `Int`, `Float`, `Double`, `CGFloat`, etc.
///
/// **Use Cases:**
/// - UI component values (alpha, progress, volume)
/// - Game parameters (health, score, level)
/// - Configuration values with valid ranges
/// - Input validation and sanitization
///
/// Example usage:
/// ```swift
/// struct AudioPlayer {
///     @Clamped(0.0...1.0)
///     var volume: Double = 0.5
///
///     @Clamped(0...100)
///     var batteryLevel: Int = 50
///
///     @Clamped(-180...180)
///     var rotationAngle: Float = 0.0
///
///     func adjustVolume() {
///         volume = 1.5    // Automatically clamped to 1.0
///         volume = -0.2   // Automatically clamped to 0.0
///         print(volume)   // Prints: 0.0
///     }
/// }
///
/// struct UIComponent {
///     @Clamped(0.0...1.0)
///     var alpha: CGFloat = 1.0
///
///     @Clamped(0...359)
///     var hue: Int = 0
///
///     func updateAppearance() {
///         alpha = 2.0     // Clamped to 1.0
///         hue = 400       // Clamped to 359
///     }
/// }
/// ```
@propertyWrapper
public struct Clamped<Value: Comparable> {
    private var value: Value
    private let range: ClosedRange<Value>
    
    public init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.value = wrappedValue
        self.range = range
    }

    public var wrappedValue: Value {
        get { return value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}
