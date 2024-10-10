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

/// Define a generic N-ary tree data structure as a class with parent pointers
public class Tree<E> {
    /// The value stored in the node
    public var value: E
    /// The children of the node
    public var children: [Tree<E>] = [] {
        didSet {
            // Set the parent of each child to self
            for child in children {
                child.parent = self
            }
        }
    }
    /// The parent node; weak to prevent retain cycles
    public weak var parent: Tree<E>?

    /// Computed property to count the total number of nodes in the tree
    public var count: Int {
        // Count is the sum of counts from all subtrees plus one for the current node
        return 1 + children.reduce(0) { $0 + $1.count }
    }

    /// Initialize a node with a value
    public init(value: E) {
        self.value = value
    }

    /// Add a child node with a value
    @discardableResult
    public func addChild(value: E) -> Tree<E> {
        let child = Tree(value: value)
        child.parent = self
        children.append(child)
        return child
    }

    /// Add an existing tree as a child
    @discardableResult
    public func addChild(_ child: Tree<E>) -> Tree<E> {
        child.parent = self
        children.append(child)
        return child
    }
}

/// Extension to add inversion methods to the N-ary tree
extension Tree {
    /// Function to invert (mirror) the N-ary tree in place
    public func invert() {
        // Recursively invert each child subtree
        for child in children {
            child.invert()
        }
        // Reverse the order of children to mirror the tree
        children.reverse()
    }

    /// Function to get a new inverted (mirrored) N-ary tree
    public func inverted() -> Tree<E> {
        // Create a new node with the current value
        let newNode = Tree(value: value)
        // Recursively invert each child subtree and add them in reversed order
        for child in children.reversed() {
            newNode.addChild(child.inverted())
        }
        // Parent pointers are set via didSet in the Tree class
        return newNode
    }
}

extension Tree: CustomStringConvertible {
    public var description: String {
        return treeString()
    }
}

extension Tree {
    /// Prints the tree structure as a string.
    public func printTreeString() {
        print(treeString())
    }

    /// Generates a string representation of the tree structure.
    ///
    /// ```swift
    /// Root
    /// ├── Child2
    /// ├── Child1
    /// │   └── Grandchild2
    /// │       └── GreatGrandchild0
    /// └── Child0
    ///     ├── Grandchild1
    ///     └── Grandchild0
    /// ```
    ///
    /// - Returns: A string representing the tree structure.
    public func treeString() -> String {
        return treeString(
            indent: "",
            isLast: true,
            isRoot: true
        )
    }

    private func treeString(
        indent: String,
        isLast: Bool,
        isRoot: Bool
    ) -> String {

        var line = indent

        if !isRoot {
            line += isLast ? "└── " : "├── "
        }

        line += "\(value)\n"

        var newIndent = indent

        if !isRoot {
            newIndent += isLast ? "    " : "│   "
        }
        var childLines = ""
        // Reverse the order of children to print rightmost first
        let childCount = children.count
        if childCount > 0 {
            let reversedChildren = children.reversed()
            for (idx, child) in reversedChildren.enumerated() {
                let childIsLast = idx == childCount - 1
                childLines += child.treeString(
                    indent: newIndent,
                    isLast: childIsLast,
                    isRoot: false
                )
            }
        }

        return line + childLines
    }
}
