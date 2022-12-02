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

public extension ReerForRangeReplaceableCollection where Base: RangeReplaceableCollection {

    /// ReerKit: Removes the first element of the collection which satisfies the given predicate.
    ///
    ///        [1, 2, 2, 3, 4, 2, 5].re.removeFirst { $0 % 2 == 0 } -> [1, 2, 3, 4, 2, 5]
    ///        ["h", "e", "l", "l", "o"].re.removeFirst { $0 == "e" } -> ["h", "l", "l", "o"]
    ///
    /// - Parameter predicate: A closure that takes an element as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: The first element for which predicate returns true, after removing it. If no elements in the collection satisfy the given predicate, returns `nil`.
    @discardableResult
    mutating func removeFirst(where predicate: (Base.Element) throws -> Bool) rethrows -> Base.Element? {
        guard let index = try base.pointee.firstIndex(where: predicate) else { return nil }
        return base.pointee.remove(at: index)
    }

    /// ReerKit: Remove a random value from the collection.
    @discardableResult
    mutating func removeRandomElement() -> Base.Element? {
        guard let randomIndex = base.pointee.indices.randomElement() else { return nil }
        return base.pointee.remove(at: randomIndex)
    }

    /// ReerKit: Keep elements of Array while condition is true.
    ///
    ///        [0, 2, 4, 7].re.keep(while: { $0 % 2 == 0 }) -> [0, 2, 4]
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: self after applying provided condition.
    /// - Throws: provided condition exception.
    @discardableResult
    mutating func keep(while condition: (Base.Element) throws -> Bool) rethrows -> Self {
        if let idx = try base.pointee.firstIndex(where: { try !condition($0) }) {
            base.pointee.removeSubrange(idx...)
        }
        return self
    }

    /// ReerKit: Remove all duplicate elements using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Equatable.
    mutating func removeDuplicates<E: Equatable>(keyPath path: KeyPath<Base.Element, E>) {
        var items = [Base.Element]()
        base.pointee.removeAll { element -> Bool in
            guard items.contains(where: { $0[keyPath: path] == element[keyPath: path] }) else {
                items.append(element)
                return false
            }
            return true
        }
    }

    /// ReerKit: Remove all duplicate elements using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Hashable.
    mutating func removeDuplicates<E: Hashable>(keyPath path: KeyPath<Base.Element, E>) {
        var set = Set<E>()
        base.pointee.removeAll { !set.insert($0[keyPath: path]).inserted }
    }

    /// ReerKit: Accesses the element at the specified position.
    ///
    /// - Parameter offset: The offset position of the element to access. `offset` must be a valid index offset of the collection that is not equal to the `endIndex` property.
    subscript(offset: Int) -> Base.Element {
        get {
            let collection = base.pointee
            return collection[collection.index(collection.startIndex, offsetBy: offset)]
        }
        set {
            let offsetIndex = base.pointee.index(base.pointee.startIndex, offsetBy: offset)
            base.pointee.replaceSubrange(offsetIndex..<base.pointee.index(after: offsetIndex), with: [newValue])
        }
    }

    /// ReerKit: Accesses a contiguous subrange of the collection’s elements.
    ///
    /// - Parameter range: A range of the collection’s indices offsets. The bounds of the range must be valid indices of the collection.
    subscript<R>(range: R) -> Base.SubSequence where R: RangeExpression, R.Bound == Int {
        get {
            let indexRange = range.relative(to: 0..<base.pointee.count)
            let start = base.pointee.index(base.pointee.startIndex, offsetBy: indexRange.lowerBound)
            let end = base.pointee.index(base.pointee.startIndex, offsetBy: indexRange.upperBound)
            return base.pointee[start..<end]
        }
        set {
            let indexRange = range.relative(to: 0..<base.pointee.count)
            let start = base.pointee.index(base.pointee.startIndex, offsetBy: indexRange.lowerBound)
            let end = base.pointee.index(base.pointee.startIndex, offsetBy: indexRange.upperBound)
            base.pointee.replaceSubrange(start..<end, with: newValue)
        }
    }

    /// ReerKit: Adds a new element at the end of the array, mutates the array in place
    ///
    /// - Parameter newElement: The optional element to append to the array
    mutating func appendIfNonNil(_ newElement: Base.Element?) {
        guard let newElement = newElement else { return }
        base.pointee.append(newElement)
    }

    /// ReerKit: Adds the elements of a sequence to the end of the array, mutates the array in place
    ///
    /// - Parameter newElements: The optional sequence to append to the array
    mutating func appendIfNonNil<S>(contentsOf newElements: S?) where Base.Element == S.Element, S : Sequence {
        guard let newElements = newElements else { return }
        base.pointee.append(contentsOf: newElements)
    }
}

// MARK: - Initializer

public extension RangeReplaceableCollection {
    /// ReerKit: Creates a new collection of a given size where for each position of the collection the value will be the result of a call of the given expression.
    ///
    ///     let values = Array.re(expression: "Value", count: 3)
    ///     print(values)
    ///     // Prints "["Value", "Value", "Value"]"
    ///
    /// - Parameters:
    ///   - expression: The expression to execute for each position of the collection.
    ///   - count: The count of the collection.
    static func re(expression: @autoclosure () throws -> Self.Element, count: Int) rethrows -> Self {
        var collection = Self.init()
        if count > 0 {
            collection.reserveCapacity(count)
            while collection.count < count {
                collection.append(try expression())
            }
        }
        return collection
    }
}
