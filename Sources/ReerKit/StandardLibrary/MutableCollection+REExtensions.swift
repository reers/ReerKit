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

public extension ReerForMutableCollection where Base: MutableCollection & RandomAccessCollection {
    
    /// ReerKit: Sort the collection based on a keypath and a compare function.
    ///
    /// - Parameter keyPath: Key path to sort by. The key path type must be Comparable.
    /// - Parameter compare: Comparation function that will determine the ordering.
    mutating func sort<T>(by keyPath: KeyPath<Base.Element, T>, with compare: (T, T) -> Bool) {
        base.pointee.sort { compare($0[keyPath: keyPath], $1[keyPath: keyPath]) }
    }
    
    /// ReerKit: Sort the collection based on a keypath.
    ///
    /// - Parameter keyPath: Key path to sort by. The key path type must be Comparable.
    mutating func sort<T: Comparable>(by keyPath: KeyPath<Base.Element, T>) {
        base.pointee.sort { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    /// ReerKit: Sort the collection based on two key paths. The second one will be used in case the values of the first one match.
    ///
    /// - Parameters:
    ///     - keyPath1: Key path to sort by. Must be Comparable.
    ///     - keyPath2: Key path to sort by in case the values of `keyPath1` match. Must be Comparable.
    mutating func sort<T: Comparable, U: Comparable>(
        by keyPath1: KeyPath<Base.Element, T>,
        and keyPath2: KeyPath<Base.Element, U>
    ) {
        base.pointee.sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
        }
    }

    /// ReerKit: Sort the collection based on three key paths. Whenever the values of one key path match, the next one will be used.
    ///
    /// - Parameters:
    ///     - keyPath1: Key path to sort by. Must be Comparable.
    ///     - keyPath2: Key path to sort by in case the values of `keyPath1` match. Must be Comparable.
    ///     - keyPath3: Key path to sort by in case the values of `keyPath1` and `keyPath2` match. Must be Comparable.
    mutating func sort<T: Comparable, U: Comparable, V: Comparable>(
        by keyPath1: KeyPath<Base.Element, T>,
        and keyPath2: KeyPath<Base.Element, U>,
        and keyPath3: KeyPath<Base.Element, V>
    ) {
        base.pointee.sort {
            if $0[keyPath: keyPath1] != $1[keyPath: keyPath1] {
                return $0[keyPath: keyPath1] < $1[keyPath: keyPath1]
            }
            if $0[keyPath: keyPath2] != $1[keyPath: keyPath2] {
                return $0[keyPath: keyPath2] < $1[keyPath: keyPath2]
            }
            return $0[keyPath: keyPath3] < $1[keyPath: keyPath3]
        }
    }
}

public extension ReerForMutableCollection where Base: MutableCollection {
    /// ReerKit: Assign a given value to a field `keyPath` of all elements in the collection.
    ///
    /// - Parameters:
    ///   - value: The new value of the field.
    ///   - keyPath: The actual field of the element.
    mutating func assignToAll<Value>(value: Value, by keyPath: WritableKeyPath<Base.Element, Value>) {
        for idx in base.pointee.indices {
            base.pointee[idx][keyPath: keyPath] = value
        }
    }
}
