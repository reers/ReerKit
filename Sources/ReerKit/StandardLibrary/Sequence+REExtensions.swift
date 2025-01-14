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

public extension Reer where Base: Sequence {
    
    /// ReerKit: Check if all elements in collection match a condition.
    ///
    ///     [2, 2, 4].re.all(matching: { $0 % 2 == 0 }) -> true
    ///     [1,2, 2, 4].re.all(matching: { $0 % 2 == 0 }) -> false
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: true when all elements in the array match the specified condition.
    func all(matching condition: (Base.Element) throws -> Bool) rethrows -> Bool {
        return try !base.contains { try !condition($0) }
    }

    /// ReerKit: Check if no elements in collection match a condition.
    ///
    ///     [2, 2, 4].re.none(matching: { $0 % 2 == 0 }) -> false
    ///     [1, 3, 5, 7].re.none(matching: { $0 % 2 == 0 }) -> true
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: true when no elements in the array match the specified condition.
    func none(matching condition: (Base.Element) throws -> Bool) rethrows -> Bool {
        return try !base.contains { try condition($0) }
    }

    /// ReerKit: Check if any element in collection match a condition.
    ///
    ///     [1, 2, 5].re.any(matching: { $0 % 2 == 0 }) -> true
    ///     [1, 3, 5, 7].re.any(matching: { $0 % 2 == 0 }) -> false
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: true when no elements in the array match the specified condition.
    func any(matching condition: (Base.Element) throws -> Bool) rethrows -> Bool {
        return try base.contains { try condition($0) }
    }

    /// ReerKit: Filter elements based on a rejection condition.
    ///
    ///     [2, 2, 4, 7].re.reject(where: { $0 % 2 == 0 }) -> [7]
    ///
    /// - Parameter condition: to evaluate the exclusion of an element from the array.
    /// - Returns: the array with rejected values filtered from it.
    func reject(where condition: (Base.Element) throws -> Bool) rethrows -> [Base.Element] {
        return try base.filter { return try !condition($0) }
    }

    /// ReerKit: Get element count based on condition.
    ///
    ///     [2, 2, 4, 7].re.count(where: { $0 % 2 == 0 }) -> 3
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: number of times the condition evaluated to true.
    func count(where condition: (Base.Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in base where try condition(element) {
            count += 1
        }
        return count
    }
    
    /// ReerKit: Iterate over a collection in reverse order. (right to left)
    ///
    ///     [0, 2, 4, 7].re.reversedForEach({ print($0) }) -> // Order of print: 7,4,2,0
    ///
    /// - Parameter body: a closure that takes an element of the array as a parameter.
    func reversedForEach(_ body: (Base.Element) throws -> Void) rethrows {
        try base.reversed().forEach(body)
    }

    /// ReerKit: Calls the given closure with each element where condition is true.
    ///
    ///     [0, 2, 4, 7].re.forEach({ print($0) }, where: { $0 % 2 == 0 }) -> // print: 0, 2, 4
    ///
    /// - Parameters:
    ///   - body: a closure that takes an element of the array as a parameter.
    ///   - condition: condition to evaluate each element against.
    func forEach(_ body: (Base.Element) throws -> Void, where condition: (Base.Element) throws -> Bool) rethrows {
        try base.lazy.filter(condition).forEach(body)
    }
    
    /// ReerKit: Filtered and map in a single operation.
    ///
    ///     [1, 2, 3, 4, 5].re.map({ $0.re.string }, where: { $0 % 2 == 0 }) -> ["2", "4"]
    ///
    /// - Parameters:
    ///   - isIncluded: condition of inclusion to evaluate each element against.
    ///   - transform: transform element function to evaluate every element.
    /// - Returns: Return an filtered and mapped array.
    func map<T>(_ transform: (Base.Element) throws -> T, where condition: (Base.Element) throws -> Bool) rethrows -> [T] {
        return try base.lazy.filter(condition).map(transform)
    }

    /// ReerKit: Separates all items into 2 lists based on a given predicate. The first list contains all items for which the specified condition evaluates to true.
    /// The second list contains those that don't.
    ///
    ///     let (even, odd) = [0, 1, 2, 3, 4, 5].re.divided { $0 % 2 == 0 }
    ///     let (minors, adults) = people.re.divided { $0.age < 18 }
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: A tuple of matched and non-matched items
    func divided(by condition: (Base.Element) throws -> Bool) rethrows -> (matching: [Base.Element], nonMatching: [Base.Element]) {
        var matching = [Base.Element]()
        var nonMatching = [Base.Element]()

        for element in base {
            try condition(element) ? matching.append(element) : nonMatching.append(element)
        }
        return (matching, nonMatching)
    }

    /// ReerKit: Return a sorted array based on a key path and a compare function.
    ///
    ///     ["James", "Wade", "Bryant"].re.sorted(by: \String.count, with: <) -> ["Wade", "James", "Bryant"]
    ///
    /// - Parameter keyPath: Key path to sort by.
    /// - Parameter compare: Comparation function that will determine the ordering.
    /// - Returns: The sorted array.
    func sorted<T>(by keyPath: KeyPath<Base.Element, T>, with compare: (T, T) -> Bool) -> [Base.Element] {
        return base.sorted { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }

    /// ReerKit: Return a sorted array based on a key path.
    ///
    /// - Parameter keyPath: Key path to sort by. The key path type must be Comparable.
    /// - Returns: The sorted array.
    func sorted<T: Comparable>(by keyPath: KeyPath<Base.Element, T>) -> [Base.Element] {
        return base.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// ReerKit: Returns a sorted sequence based on two key paths. The second one will be used in case the values of the first one match.
    ///
    /// - Parameters:
    ///     - keyPath1: Key path to sort by. Must be Comparable.
    ///     - keyPath2: Key path to sort by in case the values of `keyPath1` match. Must be Comparable.
    func sorted<T: Comparable, U: Comparable>(
        by keyPath1: KeyPath<Base.Element, T>,
        and keyPath2: KeyPath<Base.Element, U>
    ) -> [Base.Element] {
        return base.sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    /// ReerKit: Returns a sorted sequence based on three key paths. Whenever the values of one key path match, the next one will be used.
    ///
    /// - Parameters:
    ///     - keyPath1: Key path to sort by. Must be Comparable.
    ///     - keyPath2: Key path to sort by in case the values of `keyPath1` match. Must be Comparable.
    ///     - keyPath3: Key path to sort by in case the values of `keyPath1` and `keyPath2` match. Must be Comparable.
    func sorted<T: Comparable, U: Comparable, V: Comparable>(
        by keyPath1: KeyPath<Base.Element, T>,
        and keyPath2: KeyPath<Base.Element, U>,
        and keyPath3: KeyPath<Base.Element, V>
    ) -> [Base.Element] {
        return base.sorted {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }

    /// ReerKit: Sum of a `AdditiveArithmetic` property of each `Element` in a `Sequence`.
    ///
    ///     ["James", "Wade", "Bryant"].re.sum(for: \.count) -> 15
    ///
    /// - Parameter keyPath: Key path of the `AdditiveArithmetic` property.
    /// - Returns: The sum of the `AdditiveArithmetic` properties at `keyPath`.
    func sum<T: AdditiveArithmetic>(for keyPath: KeyPath<Base.Element, T>) -> T {
        return base.reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }
    
    /// ReerKit: Get last element that satisfies a conditon.
    ///
    ///     [2, 2, 4, 7].re.last(where: { $0 % 2 == 0 }) -> 4
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: the last element in the array matching the specified condition. (optional)
    func last(where condition: (Base.Element) throws -> Bool) rethrows -> Base.Element? {
        return try base.reversed().first(where: condition)
    }
}

public extension Reer where Base: Sequence, Base.Element: Hashable {
    /// ReerKit: Check if array contains an array of elements.
    ///
    ///     [1, 2, 3, 4, 5].re.contains([1, 2]) -> true
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].re.contains([2, 6]) -> false
    ///     ["h", "e", "l", "l", "o"].re.contains(["l", "o"]) -> true
    ///
    /// - Parameter elements: array of elements to check.
    /// - Returns: true if array contains all given items.
    /// - Complexity: _O(m + n)_, where _m_ is the length of `elements` and _n_ is the length of this sequence.
    func contains(_ elements: [Base.Element]) -> Bool {
        let set = Set(base)
        return elements.allSatisfy { set.contains($0) }
    }

    /// ReerKit: Check whether a sequence contains duplicates.
    ///
    /// - Returns: true if the receiver contains duplicates.
    func containsDuplicates() -> Bool {
        var set = Set<Base.Element>()
        for element in base {
            if !set.insert(element).inserted {
                return true
            }
        }
        return false
    }
    
    /// ReerKit: Getting the duplicated elements in a sequence.
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].re.duplicates().sorted() -> [1, 2, 3])
    ///     ["h", "e", "l", "l", "o"].re.duplicates().sorted() -> ["l"])
    ///
    /// - Returns: An array of duplicated elements.
    ///
    func duplicates() -> [Base.Element] {
        var set = Set<Base.Element>()
        var duplicates = Set<Base.Element>()
        base.forEach {
            if !set.insert($0).inserted {
                duplicates.insert($0)
            }
        }
        return Array(duplicates)
    }
    
    /// ReerKit: Remove duplicate elements.
    ///
    ///     [1, 2, 1, 3, 2].re.withoutDuplicates() -> [1, 2, 3]
    ///
    /// - Returns: Sequence without repeating elements
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    func withoutDuplicates() -> [Base.Element] {
        var set = Set<Base.Element>()
        return base.filter { set.insert($0).inserted }
    }
}

public extension Reer where Base: Sequence, Base.Element: Equatable {
    /// ReerKit: Check if array contains an array of elements.
    ///
    ///     [1, 2, 3, 4, 5].re.contains([1, 2]) -> true
    ///     [1.2, 2.3, 4.5, 3.4, 4.5].re.contains([2, 6]) -> false
    ///     ["h", "e", "l", "l", "o"].re.contains(["l", "o"]) -> true
    ///
    /// - Parameter elements: array of elements to check.
    /// - Returns: true if array contains all given items.
    /// - Complexity: _O(m·n)_, where _m_ is the length of `elements` and _n_ is the length of this sequence.
    func contains(_ elements: [Base.Element]) -> Bool {
        return elements.allSatisfy { base.contains($0) }
    }
}

public extension Reer where Base: Sequence, Base.Element: AdditiveArithmetic {
    /// ReerKit: Sum of all elements in array.
    ///
    ///        [1, 2, 3, 4, 5].re.sum() -> 15
    ///
    /// - Returns: sum of the array's elements.
    func sum() -> Base.Element {
        return base.reduce(.zero, +)
    }
}
