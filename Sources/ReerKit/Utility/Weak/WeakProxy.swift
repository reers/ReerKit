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

#if canImport(Foundation) && !os(Linux)
import Foundation

/// A proxy used to hold a weak object.
/// It can be used to avoid retain cycles, such as the target in Timer or CADisplayLink.
public class WeakProxy: NSObject {
    
    /// The proxy target.
    public weak var target: NSObject?
    
    /// Creates a new weak proxy for target.
    public init(target: NSObject) {
        super.init()
        self.target = target
    }
    
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        return target?.isEqual(object) ?? false
    }
    
    public override var hash: Int {
        return target?.hash ?? 0
    }
    
    public override var superclass: AnyClass? {
        return target?.superclass
    }
    
    public override func isProxy() -> Bool {
        return true
    }
    
    public override func isKind(of aClass: AnyClass) -> Bool {
        return target?.isKind(of: aClass) ?? false
    }
    
    public override func isMember(of aClass: AnyClass) -> Bool {
        return target?.isMember(of: aClass) ?? false
    }
    
    public override func conforms(to aProtocol: Protocol) -> Bool {
        return target?.conforms(to: aProtocol) ?? false
    }
    
    public override var description: String {
        return target?.description ?? ""
    }
    
    public override var debugDescription: String {
        return target?.debugDescription ?? ""
    }
}
#endif
