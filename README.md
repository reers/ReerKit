# ReerKit
ReerKit is a collection of native Swift extensions that provide convenient methods, syntactic sugar, and performance improvements for various native data types, UIKit, and Cocoa classes for iOS, macOS, tvOS, watchOS, and Linux platforms.
Around 60% of the content in the framework comes from the excellent open-source library [SwifterSwift](https://github.com/SwifterSwift/SwifterSwift), with some code removal, optimization, and bug fixes. Another 10% of the content is gathered from various sources on the internet for utility classes or extension methods. The remaining content is developed by myself. All system type extensions in the framework have the `re` infix added to avoid ambiguity issues when calling the same name extension, such as `"SGVsbG\n8gV29ybGQh".re.base64Decoded`.

## Requirements
iOS 11.0+ / tvOS 9.0+ / watchOS 2.0+ / macOS 10.10+ / Ubuntu 14.04+
Swift 5.5+

## Installation

<details>
<summary>CocoaPods</summary>
</br>
<p>To integrate ReerKit into your Xcode project using [CocoaPods](http://cocoapods.org), specify it in your `Podfile`:</p>
<h4>- Integrate all extensions (recommended):</h4>
<pre><code class="ruby language-ruby">pod 'ReerKit'</code></pre>
<h4>- Alternatively, you can only integrate the subspecs you need:</h4>
<pre><code class="ruby language-ruby">pod 'ReerKit/StandardLibrary'
pod 'ReerKit/Foundation'
</code></pre>
</details>

<details>
<summary>Carthage</summary>
</br>
<p>To integrate ReerKit into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:</p>
<pre><code class="ogdl language-ogdl">github "ReerKit/ReerKit" ~> 1.0
</code></pre>
</details>

<details>
<summary>Swift Package Manager</summary>
</br>
<p>You can use [The Swift Package Manager](https://swift.org/package-manager) to install ReerKit by adding the proper description in your `Package.swift` file:</p>
<pre><code class="swift language-swift">import PackageDescription
let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/reers/ReerKit.git", from: "1.0.0")
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
<p>Please note that [Swift Package Manager](https://swift.org/package-manager) does not support building for iOS/tvOS/macOS/watchOS applications.</p>
</details>

<details>
<summary>Manual</summary>
</br>
<p>Add the `ReerKit` folder to your Xcode project to use all extensions or specific extensions.</p>
</details>
