//
//  Copyright © 2015 ibireme
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

#if canImport(UIKit) && canImport(ObjectiveC) && !os(watchOS)
import UIKit
import ObjectiveC

public extension Reer where Base: UIControl {
    
    /// ReerKit: Removes all targets and actions for a particular event (or events)
    /// from an internal dispatch table.
    func removeAllTargets() {
        for object in base.allTargets {
            base.removeTarget(object, action: nil, for: UIControl.Event.allEvents)
        }
        var targets = allTargetsAction
        targets.removeAll()
        base.re.allTargetsAction = targets
    }
    
    /// ReerKit: Adds a action for a particular event (or events) to an internal dispatch table.
    /// It will cause a strong reference to @a action.
    ///
    /// - Parameters:
    ///   - events: A bitmask specifying the control events for which the
    ///            action message is sent.
    ///   - action: The action which is invoked then the action message is
    ///             sent  (cannot be nil). The action is retained.
    func addAction(forControlEvents events: UIControl.Event, action: @escaping (UIControl) -> Void) {
        let target = UIControlActionTarget(action: action, events: events)
        base.addTarget(target, action: #selector(target.invoke(with:)), for: events)
        var targets = allTargetsAction
        targets.append(target)
        base.re.allTargetsAction = targets
    }
    
    /// ReerKit: Adds or replaces a action for a particular event (or events) to an internal
    /// dispatch table. It will cause a strong reference to @a action.
    ///
    /// - Parameters:
    ///   - events: A bitmask specifying the control events for which the
    ///             action message is sent.
    ///   - action: The action which is invoked then the action message is
    ///            sent (cannot be nil). The action is retained.
    func setAction(forControlEvents events: UIControl.Event, action: @escaping (UIControl) -> Void) {
        removeAllActions(forControlEvents: UIControl.Event.allEvents)
        addAction(forControlEvents: events, action: action)
    }
    
    /// ReerKit: Removes all actions for a particular event (or events) from an internal
    /// dispatch table.
    ///
    /// - Parameter events: A bitmask specifying the control events for which the
    ///                     action message is sent.
    func removeAllActions(forControlEvents events: UIControl.Event) {
        var targets = base.re.allTargetsAction
        for target in targets {
            var targetEventsRawValue = target.events.rawValue
            
            for event in events.re.elements() {
                if target.events.re.elements().contains(event) {
                    base.removeTarget(target, action: #selector(target.invoke(with:)), for: event)
                    targetEventsRawValue -= event.rawValue
                }
                
            }
            if targetEventsRawValue == 0 {
                if let index = targets.firstIndex(where: { $0 == target }) {
                    targets.remove(at: index)
                }
            }
        }
        base.re.allTargetsAction = targets
    }
    
    /// ReerKit: Adds or replaces a target and action for a particular event (or events)
    /// to an internal dispatch table.
    ///
    /// - Parameters:
    ///   - target: The target object—that is, the object to which the
    ///             action message is sent. If this is nil, the responder
    ///             chain is searched for an object willing to respond to the
    ///             action message.
    ///   - action: A selector identifying an action message.
    ///   - events: A bitmask specifying the control events for which the
    ///             action message is sent.
    func setTarget(_ target: Any?, action: Selector, forControlEvents events: UIControl.Event) {
        guard let target = target else { return }
        let targets = base.allTargets
        for currentTarget in targets {
            guard let actions = base.actions(forTarget: currentTarget, forControlEvent: events) else {
                return
            }
            for currentAction in actions {
                base.removeTarget(currentTarget, action: NSSelectorFromString(currentAction), for: events)
            }
        }
        base.addTarget(target, action: action, for: events)
    }
    
    private var allTargetsAction: [UIControlActionTarget] {
        get {
            base.re.associatedValue(forKey: AssociationKey(#function as StaticString), default: [])
        }
        set {
            base.re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString))
        }
    }
}

private class UIControlActionTarget: NSObject {
    
    var action: (UIControl) -> Void
    var events: UIControl.Event
    
    public init(action: @escaping (UIControl) -> Void, events: UIControl.Event) {
        self.action = action
        self.events = events
    }
    
    @objc
    func invoke(with sender: UIControl) {
        self.action(sender)
    }
    
}
#endif
