//
//  Copyright © 2020 SwifterSwift
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

public extension ReerForEquatable where Base: Comparable {
    /// ReetKit: Returns true if value is in the provided range.
    ///
    ///     1.re.isBetween(5...7) // false
    ///     7.re.isBetween(6...12) // true
    ///     date.re.isBetween(date1...date2)
    ///     "c".re.isBetween(a...d) // true
    ///     0.32.re.isBetween(0.31...0.33) // true
    ///
    /// - Parameter range: Closed range against which the value is checked to be included.
    /// - Returns: `true` if the value is included in the range, `false` otherwise.
    func isBetween(_ range: ClosedRange<Base>) -> Bool {
        return range ~= base
    }

    /// ReetKit: Returns value limited within the provided range.
    ///
    ///     1.re.clamped(to: 3...8) // 3
    ///     4.re.clamped(to: 3...7) // 4
    ///     "c".re.clamped(to: "e"..."g") // "e"
    ///     0.32.re.clamped(to: 0.1...0.29) // 0.29
    ///
    /// - Parameter range: Closed range that limits the value.
    /// - Returns: A value limited to the range, i.e. between `range.lowerBound` and `range.upperBound`.
    func clamped(to range: ClosedRange<Base>) -> Base {
        return max(range.lowerBound, min(base, range.upperBound))
    }
}
