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

public final class LinkedList<E> {
    
    fileprivate class LinkedListNode<E> {
        var value: E
        var next: LinkedListNode?
        weak var previous: LinkedListNode?
        
        public init(value: E, previous: LinkedListNode? = nil, next: LinkedListNode? = nil) {
            self.value = value
            self.previous = previous
            self.next = next
        }
    }
    
    fileprivate typealias Node = LinkedListNode<E>
    
    public private(set) var count: Int = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    fileprivate var head: Node?
    fileprivate var tail: Node?
    
    public init() {}
    
    private func node(at index: Int) -> Node {
        rangeCheck(for: index)
        
        if index < (count >> 1) {
            var node = head!
            for _ in 0..<index {
                node = node.next!
            }
            return node
        }
        else {
            var node = tail!
            for _ in stride(from: count - 1, to: index, by: -1) {
                node = node.previous!
            }
            return node
        }
    }
    
    public func insert(_ element: E, at index: Int) {
        rangeCheckForAdd(at: index)
        
        if index == count {
            let newTail = Node(value: element)
            if let oldTail = tail {
                newTail.previous = oldTail
                oldTail.next = newTail
            }
            else {
                head = newTail
            }
            tail = newTail
        }
        else {
            let next = self.node(at: index)
            if let prev = next.previous {
                let newNode = Node(value: element, previous: prev, next: next)
                prev.next = newNode
                next.previous = newNode
            }
            else {
                let newNode = Node(value: element, previous: nil, next: next)
                head = newNode
                next.previous = newNode
            }
        }
        count += 1
    }
    
    public func append(_ element: E) {
        insert(element, at: count)
    }
    
    @discardableResult
    public func remove(at index: Int) -> E {
        let node = self.node(at: index)
        return remove(node: node)
    }
    
    @discardableResult
    private func remove(node: Node) -> E {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        }
        else {
            head = next
        }
        
        if let next = next {
            next.previous = prev
        }
        else {
            tail = prev
        }
        
        count -= 1
        return node.value
    }
    
    public func removeFirst() {
        remove(at: 0)
    }
    
    public func removeLast() {
        remove(at: count - 1)
    }
    
    public func removeAll() {
        count = 0
        head = nil
        tail = nil
    }

    public func set(_ element: E, at index: Int) {
        let old = self.node(at: index)
        old.value = element
    }
    
    public subscript(index: Int) -> E {
        let node = self.node(at: index)
        return node.value
    }
    
    private func rangeCheck(for index: Int) {
        if isEmpty || index < 0 || index >= count {
            fatalError("Index out of range")
        }
    }
    
    private func rangeCheckForAdd(at index: Int) {
        if index < 0 || index > count {
            fatalError("Index out of range")
        }
    }
    
}


extension LinkedList where E: Equatable {
    
    public func firstIndex(of element: E) -> Int? {
        if var node = head {
            for index in 0..<count {
                if element == node.value {
                    return index
                }
                guard let next = node.next else { break }
                node = next
            }
        }
        return nil
    }
    
    public func lastIndex(of element: E) -> Int? {
        if var node = tail {
           for index in stride(from: count - 1, through: 0, by: -1) { 
                if element == node.value {
                    return index
                }
                guard let prev = node.previous else { break }
                node = prev
            }
        }
        return nil
    }
    
    
    public func contains(element: E) -> Bool {
        return firstIndex(of: element) != nil
    }
    
    public func removeAll(_ element: E) {
        guard !isEmpty else { return }
        var node = head
        while let current = node {
            node = current.next
            if current.value == element {
                remove(node: current)
            }
        }
    }
    
    public func removeAll(_ elements: [E]) {
        guard !isEmpty else { return }
        var node = head
        while let current = node {
            node = current.next
            if elements.contains(current.value) {
                remove(node: current)
            }
        }
    }
    
    public func removeAll(where shouldBeRemoved: (E) throws -> Bool) rethrows {
        guard !isEmpty else { return }
        var node = head
        while let current = node {
            node = current.next
            if try shouldBeRemoved(current.value) {
                remove(node: current)
            }
        }
    }
    
}

// MARK: - Initializer

extension LinkedList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: E...) {
        self.init()
        elements.forEach { append($0) }
    }
}


// MARK: - Other Extensions

extension LinkedList {
    
    public var array: [E] {
        var array = [E]()
        var node = head
        while let next = node {
            node = next.next
            array.append(next.value)
        }
        return array
    }
    
    public func reverse() {
        var node = head
        while let current = node {
            node = current.next
            swap(&current.next, &current.previous)
            head = current
        }
    }
}

extension LinkedList: CustomStringConvertible {
    
    public var description: String {
        var s = ""
        var node = head
        while let nd = node {
            s += "\(nd.value)"
            node = nd.next
            if node != nil { s += "⇋" }
        }
        return s
    }
}

// MARK: - An extension with an implementation of 'map' & 'filter' functions

extension LinkedList {
    
    public func map<T>(transform: (E) -> T) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while let nd = node {
            result.append(transform(nd.value))
            node = nd.next
        }
        return result
    }
    
    public func filter(predicate: (E) -> Bool) -> LinkedList<E> {
        let result = LinkedList<E>()
        var node = head
        while let nd = node {
            if predicate(nd.value) {
                result.append(nd.value)
            }
            node = nd.next
        }
        return result
    }
}


// MARK: - Colletion

extension LinkedList: Sequence {
    public func makeIterator() -> LinkedListIterator<E> {
        return LinkedListIterator(linkedList: self)
    }
}

public struct LinkedListIterator<E>: IteratorProtocol {
    let linkedList: LinkedList<E>
    fileprivate var current: LinkedList<E>.LinkedListNode<E>?
    
    init(linkedList: LinkedList<E>) {
        self.linkedList = linkedList
        current = linkedList.head
    }
    
    public mutating func next() -> E? {
        defer { current = current?.next }
        return current?.value
    }
}

