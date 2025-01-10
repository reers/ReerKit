# ReerKit
ReerKit is a collection of native Swift extensions that provide convenient methods, syntactic sugar, and performance improvements for various native data types, UIKit, and Cocoa classes for iOS, macOS, tvOS, watchOS, and Linux platforms.
Some of the source code is gathered from various sources on the internet for utility classes or extension methods, with some code optimization and bug fixes. The remaining content is developed by myself. All system type extensions in the framework have the `re` infix added to avoid ambiguity issues when calling the same name extension, such as `"SGVsbG\n8gV29ybGQh".re.base64Decoded`, `"123".re.md5String`.

[简体中文](README_CN.md)

## Requirements
iOS 12.0+ / tvOS 12.0+ / watchOS 4.0+ / macOS 10.13+ / visionOS 1.0+ / Ubuntu 14.04+
Swift 5.9+
XCode 15.2+

## Installation

<details>
<summary>CocoaPods</summary>
</br>
<p>To integrate ReerKit into your Xcode project using <a href="http://cocoapods.org">CocoaPods</a>, specify it in your `Podfile`:</p>
<h4>- Integrate all extensions (recommended):</h4>
<pre><code class="ruby language-ruby">pod 'ReerKit'</code></pre>
</code></pre>
</details>

<details>
<summary>Carthage</summary>
</br>
<p>To integrate ReerKit into your Xcode project using <a href="https://github.com/Carthage/Carthage">Carthage</a>, specify it in your `Cartfile`:</p>
<pre><code class="ogdl language-ogdl">github "ReerKit/ReerKit" ~> 1.0.41
</code></pre>
</details>

<details>
<summary>Swift Package Manager</summary>
</br>
<p>You can use <a href="https://swift.org/package-manager">Swift Package Manager</a> to install ReerKit by adding the proper description in your `Package.swift` file:</p>
<pre><code class="swift language-swift">import PackageDescription
let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/reers/ReerKit.git", from: "1.0.41")
    ]
)
</code></pre>
<p>Next, add `ReerKit` to your targets dependencies as shown below:</p>
<pre><code class="swift language-swift">.target(
    name: "YOUR_TARGET_NAME",
    dependencies: [
        "ReerKit",
    ]
),</code></pre>
<p>Then run `swift package update`.</p>
<p>Please note that <a href="https://swift.org/package-manager">Swift Package Manager</a> does not support building for iOS/tvOS/macOS/watchOS applications.</p>
</details>

<details>
<summary>Manual</summary>
</br>
<p>Add the <a href="https://github.com/reers/ReerKit/tree/main/Sources">ReerKit</a> folder to your Xcode project to use all extensions or specific extensions.</p>
</details>

## Usage
### SwiftStdlib Extensions

<details>
<summary>
<a href="https://github.com/reers/ReerKit/blob/main/Sources/StandardLibrary/Array%2BREExtensions.swift"><code>Array extensions</code></a>
</summary>
    
<table>
    
```swift
/// ReerKit: Insert an element at the beginning of array.
///
///     var array = [2, 3, 4, 5]
///     array.re.prepend(1) -> [1, 2, 3, 4, 5]
///
/// - Parameter newElement: element to insert.
public mutating func prepend(_ newElement: T)

/// ReerKit: Safely swap values at given index positions.
///
///     var array = [1, 2, 3, 4, 5]
///     array.re.swapAt(3, 0) -> [4, 2, 3, 1, 5]
///     array.re.swapAt(3, 10) -> [1, 2, 3, 4, 5]
///
/// - Parameters:
///   - index: index of first element.
///   - otherIndex: index of other element.
public mutating func swapAt(_ index: Base.Index, _ otherIndex: Base.Index)

/// ReerKit: Remove all instances of an item from array.
///
///        [1, 2, 2, 3, 4, 5].re.removeAll(2) -> [1, 3, 4, 5]
///        ["h", "e", "l", "l", "o"].re.removeAll("l") -> ["h", "e", "o"]
///
/// - Parameter item: item to remove.
/// - Returns: self after removing all instances of item.
@discardableResult
public mutating func removeAll(_ item: T) -> [T]

/// ReerKit: Remove all instances contained in items parameter from array.
///
///        [1, 2, 2, 3, 4, 5].re.removeAll([2,5]) -> [1, 3, 4]
///        ["h", "e", "l", "l", "o"].re.removeAll(["l", "h"]) -> ["e", "o"]
///
/// - Parameter items: items to remove.
/// - Returns: self after removing all instances of all items in given array.
@discardableResult
public mutating func removeAll(_ items: [T]) -> [T]

/// ReerKit: Remove all duplicate elements from Array.
///
///        [1, 2, 2, 3, 4, 5].re.removeDuplicates() -> [1, 2, 3, 4, 5]
///        ["h", "e", "l", "l", "o"].re.removeDuplicates() -> ["h", "e", "l", "o"]
///
/// - Returns: Return array with all duplicate elements removed.
@discardableResult
public mutating func removeDuplicates() -> [T]

/// ReerKit: Removing all duplicate elements from Array.
///
///        [1, 2, 2, 3, 4, 5].re.removingDuplicates() -> [1, 2, 3, 4, 5]
///        ["h", "e", "l", "l", "o"].re.removingDuplicates() -> ["h", "e", "l", "o"]
///
/// - Returns: Return array with all duplicate elements removed.
public func removingDuplicates() -> [T]

/// ReerKit: Returns an array with all duplicate elements removed using KeyPath to compare.
///
/// - Parameter path: Key path to compare, the value must be Equatable.
/// - Returns: an array of unique elements.
public func removingDuplicates<U>(byKeyPath path: KeyPath<T, U>) -> [T] where U : Equatable

/// ReerKit: Returns an array with all duplicate elements removed using KeyPath to compare.
///
/// - Parameter path: Key path to compare, the value must be Hashable.
/// - Returns: an array of unique elements.
public func removingDuplicates<U>(byKeyPath path: KeyPath<T, U>) -> [T] where U : Hashable

/// ReerKit: JSON Data from array.
///
/// - Parameter prettify: set true to prettify data (default is false).
/// - Returns: optional JSON Data (if applicable).
public func jsonData(prettify: Bool = false) -> Data?

/// ReerKit: JSON String from array.
///
///        array.re.jsonString() -> "[{\"abc\":123}]"
///
/// - Parameter prettify: set true to prettify string (default is false).
/// - Returns: optional JSON String (if applicable).
public func jsonString(prettify: Bool = false) -> String?
```

</table>

</details>

