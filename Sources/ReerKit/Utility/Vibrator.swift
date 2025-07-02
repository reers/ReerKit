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

#if canImport(UIKit) && os(iOS)
import UIKit

public struct Vibrator {
    
    public enum FeedbackStyle: Int {
        case light
        case medium
        case heavy
        case soft
        case rigid
        
        case selectionChanged
        
        case success
        case warning
        case error
        
        var impactStyle: UIImpactFeedbackGenerator.FeedbackStyle {
            switch self {
            case .light: return .light
            case .medium: return .medium
            case .heavy: return .heavy
            case .soft:
                if #available(iOS 13.0, *) {
                    return .soft
                } else {
                    return .light
                }
            case .rigid:
                if #available(iOS 13.0, *) {
                    return .rigid
                } else {
                    return .medium
                }
            default: return .light
            }
        }
        
        var notificationType: UINotificationFeedbackGenerator.FeedbackType {
            switch self {
            case .success: return .success
            case .warning: return .warning
            case .error: return .error
            default: return .success
            }
        }
    }
    
    public static func occur(_ style: FeedbackStyle, intensity: CGFloat = 1.0) {
        switch style {
        case .light, .medium, .heavy, .soft, .rigid:
            if impactFeedbackGenerator == nil {
                impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style.impactStyle)
            }
            if #available(iOS 13.0, *) {
                impactFeedbackGenerator?.impactOccurred(intensity: intensity)
            } else {
                impactFeedbackGenerator?.impactOccurred()
            }
        case .selectionChanged:
            selectionFeedbackGenerator?.selectionChanged()
        case .success, .warning, .error:
            notificationFeedbackGenerator?.notificationOccurred(style.notificationType)
        }
        delayReleaseGenerator()
    }
    
    public static func prepare(_ style: FeedbackStyle) {
        switch style {
        case .light, .medium, .heavy, .soft, .rigid:
            if impactFeedbackGenerator == nil {
                impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style.impactStyle)
            }
            impactFeedbackGenerator?.prepare()
        case .selectionChanged:
            selectionFeedbackGenerator?.prepare()
        case .success, .warning, .error:
            notificationFeedbackGenerator?.prepare()
        }
        delayReleaseGenerator()
    }
    
    public static func end() {
        impactFeedbackGenerator = nil
        selectionFeedbackGenerator = nil
        notificationFeedbackGenerator = nil
    }
    
    private static func delayReleaseGenerator() {
        debouncer.execute(interval: 2) {
            asyncOnMainQueue(end)
        }
    }
    
    private static var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    @LazyResettable(UISelectionFeedbackGenerator())
    private static var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    
    @LazyResettable(UINotificationFeedbackGenerator())
    private static var notificationFeedbackGenerator: UINotificationFeedbackGenerator?
    
    private static var debouncer = Debouncer(queue: .global(qos: .background))
}
#endif
