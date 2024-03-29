//
//  Copyright © 2020 apple.
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

/// ReerKit: An ordered set is an ordered collection of instances of `Element` in which
/// uniqueness of the objects is guaranteed.
///
///     var set = OrderedSet<String>()
///     set.append("a")
///     set.insert("b", at: 1)
///     set.append("c")
///     set.map { Int($0)! } // [1, 2, 3], in this order.
public struct OrderedSet<Element: Hashable> {
    private var array: [Element] = []
    private var set: Set<Element> = []
    
    /// Creates an empty ordered set.
    public init() {
        self.array = []
        self.set = Set()
    }
    
    /// Creates an empty ordered set.
    public init(_ array: [Element]) {
        self.init()
        for element in array {
            append(element)
        }
    }
    
    public var count: Int {
        return array.count
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    /// Array value of the ordered set.
    public var elements: [Element] {
        return array
    }
    
    public func contains(_ member: Element) -> Bool {
        return set.contains(member)
    }
    
    /// Append a new member to the end of the set, if the set doesn't
    /// already contain it.
    ///
    /// - Parameter item: The element to add to the set.
    ///
    /// - Returns: A pair `(inserted, index)`, where `inserted` is a Boolean value
    ///    indicating whether the operation added a new element, and `index` is
    ///    the index of `item` in the resulting set.
    ///
    /// - Complexity: The operation is expected to perform O(1) copy, hash, and
    ///    compare operations on the `Element` type, if it implements high-quality
    ///    hashing.
    @discardableResult
    public mutating func append(_ newElement: Element) -> (inserted: Bool, index: Int) {
        let inserted = set.insert(newElement).inserted
        if inserted {
            array.append(newElement)
        }
        return (inserted, array.index(before: array.endIndex))
    }
    
    /// Insert a new member to this set at the specified index, if the set doesn't
    /// already contain it.
    ///
    /// - Parameter item: The element to insert.
    ///
    /// - Returns: A pair `(inserted, index)`, where `inserted` is a Boolean value
    ///    indicating whether the operation added a new element, and `index` is
    ///    the index of `item` in the resulting set. If `inserted` is false, then
    ///    the returned `index` may be different from the index requested.
    ///
    /// - Complexity: The operation is expected to perform amortized
    ///    O(`self.count`) copy, hash, and compare operations on the `Element`
    ///    type, if it implements high-quality hashing. (Insertions need to make
    ///    room in the storage array to add the inserted element.)
    @discardableResult
    public mutating func insert(_ newElement: Element, at index: Int) -> (inserted: Bool, index: Int) {
        if let existingIndex = array.firstIndex(of: newElement) {
            return (false, existingIndex)
        }
        let inserted = set.insert(newElement).inserted
        if inserted {
            array.insert(newElement, at: index)
        }
        return (inserted, index)
    }
    
    /// Remove and return the element at the beginning of the ordered set.
    @discardableResult
    public mutating func removeFirst() -> Element {
        let firstElement = array.removeFirst()
        set.remove(firstElement)
        return firstElement
    }
    
    /// Remove and return the element at the end of the ordered set.
    @discardableResult
    public mutating func removeLast() -> Element {
        let lastElement = array.removeLast()
        set.remove(lastElement)
        return lastElement
    }
    
    @discardableResult
    public mutating func remove(_ member: Element) -> Element? {
        guard let index = array.firstIndex(of: member) else { return nil }
        array.remove(at: index)
        return set.remove(member)
    }
    
    /// Remove all elements.
     public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
         array.removeAll(keepingCapacity: keepCapacity)
         set.removeAll(keepingCapacity: keepCapacity)
     }
}


extension OrderedSet: Collection {
    public typealias Index = Int
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { array.count }
    
    public func index(after i: Int) -> Int { i + 1 }
    
    public subscript(position: Int) -> Element {
        return array[position]
    }
}

extension OrderedSet: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension OrderedSet: CustomStringConvertible {
    public var description: String {
        if array.isEmpty {
            return "[]"
        } else {
            return "[\(array.map { String(reflecting: $0) }.joined(separator: ", "))]"
        }
    }
}

extension OrderedSet: Equatable where Element: Equatable {
    public static func == (lhs: OrderedSet, rhs: OrderedSet) -> Bool {
        return lhs.array == rhs.array
    }
}
