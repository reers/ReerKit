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

#if canImport(Dispatch)
import Dispatch
#endif

// MARK: - Properties
public extension Reer where Base: Collection {
    /// ReerKit: A Boolean value indicating whether the collection is not empty.
    var isNotEmpty: Bool { !base.isEmpty }
    
    /// ReerKit: The full range of the collection.
    var fullRange: Range<Base.Index> { base.startIndex..<base.endIndex }
}

// MARK: - Methods

public extension Reer where Base: Collection {

    #if canImport(Dispatch)
    /// ReerKit: Performs `each` closure for each element of collection in parallel.
    ///
    ///        array.re.forEachInParallel { item in
    ///            print(item)
    ///        }
    ///
    /// - Parameter each: closure to run for each element.
    func forEachInParallel(_ each: (Base.Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: base.count) {
            each(base[base.index(base.startIndex, offsetBy: $0)])
        }
    }
    #endif

    /// ReerKit: Safe protects the array from out of bounds by use of optional.
    ///
    ///        let arr = [1, 2, 3, 4, 5]
    ///        arr.re[1] -> 2
    ///        arr.re[10] -> nil
    ///
    /// - Parameter index: index of element to access element.
    subscript(index: Base.Index) -> Base.Element? {
        return (index >= base.startIndex && index < base.endIndex) ? base[index] : nil
    }
    
    /// ReerKit: Safe protects the array from out of bounds by use of optional.
    ///
    ///        let arr = [1, 2, 3, 4, 5]
    ///        arr.re[1] -> 2
    ///        arr.re[10] -> nil
    ///        arr.re[10, default: -999] -> -999
    ///
    /// - Parameters:
    ///   - index: index of element to access element.
    ///   - defaultValue: The default value to use if `index` doesn't exist in the `indices`
    subscript(index: Base.Index, default defaultValue: @autoclosure () -> Base.Element) -> Base.Element {
        guard index >= base.startIndex, index < base.endIndex else {
            return defaultValue()
        }
        return base[index]
    }

    /// ReerKit: Returns an array of slices of length "size" from the array. If array can't be split evenly, the final slice will be the remaining elements.
    ///
    ///     [0, 2, 4, 7].re.group(by: 2) -> [[0, 2], [4, 7]]
    ///     [0, 2, 4, 7, 6].re.group(by: 2) -> [[0, 2], [4, 7], [6]]
    ///
    /// - Parameter size: The size of the slices to be returned.
    /// - Returns: grouped self.
    func group(by size: Int) -> [[Base.Element]]? {
        // Inspired by: https://lodash.com/docs/4.17.4#chunk
        guard size > 0, !base.isEmpty else { return nil }
        var start = base.startIndex
        var slices = [[Base.Element]]()
        while start != base.endIndex {
            let end = base.index(start, offsetBy: size, limitedBy: base.endIndex) ?? base.endIndex
            slices.append(Array(base[start..<end]))
            start = end
        }
        return slices
    }

    /// ReerKit: Get all indices where condition is met.
    ///
    ///     [1, 7, 1, 2, 4, 1, 8].re.indices(where: { $0 == 1 }) -> [0, 2, 5]
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: all indices where the specified condition evaluates to true (optional).
    func indices(where condition: (Base.Element) throws -> Bool) rethrows -> [Base.Index]? {
        let indices = try base.indices.filter { try condition(base[$0]) }
        return indices.isEmpty ? nil : indices
    }

    /// ReerKit: Calls the given closure with an array of size of the parameter slice.
    ///
    ///     [0, 2, 4, 7].re.forEach(slice: 2) { print($0) } -> // print: [0, 2], [4, 7]
    ///     [0, 2, 4, 7, 6].re.forEach(slice: 2) { print($0) } -> // print: [0, 2], [4, 7], [6]
    ///
    /// - Parameters:
    ///   - slice: size of array in each interation.
    ///   - body: a closure that takes an array of slice size as a parameter.
    func forEach(slice: Int, body: ([Base.Element]) throws -> Void) rethrows {
        var start = base.startIndex
        while case let end = base.index(start, offsetBy: slice, limitedBy: base.endIndex) ?? base.endIndex,
            start != end {
            try body(Array(base[start..<end]))
            start = end
        }
    }
    
    func forEach(_ body: (Base.Element, Int) throws  -> Void) rethrows {
        for (index, item) in base.enumerated() {
            try body(item, index)
        }
    }
}

// MARK: - Methods (Equatable)

public extension Reer where Base: Collection, Base.Element: Equatable {

    /// ReerKit: All indices of specified item.
    ///
    ///        [1, 2, 2, 3, 4, 2, 5].re.indices(of 2) -> [1, 2, 5]
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].re.indices(of 2.3) -> [1]
    ///        ["h", "e", "l", "l", "o"].re.indices(of "l") -> [2, 3]
    ///
    /// - Parameter item: item to check.
    /// - Returns: an array with all indices of the given item.
    func indices(of item: Base.Element) -> [Base.Index] {
        return base.indices.filter { base[$0] == item }
    }
}

// MARK: - Methods (BinaryInteger)
public extension Reer where Base: Collection, Base.Element: BinaryInteger {
    /// ReerKit: Average of all elements in array.
    ///
    /// - Returns: the average of the array's elements.
    func average() -> Double {
        // http://stackoverflow.com/questions/28288148/making-my-function-calculate-average-of-array-swift
        guard !base.isEmpty else { return .zero }
        return Double(base.reduce(.zero, +)) / Double(base.count)
    }
}

// MARK: - Methods (FloatingPoint)
public extension Reer where Base: Collection, Base.Element: FloatingPoint {
    /// ReerKit: Average of all elements in array.
    ///
    ///        [1.2, 2.3, 4.5, 3.4, 4.5].re.average() = 3.18
    ///
    /// - Returns: average of the array's elements.
    func average() -> Base.Element {
        guard !base.isEmpty else { return .zero }
        return base.reduce(.zero, +) / Base.Element(base.count)
    }
}
