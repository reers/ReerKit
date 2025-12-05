[简体中文](README_CN.md)

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/reers/ReerKit)

# ReerKit
ReerKit is a collection of native Swift extensions that provide convenient methods, syntactic sugar, and performance improvements for various native data types, UIKit, and Cocoa classes for iOS, macOS, tvOS, watchOS, and Linux platforms.
All system type extensions in the framework have the `re` infix added to avoid ambiguity issues when calling the same name extension, such as 
```swift
SGVsbG\n8gV29ybGQh".re.base64Decoded

"123".re.md5String

view.re.addSwiftUIView(Color.red)
```

There are also a of other convenient features available.
```swift
// Access dictionary contents using dot notation implemented by dynamic member lookup
let dict: [String: Any] = ...
dict.dml.user_name.re.string <=> dict["user_name"] as? String

// Weak reference container, automatically removes elements when they are destroyed.
WeakSet, WeakMap

// Set grayscale mode for UIView
view.re.isGrayModeEnabled = true

// Data Structure Encapsulation
BinaryTree, Tree, LinkedList, Queue, BoundedQueue, Stack, OrderedSet, OrderDictionary

// Lock Encapsulation
MutexLock, ReadWriteLock, Synchronizing, UnfaireLock

// PropertyWrappers
Clamped, Locked, Rounded, RWLocked, Trimmed

// Other Utility
RSA, AES, CountdownTimer, Debouncer, Throttler, DeinitObserver, KeyboardManager, Keychain, Reachability, NanoID, MulticastDelegate

// Additionally, it provides a large number of extension methods and vars for frameworks such as the standard library, UIKit, and Foundation.
String+REExtensions
UIView+REExtensions
Array+REExtensions
Date+REExtensions
...
```

## Usage
[Link of Documents build by DocC](https://swiftpackageindex.com/reers/ReerKit/1.2.2/documentation/reerkit)

[Or click here to download the doccarchive file](https://gitee.com/phoenix19/cdn/raw/master/ReerKit.doccarchive.zip)

## Requirements
iOS 12.0+

macOS 10.13+

tvOS 12.0+

watchOS 4.0+

visionOS 1.0+

Ubuntu 14.04+

Swift 5.9+

XCode 15.4+

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
<pre><code class="ogdl language-ogdl">github "ReerKit/ReerKit" ~> 1.2.2
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
        .package(url: "https://github.com/reers/ReerKit.git", from: "1.2.2")
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
