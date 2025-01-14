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

#if canImport(Foundation)
import Foundation

public extension Reer where Base: NotificationCenter {
    /// ReerKit: Adds a one-time entry to the notification center's dispatch table that includes a notification queue and a block to add to the queue, and an optional notification name and sender.
    /// - Parameters:
    ///   - name: The name of the notification for which to register the observer; that is, only notifications with this name are used to add the block to the operation queue.
    ///
    ///     If you pass `nil`, the notification center doesn’t use a notification’s name to decide whether to add the block to the operation queue.
    ///   - obj: The object whose notifications the observer wants to receive; that is, only notifications sent by this sender are delivered to the observer.
    ///
    ///     If you pass `nil`, the notification center doesn’t use a notification’s sender to decide whether to deliver it to the observer.
    ///   - queue: The operation queue to which block should be added.
    ///
    ///     If you pass `nil`, the block is run synchronously on the posting thread.
    ///   - block: The block to be executed when the notification is received.
    ///
    ///     The block is copied by the notification center and (the copy) held until the observer registration is removed.
    ///
    ///     The block takes one argument:
    ///   
    func observeOnce(
        forName name: NSNotification.Name?,
        object obj: Any? = nil,
        queue: OperationQueue? = nil,
        using block: @escaping (_ notification: Notification) -> Void
    ) {
        var handler: (any NSObjectProtocol)!
        let removeObserver = { [unowned base] in
            base.removeObserver(handler!)
        }
        handler = base.addObserver(forName: name, object: obj, queue: queue) {
            removeObserver()
            block($0)
        }
    }
}

#endif
