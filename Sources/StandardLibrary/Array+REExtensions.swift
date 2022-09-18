//
//  Copyright © 2020 ReerKit
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


extension Array: ReerGenericCompatible {
    public typealias T = Element
}

// MARK: - Methods

public extension ReerGeneric where Base == Array<T> {
    /// ReerKit: Insert an element at the beginning of array.
    ///
    ///     var array = [2, 3, 4, 5]
    ///     array.re.prepend(1) -> [1, 2, 3, 4, 5]
    ///
    /// - Parameter newElement: element to insert.
    mutating func prepend(_ newElement: T) {
        base.insert(newElement, at: 0)
    }

    /// ReerKit: Safely swap values at given index positions.
    ///
    ///     var array = [1, 2, 3, 4, 5]
    ///     array.re.swapAt(3, 0) -> [4, 2, 3, 1, 5]
    ///     array.re.swapAt(3, 10) -> [1, 2, 3, 4, 5]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    mutating func swapAt(_ index: Base.Index, _ otherIndex: Base.Index) {
        guard index != otherIndex else { return }
        guard base.startIndex..<base.endIndex ~= index else { return }
        guard base.startIndex..<base.endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
}

// MARK: - Methods (Equatable)

public extension ReerGeneric where Base == Array<T>, T: Equatable {
    /// ReerKit: Remove all instances of an item from array.
    ///
    ///        [1, 2, 2, 3, 4, 5].re.removeAll(2) -> [1, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"].re.removeAll("l") -> ["h", "e", "o"]
    ///
    /// - Parameter item: item to remove.
    /// - Returns: self after removing all instances of item.
    @discardableResult
    mutating func removeAll(_ item: T) -> [T] {
        base.removeAll(where: { $0 == item })
        return base
    }

    /// ReerKit: Remove all instances contained in items parameter from array.
    ///
    ///        [1, 2, 2, 3, 4, 5].re.removeAll([2,5]) -> [1, 3, 4]
    ///        ["h", "e", "l", "l", "o"].re.removeAll(["l", "h"]) -> ["e", "o"]
    ///
    /// - Parameter items: items to remove.
    /// - Returns: self after removing all instances of all items in given array.
    @discardableResult
    mutating func removeAll(_ items: [T]) -> [T] {
        guard !items.isEmpty else { return base }
        base.removeAll(where: { items.contains($0) })
        return base
    }

    /// ReerKit: Remove all duplicate elements from Array.
    ///
    ///        [1, 2, 2, 3, 4, 5].re.removeDuplicates() -> [1, 2, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"].re.removeDuplicates() -> ["h", "e", "l", "o"]
    ///
    /// - Returns: Return array with all duplicate elements removed.
    @discardableResult
    mutating func removeDuplicates() -> [T] {
        base = base.reduce(into: [T]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
        return base
    }

    /// ReerKit: Return array with all duplicate elements removed.
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].re.removingDuplicates() -> [1, 2, 3, 4, 5])
    ///     ["h", "e", "l", "l", "o"].re.removingDuplicates() -> ["h", "e", "l", "o"])
    ///
    /// - Returns: an array of unique elements.
    ///
    func removingDuplicates() -> [T] {
        return base.reduce(into: [T]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }

    /// ReerKit: Returns an array with all duplicate elements removed using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Equatable.
    /// - Returns: an array of unique elements.
    func removingDuplicates<U: Equatable>(keyPath path: KeyPath<T, U>) -> [T] {
        return base.reduce(into: [T]()) { result, element in
            if !result.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                result.append(element)
            }
        }
    }

    /// ReerKit: Returns an array with all duplicate elements removed using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Hashable.
    /// - Returns: an array of unique elements.
    func removingDuplicates<U: Hashable>(keyPath path: KeyPath<T, U>) -> [T] {
        var set = Set<U>()
        return base.filter { set.insert($0[keyPath: path]).inserted }
    }
}

