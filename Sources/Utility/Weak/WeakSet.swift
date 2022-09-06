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

/// A set class that weak refering every AnyObject element.
/// If the object element released, its weak wrapper `Weak<T>` will remove from the internal set automatically.
///
///     var aa: NSObject? = NSObject()
///     let bb: NSObject? = NSObject()
///     let set = WeakSet([aa!, bb!])
///
public class WeakSet<T: AnyObject>: ExpressibleByArrayLiteral {

    fileprivate var objectSet: Set<Weak<T>>

    public init() {
        self.objectSet = Set<Weak<T>>()
    }

    public init(_ objects: [T]) {
        self.objectSet = Set<Weak<T>>(objects.map { Weak($0) })
        addDeinitObservers(for: self.objectSet)
    }

    public required convenience init(arrayLiteral elements: T...) {
        self.init(elements)
    }

    public var allObjects: [T] {
        return objectSet.compactMap { $0.object }
    }

    public var count: Int {
        return objectSet.count
    }

    public func contains(_ object: T) -> Bool {
        return objectSet.contains(Weak(object))
    }

    public func add(_ object: T) {
        let weakBox = Weak(object)
        objectSet.insert(weakBox)
        observeDeinit(for: object) { [weak self] in
            guard let self = self else { return }
            self.objectSet.remove(weakBox)
        }
    }

    public func addObjects(_ objects: [T]) {
        let array = objects.map { Weak($0) }
        objectSet.formUnion(array)
        addDeinitObservers(for: Set(array))
    }

    public func remove(_ object: T) {
        objectSet.remove(Weak(object))
    }

    public func removeObjects(_ objects: [T]) {
        objectSet.subtract(objects.map { Weak($0) })
    }

    public func copy() -> WeakSet<T> {
        return WeakSet(objectSet)
    }

    private init(_ set: Set<Weak<T>>) {
        self.objectSet = set
    }

    private func addDeinitObservers(for set: Set<Weak<T>>) {
        for box in set {
            guard let obj = box.object else {
                objectSet.remove(box)
                continue
            }
            observeDeinit(for: obj) { [weak self] in
                guard let self = self else { return }
                self.objectSet.remove(box)
            }
        }
    }
}


// MARK: - Sequence

extension WeakSet: Sequence {
    public func makeIterator() -> WeakSetIterator<T> {
        return WeakSetIterator(self)
    }
}

public struct WeakSetIterator<T: AnyObject>: IteratorProtocol {
    let weakSet: WeakSet<T>
    private var currentIndex = 0
    init(_ weakSet: WeakSet<T>) {
        self.weakSet = weakSet
    }

    public mutating func next() -> T? {
        if currentIndex >= weakSet.count { return nil }
        let set = weakSet.objectSet
        let startIndex = set.startIndex
        let index = set.index(startIndex, offsetBy: currentIndex)
        defer { currentIndex += 1 }
        return set[index].object
    }
}
