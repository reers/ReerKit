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

#if canImport(ObjectiveC)
import ObjectiveC

fileprivate final class DeinitObserver<Object> where Object: AnyObject {
    
    private weak var object: Object?
    
    private let onDeinit: () -> Void
        
    deinit {
        onDeinit()
    }
    
    init(for object: Object, onDeinit: @escaping () -> Void) {
        self.object = object
        self.onDeinit = onDeinit
    }
    
    private var deinitObserveKey: Void?
    
    func observe() {
        guard let object = object else { return }
        objc_setAssociatedObject(
            object,
            &deinitObserveKey,
            self,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}

/// ReerKit: Global function to observe deinit for the object.
public func observeDeinit<Object: AnyObject>(for object: Object?, onDeinit: @escaping () -> Void) {
    guard let object = object else { return }
    DeinitObserver(for: object, onDeinit: onDeinit).observe()
}
#endif
