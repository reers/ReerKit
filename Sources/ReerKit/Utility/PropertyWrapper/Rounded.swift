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

/// A property wrapper that automatically rounds floating-point values using a specified rounding rule
///
/// This wrapper ensures that any floating-point value assigned to the wrapped property
/// is automatically rounded according to the specified `FloatingPointRoundingRule`.
/// Useful for maintaining consistent precision in calculations, UI measurements,
/// and financial computations.
///
/// **Type Requirements:**
/// - The wrapped value type must conform to `FloatingPoint`
/// - Works with `Float`, `Double`, `CGFloat`, and other floating-point types
///
/// **Rounding Rules:**
/// - `.toNearestOrAwayFromZero` (default): Standard rounding (0.5 rounds away from zero)
/// - `.toNearestOrEven`: Banker's rounding (0.5 rounds to nearest even number)
/// - `.up`: Always rounds toward positive infinity (ceiling)
/// - `.down`: Always rounds toward negative infinity (floor)
/// - `.towardZero`: Always rounds toward zero (truncation)
/// - `.awayFromZero`: Always rounds away from zero
///
/// **Use Cases:**
/// - Financial calculations requiring specific precision
/// - UI layout values that need pixel-perfect alignment
/// - Scientific computations with controlled precision
/// - Game coordinates and physics calculations
///
/// Example usage:
/// ```swift
/// struct PriceCalculator {
///     @Rounded(rule: .toNearestOrEven)  // Banker's rounding for financial accuracy
///     var price: Double = 0.0
///
///     @Rounded(rule: .up)  // Always round up for safety margins
///     var margin: Float = 0.0
///
///     func calculateTotal() {
///         price = 19.855      // Rounded to 19.86 (banker's rounding)
///         margin = 0.001      // Rounded to 1.0 (ceiling)
///     }
/// }
///
/// struct UILayout {
///     @Rounded()  // Default: .toNearestOrAwayFromZero
///     var width: CGFloat = 0.0
///
///     @Rounded(rule: .down)  // Floor for consistent baseline alignment
///     var height: CGFloat = 0.0
///
///     func updateDimensions() {
///         width = 100.7       // Rounded to 101.0
///         height = 50.9       // Rounded to 50.0 (floor)
///     }
/// }
///
/// struct GameCoordinate {
///     @Rounded(rule: .towardZero)  // Truncate for grid alignment
///     var x: Double = 0.0
///
///     @Rounded(rule: .awayFromZero)  // Expand for collision detection
///     var y: Double = 0.0
///
///     func movePlayer() {
///         x = 5.8     // Rounded to 5.0 (toward zero)
///         y = -3.2    // Rounded to -4.0 (away from zero)
///     }
/// }
/// ```
@propertyWrapper
public struct Rounded<Value: FloatingPoint> {
    
    private var value: Value
    public let rule: FloatingPointRoundingRule
    
    public init(
        wrappedValue: Value,
        rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero
    ) {
        self.value = wrappedValue.rounded(rule)
        self.rule = rule
    }
    
    public var wrappedValue: Value {
        get { return value }
        set { value = newValue.rounded(rule) }
    }
}
