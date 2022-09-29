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

public extension Reer where Base: BidirectionalCollection {
    /// ReerKit: Returns the element at the specified position. If offset is negative, the `n`th element from the end will be returned where `n` is the result of `abs(distance)`.
    ///
    ///        let arr = [1, 2, 3, 4, 5]
    ///        arr.re[offset: 1] -> 2
    ///        arr.re[offset: -2] -> 4
    ///
    /// - Parameter distance: The distance to offset.
    subscript(offset distance: Int) -> Base.Element {
        let index = distance >= 0 ? base.startIndex : base.endIndex
        return base[base.indices.index(index, offsetBy: distance)]
    }
}
