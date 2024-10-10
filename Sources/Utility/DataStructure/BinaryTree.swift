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

/// Define a generic binary tree data structure as a class with parent pointers
public class BinaryTree<E> {
    /// The value stored in the node
    public var value: E
    /// The left child of the node
    public var left: BinaryTree<E>? {
        didSet {
            left?.parent = self
        }
    }
    /// The right child of the node
    public var right: BinaryTree<E>? {
        didSet {
            right?.parent = self
        }
    }
    /// The parent node; weak to prevent retain cycles
    public weak var parent: BinaryTree<E>?
    
    /// Computed property to count the total number of nodes in the tree
    public var count: Int {
        let leftCount = left?.count ?? 0
        let rightCount = right?.count ?? 0
        // Count is the sum of counts from left and right subtrees plus one for the current node
        return 1 + leftCount + rightCount
    }
    
    /// Initialize a node with a value
    public init(value: E) {
        self.value = value
    }
    
    /// Set a left child with a value
    @discardableResult
    public func setLeft(value: E) -> BinaryTree<E> {
        let child = BinaryTree(value: value)
        self.left = child
        return child
    }
    
    /// Set a right child with a value
    @discardableResult
    public func setRight(value: E) -> BinaryTree<E> {
        let child = BinaryTree(value: value)
        self.right = child
        return child
    }
}

/// Extension to add traversal methods to the binary tree
extension BinaryTree {
    /// In-order traversal (Left, Root, Right)
    public func traverseInorder(process: (E) -> Void) {
        // Traverse the left subtree
        left?.traverseInorder(process: process)
        // Process the current node's value
        process(value)
        // Traverse the right subtree
        right?.traverseInorder(process: process)
    }
    
    /// Pre-order traversal (Root, Left, Right)
    public func traversePreorder(process: (E) -> Void) {
        // Process the current node's value
        process(value)
        // Traverse the left subtree
        left?.traversePreorder(process: process)
        // Traverse the right subtree
        right?.traversePreorder(process: process)
    }
    
    /// Post-order traversal (Left, Right, Root)
    public func traversePostorder(process: (E) -> Void) {
        // Traverse the left subtree
        left?.traversePostorder(process: process)
        // Traverse the right subtree
        right?.traversePostorder(process: process)
        // Process the current node's value
        process(value)
    }
    
    /// Level-order traversal with level information
    public func traverseLevelOrder(process: (E, Int) -> Void) {
        // Use a queue to keep track of nodes to visit
        var queue = Queue<(node: BinaryTree<E>, level: Int)>()
        // Start with the root node
        queue.enqueue((self, 0))
        
        // Continue until there are no more nodes to visit
        while !queue.isEmpty {
            guard let (node, level) = queue.dequeue() else { continue }
            // Process the node's value along with its level
            process(node.value, level)
            
            // Enqueue the left child if it exists
            if let left = node.left {
                queue.enqueue((left, level + 1))
            }
            // Enqueue the right child if it exists
            if let right = node.right {
                queue.enqueue((right, level + 1))
            }
        }
    }
}

/// Extension to add inversion methods to the binary tree
extension BinaryTree {
    /// Function to invert (mirror) the binary tree in place
    public func invert() {
        // Recursively invert the left and right subtrees
        left?.invert()
        right?.invert()
        // Swap the left and right children
        swap(&left, &right)
        // Parent pointers are updated via didSet
    }
    
    /// Function to get a new inverted (mirrored) binary tree
    public func inverted() -> BinaryTree<E> {
        // Create a new node with the current value
        let newNode = BinaryTree(value: value)
        // Recursively invert the subtrees and assign them in swapped positions
        newNode.left = right?.inverted()
        newNode.right = left?.inverted()
        // Parent pointers are set via didSet in the BinaryTree class
        return newNode
    }
}
