[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/reers/ReerKit)

# ReerKit
ReerKit 是许多个原生 Swift 扩展的集合，为 iOS、macOS、tvOS、watchOS, visionOS 和 Linux 提供了适用于各种原生数据类型、UIKit 和 Cocoa 类的便捷方法、语法糖和性能改进。
框架中所有的系统类型 extension 都添加了 `re` 中缀, 避免了同名扩展调用时的歧义问题, 如 
```swift
SGVsbG\n8gV29ybGQh".re.base64Decoded

"123".re.md5String

view.re.addSwiftUIView(Color.red)
```

框架中还包含许多其他丰富便捷的功能
```swift
// 用 dynamic member lookup 实现通过点语法访问字典内容
let dict: [String: Any] = ...
dict.dml.user_name.re.string <=> dict["user_name"] as? String

// 弱引用容器, 元素销毁时自动移出容器
WeakSet, WeakMap

// 设置 UIView 灰度模式
view.re.isGrayModeEnabled = true

// 数据结构封装
BinaryTree, Tree, LinkedList, Queue, BoundedQueue, Stack, OrderedSet, OrderDictionary

// 各种锁的封装
MutexLock, ReadWriteLock, Synchronizing, UnfaireLock

// 属性包装器 PropertyWrappers 
Clamped, Locked, Rounded, RWLocked, Trimmed

// 属性宏, 自动生成关联对象或 UserDefaults get/set 访问器
@AssociatedValue(default: false) var isAppeared: Bool
@Defaults("isAppeared") var isAppeared: Bool

// 其他工具类
RSA, AES, CountdownTimer, Debouncer, Throttler, DeinitObserver, KeyboardManager, Keychain, Reachability, NanoID, MulticastDelegate

// 还有为标准库, UIKit, Foudation 等框架提供了大量扩展方法和属性
String+REExtensions
UIView+REExtensions
Array+REExtensions
Date+REExtensions
....
```

## 使用文档
[DocC 生成的文档链接](https://swiftpackageindex.com/reers/ReerKit/1.2.7/documentation/reerkit)

[或者点击这里下载 doccarchive 文件](https://gitee.com/phoenix19/cdn/raw/master/ReerKit.doccarchive.zip)

## 要求
iOS 13.0+

macOS 10.15+

tvOS 13.0+

watchOS 4.0+

visionOS 1.0+

Ubuntu 14.04+

Swift 5.9+

XCode 15.4+

## 安装

<details>
<summary>Carthage</summary>
</br>
<p>要使用 <a href="https://github.com/Carthage/Carthage">Carthage</a> 将 ReerKit 集成到您的 Xcode 项目中，请在您的 <code>Cartfile</code> 中设置:</p>
<pre><code class="ogdl language-ogdl">github "ReerKit/ReerKit" ~&gt; 1.2.7
</code></pre>
</details>

<details>
<summary>Swift Package Manager</summary>
</br>
<p>你可以使用 <a href="https://swift.org/package-manager">The Swift Package Manager</a> 来安装 ReerKit，请在你的 <code>Package.swift</code> 文件中添加正确的描述:</p>
<pre><code class="swift language-swift">import PackageDescription
let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/reers/ReerKit.git", from: "1.2.7")
    ]
)
</code></pre>
<p>接下来，将 <code>ReerKit</code> 添加到您的 targets 依赖项中，如下所示:</p>
<pre><code class="swift language-swift">.target(
    name: "YOUR_TARGET_NAME",
    dependencies: [
        "ReerKit",
    ]
),</code></pre>
<p>然后运行 <code>swift package update</code>。</p>
<p>属性宏需要通过 Swift Package Manager 构建使用。旧的 Xcode project 不会加载 <code>ReerKitMacros</code> 插件。</p>
<pre><code class="swift language-swift">@Defaults("isAppeared")
var isAppeared: Bool

@Defaults("launchCount", 0, container: .standard)
var launchCount: Int

@AssociatedValue
var isAppeared: Bool</code></pre>
<p>省略默认值时，支持的基础类型会使用内置默认值，例如 <code>false</code>、<code>0</code>、<code>""</code>、<code>Date()</code>、<code>Data()</code>、<code>URL(string: "/")!</code>、<code>UUID()</code> 和 <code>Decimal(0)</code>。</p>
<p><code>@Defaults</code> 也支持类型（<code>static</code>/<code>class</code>）属性。</p>
</details>

<details>
<summary>手动</summary>
</br>
<p>将 <a href="https://github.com/reers/ReerKit/tree/main/Sources">ReerKit</a> 文件夹添加到您的 Xcode 项目以使用所有扩展或特定扩展。</p>
</details>
