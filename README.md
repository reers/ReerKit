# ReerKit
ReerKit is a collection of native Swift extensions that provide convenient methods, syntactic sugar, and performance improvements for various native data types, UIKit, and Cocoa classes for iOS, macOS, tvOS, watchOS, and Linux platforms.
Around 60% of the content in the framework comes from the excellent open-source library [SwifterSwift](https://github.com/SwifterSwift/SwifterSwift), with some code removal, optimization, and bug fixes. Another 10% of the content is gathered from various sources on the internet for utility classes or extension methods. The remaining content is developed by myself. All system type extensions in the framework have the `re` infix added to avoid ambiguity issues when calling the same name extension, such as `"SGVsbG\n8gV29ybGQh".re.base64Decoded`, `"123".re.md5String`.

[简体中文](README_CN.md)

## Requirements
iOS 11.0+ / tvOS 9.0+ / watchOS 2.0+ / macOS 10.10+ / Ubuntu 14.04+
Swift 5.5+

## Package Size
224KB

## Code coverage
75%

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
<pre><code class="ogdl language-ogdl">github "ReerKit/ReerKit" ~> 1.0.23
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
        .package(url: "https://github.com/reers/ReerKit.git", from: "1.0.23")
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
