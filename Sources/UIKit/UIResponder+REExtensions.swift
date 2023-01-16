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

#if canImport(UIKit)
import UIKit

public typealias ResponderEventAction = (_ userInfo: [AnyHashable: Any]?, _ toNext: inout Bool) -> Void

/// ReerKit: Event name.
///
///     extension ResponderEventName {
///         static let testButtonClicked: ResponderEventName = "XXTestButtonClicked"
///     }
public struct ResponderEventName: ExpressibleByStringLiteral, Hashable, RawRepresentable {
    
    public typealias StringLiteralType = String
    
    public private(set) var rawValue: String
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public static func == (lhs: ResponderEventName, rhs: ResponderEventName) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

public extension Reer where Base: UIResponder {
    
    private var events: [ResponderEventName: ResponderEventAction] {
        get {
            base.re.associatedValue(forKey: AssociationKey(#function as StaticString), default: [:])
        }
        set {
            base.re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString))
        }
    }
    
    /// ReerKit: Throw a responder event in a responder.
    /// - Parameters:
    ///   - eventName: A customize event name.
    ///   - userInfo: The user info for the event.
    func post(_ eventName: ResponderEventName, userInfo: [AnyHashable: Any]? = nil) {
        post(eventName, sourceResponder: base, userInfo: userInfo)
    }
    
    private func post(_ eventName: ResponderEventName, sourceResponder: UIResponder, userInfo: [AnyHashable: Any]? = nil) {
        if eventName.rawValue.isEmpty {
            assertionFailure("Event name should not be empty.")
            return
        }
        if base === sourceResponder {
            base.next?.re.post(eventName, sourceResponder: sourceResponder, userInfo: userInfo)
            return
        }
        guard let action = events[eventName] else {
            base.next?.re.post(eventName, sourceResponder: sourceResponder, userInfo: userInfo)
            return
        }
        var toNext = false
        action(userInfo, &toNext)
        if toNext {
            base.next?.re.post(eventName, sourceResponder: sourceResponder, userInfo: userInfo)
        }
    }
    
    /// ReerKit: Obeserve a responder event in some next responder.
    /// - Parameters:
    ///   - eventName: A customize event name.
    ///   - action: Action will be execute when receive the event.
    mutating func observeResponderEvent(_ eventName: ResponderEventName, action: @escaping ResponderEventAction) {
        if eventName.rawValue.isEmpty {
            assertionFailure("Event name should not be empty.")
            return
        }
        events[eventName] = action
    }
    
    /// ReerKit: Unobserve a responder event.
    /// - Parameter eventName: The customize event name.
    mutating func unobserveResponderEvent(_ eventName: ResponderEventName) {
        events[eventName] = nil
    }
}
#endif
