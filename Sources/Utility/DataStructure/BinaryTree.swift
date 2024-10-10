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

/// Define a generic binary tree data structure
public indirect enum BinaryTree<E> {
    /// Each node contains a left subtree, a value, and a right subtree
    case node(BinaryTree<E>, E, BinaryTree<E>)
    /// Represents an empty node (leaf)
    case empty
    
    /// Computed property to count the total number of nodes in the tree
    public var count: Int {
        switch self {
        case let .node(left, _, right):
            // Count is the sum of counts from left and right subtrees plus one for the current node
            return left.count + 1 + right.count
        case .empty:
            // Empty node contributes zero to the count
            return 0
        }
    }
}

/// Extension to add traversal methods to the binary tree
extension BinaryTree {
    /// In-order traversal (Left, Root, Right)
    public func traverseInOrder(process: (E) -> Void) {
        if case let .node(left, value, right) = self {
            // Traverse the left subtree
            left.traverseInOrder(process: process)
            // Process the current node's value
            process(value)
            // Traverse the right subtree
            right.traverseInOrder(process: process)
        }
    }
    
    /// Pre-order traversal (Root, Left, Right)
    public func traversePreOrder(process: (E) -> Void) {
        if case let .node(left, value, right) = self {
            // Process the current node's value
            process(value)
            // Traverse the left subtree
            left.traversePreOrder(process: process)
            // Traverse the right subtree
            right.traversePreOrder(process: process)
        }
    }
    
    /// Post-order traversal (Left, Right, Root)
    public func traversePostOrder(process: (E) -> Void) {
        if case let .node(left, value, right) = self {
            // Traverse the left subtree
            left.traversePostOrder(process: process)
            // Traverse the right subtree
            right.traversePostOrder(process: process)
            // Process the current node's value
            process(value)
        }
    }
    
    /// Level-order traversal (Breadth-first traversal)
    public func traverseLevelOrder(process: (E) -> Void) {
        // Use a queue to keep track of nodes to visit
        var queue = Queue<BinaryTree<E>>()
        // Start with the root node
        queue.enqueue(self)
        
        // Continue until there are no more nodes to visit
        while !queue.isEmpty {
            guard let node = queue.dequeue() else { continue }
            
            if case let .node(left, value, right) = node {
                // Process the current node's value
                process(value)
                
                // Enqueue the left child if it is a node
                if case .node(_, _, _) = left {
                    queue.enqueue(left)
                }
                
                // Enqueue the right child if it is a node
                if case .node(_, _, _) = right {
                    queue.enqueue(right)
                }
            }
        }
    }
}

extension BinaryTree {
    // Function to invert (mirror) the binary tree
    func invert() -> BinaryTree {
        switch self {
        case let .node(left, value, right):
            // Swap the left and right subtrees recursively
            return .node(right.invert(), value, left.invert())
        case .empty:
            // If the node is empty, return empty
            return .empty
        }
    }
}
