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

#if canImport(UIKit)
import UIKit

#if os(iOS) || os(tvOS)

public extension UIApplication {
    /// ReerKit: Application running environment.
    ///
    /// - debug: Application is running in debug mode.
    /// - testFlight: Application is installed from Test Flight.
    /// - appStore: Application is installed from the App Store.
    enum Environment {
        /// ReerKit: Application is running in debug mode.
        case debug
        /// ReerKit: Application is installed from Test Flight.
        case testFlight
        /// ReerKit: Application is installed from the App Store.
        case appStore
    }
}

// MARK: - App info

public extension Reer where Base: UIApplication {
    
    /// ReerKit: Current inferred app environment.
    static var inferredEnvironment: UIApplication.Environment {
        #if DEBUG
        return .debug

        #elseif targetEnvironment(simulator)
        return .debug

        #else
        if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        }

        guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
            return .debug
        }

        if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
            return .testFlight
        }

        if appStoreReceiptUrl.path.lowercased().contains("simulator") {
            return .debug
        }

        return .appStore
        #endif
    }

    /// ReerKit: Return the main bundle's `CFBundleDisplayName` or `CFBundleName`.
    static var name: String {
        if let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return displayName
        } else if let name = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return name
        }
        return ""
    }
    
    /// ReerKit: Return the main bundle's bundle identifier.
    static var bundleID: String {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }

    /// ReerKit: App current build number.
    static var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }

    /// ReerKit: App's current version number.
    static var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// ReerKit: App's scheme list.
    static var schemes: [String] {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let urlTypes = infoDictionary["CFBundleURLTypes"] as? [AnyObject],
              let urlType = urlTypes.first as? [String : AnyObject],
              let urlSchemes = urlType["CFBundleURLSchemes"] as? [String]
        else { return [] }
        return urlSchemes
    }
}

// MARK: - UI

public extension Reer where Base: UIApplication {
    /// ReerKit: App's key window.
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// ReerKit: The app's visible and hidden windows.
    static var windows: [UIWindow] {
        if #available(iOS 15.0, tvOS 13.0, *) {
            var windows: [UIWindow] = []
            for windowScene in UIApplication.shared.connectedScenes {
                if let scene = windowScene as? UIWindowScene {
                    windows += scene.windows
                }
            }
            return windows
        } else {
            return UIApplication.shared.windows
        }
    }
    
    /// ReerKit: App's top most view controller.
    static var topViewController: UIViewController? {
        guard let rootViewController = keyWindow?.rootViewController else { return nil }
        return topViewController(of: rootViewController)
    }
    
    /// ReerKit: App's top most navigation controller.
    static var topNavigationController: UINavigationController? {
        return topViewController?.navigationController
    }
    
    /// ReerKit: A view controller's top most view controller.
    static func topViewController(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topViewController(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
           pageViewController.viewControllers?.count == 1 {
            return self.topViewController(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topViewController(of: childViewController)
            }
        }
        
        return viewController
    }
}

// MARK: - Sandbox path

public extension Reer where Base: UIApplication {
    
    /// ReerKit: "Documents" URL in this app's sandbox.
    var documentsURL: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    
    /// ReerKit: "Documents" path in this app's sandbox.
    var documentsPath: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    /// ReerKit: "Caches" URL in this app's sandbox.
    var cachesURL: URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
    }
    
    /// ReerKit: "Caches" path in this app's sandbox.
    var cachesPath: String? {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }
    
    /// ReerKit: "Library" URL in this app's sandbox.
    var libraryURL: URL? {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last
    }
    
    /// ReerKit: "Library" path in this app's sandbox.
    var libraryPath: String? {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    }
}

#endif

#endif
