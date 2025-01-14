//
//  Copyright © 2015 ibireme
//  Copyright © 2014-2018 Alamofire Software Foundation (http://alamofire.org/)
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

#if !(os(watchOS) || os(Linux) || os(Windows))

import Foundation
import SystemConfiguration
import Dispatch

/// The ``Reachability`` class listens for reachability changes of hosts and addresses for both cellular and
/// WiFi network interfaces.
///
/// Reachability can be used to determine background information about why a network operation failed, or to retry
/// network requests when a connection is established. It should not be used to prevent a user from initiating a network
/// request, as it's possible that an initial request may be required to establish reachability.
open class Reachability {
    /// Defines the various states of network reachability.
    public enum Status {
        /// It is unknown whether the network is reachable.
        case unknown
        /// The network is not reachable.
        case none
        /// The network is reachable on the associated `ConnectionType`.
        case reachable(ConnectionType)
        
        init(_ flags: SCNetworkReachabilityFlags) {
            guard flags.isActuallyReachable else {
                self = .none
                return
            }

            var networkStatus: Status = .reachable(.ethernetOrWiFi)

            if flags.isCellular { networkStatus = .reachable(.cellular) }

            self = networkStatus
        }
    }
    
    /// Defines the various connection types detected by reachability flags.
    public enum ConnectionType {
        /// The connection type is either over Ethernet or WiFi.
        case ethernetOrWiFi
        /// The connection type is a cellular connection.
        case cellular
    }
    
    /// A closure executed when the network reachability status changes. The closure takes a single argument: the
    /// network reachability status.
    public typealias OnChangedCallback = (Status) -> Void
    
    /// Default ``Reachability`` for the zero address and a `callbackQueue` of `.main`.
    public static let `default` = Reachability()
    
    /// Whether the network is currently reachable.
    open var isReachable: Bool { isReachableOnCellular || isReachableOnEthernetOrWiFi }
    
    /// Whether the network is currently reachable over the cellular interface.
    ///
    /// - Note: Using this property to decide whether to make a high or low bandwidth request is not recommended.
    ///         Instead, set the `allowsCellularAccess` on any `URLRequest`s being issued.
    ///
    open var isReachableOnCellular: Bool { status == .reachable(.cellular) }

    /// Whether the network is currently reachable over Ethernet or WiFi interface.
    open var isReachableOnEthernetOrWiFi: Bool { status == .reachable(.ethernetOrWiFi) }
    
    /// `DispatchQueue` on which reachability will update.
    public let reachabilityQueue = DispatchQueue(label: "org.reers.reerkit.reachability")
   
    /// Flags of the current reachability type, if any.
    open var flags: SCNetworkReachabilityFlags? {
        var flags = SCNetworkReachabilityFlags()
        return SCNetworkReachabilityGetFlags(reachability, &flags) ? flags : nil
    }
    
    /// The current network reachability status.
    open var status: Status {
        return flags.map(Status.init) ?? .unknown
    }
    
    /// Mutable state storage.
    struct MutableState {
        /// A closure executed when the network reachability status changes.
        var callback: OnChangedCallback?
        /// `DispatchQueue` on which listeners will be called.
        var callbackQueue: DispatchQueue?
        /// Previously calculated status.
        var previousStatus: Status?
    }
    
    /// Locked storage for mutable state.
    @Locked
    private var mutableState = MutableState()
    
    /// `SCNetworkReachability` instance providing notifications.
    private let reachability: SCNetworkReachability
    
    // MARK: - Initialization
    
    private init(reachability: SCNetworkReachability) {
        self.reachability = reachability
    }

    /// Creates an instance with the specified host.
    ///
    /// - Note: The `host` value must *not* contain a scheme, just the hostname.
    ///
    /// - Parameters:
    ///   - host:          Host used to evaluate network reachability. Must *not* include the scheme (e.g. `https`).
    public convenience init?(host: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return nil }
        self.init(reachability: reachability)
    }
    
    /// Creates an instance that monitors the address 0.0.0.0.
    ///
    /// Reachability treats the 0.0.0.0 address as a special token that causes it to monitor the general routing
    /// status of the device, both IPv4 and IPv6.
    public convenience init?() {
        var zero = sockaddr_in()
        zero.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zero.sin_family = sa_family_t(AF_INET)
        
        var addr = sockaddr()
        withUnsafeMutablePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { ptr in
                ptr.pointee = zero
            }
        }
        
        guard let reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, &addr) else { return nil }
        self.init(reachability: reachability)
    }
    
    deinit {
        stopListening()
    }
    
    /// Starts listening for changes in network reachability status.
    ///
    /// - Note: Stops and removes any existing listener.
    ///
    /// - Parameters:
    ///   - queue:    `DispatchQueue` on which to call the `callback` closure. `.main` by default.
    ///   - callback: `OnChangedCallback` closure called when reachability changes.
    ///
    /// - Returns: `true` if listening was started successfully, `false` otherwise.
    @discardableResult
    open func startListening(onQueue queue: DispatchQueue = .main, onChanged callback: @escaping OnChangedCallback) -> Bool {
        stopListening()
        
        $mutableState.write { state in
            state.callbackQueue = queue
            state.callback = callback
        }
        
        let weakSelf = Weak(self)
        var context = SCNetworkReachabilityContext(
            version: 0,
            info: Unmanaged.passUnretained(weakSelf).toOpaque(),
            retain: { info in
                let unmanaged = Unmanaged<Weak<Reachability>>.fromOpaque(info)
                _ = unmanaged.retain()
                return UnsafeRawPointer(unmanaged.toOpaque())
            },
            release: { info in
                let unmanaged = Unmanaged<Weak<Reachability>>.fromOpaque(info)
                unmanaged.release()
            },
            copyDescription: { info in
                let unmanaged = Unmanaged<Weak<Reachability>>.fromOpaque(info)
                let weakSelf = unmanaged.takeUnretainedValue()
                let description = weakSelf.object?.flags?.readableDescription ?? "nil"
                return Unmanaged.passRetained(description as CFString)
            }
        )
        let callback: SCNetworkReachabilityCallBack = { _, flags, info in
            guard let info = info else { return }

            let weakSelf = Unmanaged<Weak<Reachability>>.fromOpaque(info).takeUnretainedValue()
            weakSelf.object?.notifyWhenChanged(flags)
        }
        let queueAdded = SCNetworkReachabilitySetDispatchQueue(reachability, reachabilityQueue)
        let callbackAdded = SCNetworkReachabilitySetCallback(reachability, callback, &context)

        // Manually call listener to give initial state, since the framework may not.
        if let currentFlags = flags {
            reachabilityQueue.async {
                self.notifyWhenChanged(currentFlags)
            }
        }

        return callbackAdded && queueAdded
    }
    
    /// Stops listening for changes in network reachability status.
    open func stopListening() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        $mutableState.write { state in
            state.callback = nil
            state.callbackQueue = nil
            state.previousStatus = nil
        }
    }
    
    // MARK: - Internal

    /// Calls the `callback` closure of the `callbackQueue` if the computed status hasn't changed.
    ///
    /// - Note: Should only be called from the `reachabilityQueue`.
    ///
    /// - Parameter flags: `SCNetworkReachabilityFlags` to use to calculate the status.
    func notifyWhenChanged(_ flags: SCNetworkReachabilityFlags) {
        let newStatus = Status(flags)
        
        $mutableState.write { state in
            guard state.previousStatus != newStatus else { return }

            state.previousStatus = newStatus

            let callback = state.callback
            state.callbackQueue?.async { callback?(newStatus) }
        }
    }
}


extension Reachability.Status: Equatable {}

extension SCNetworkReachabilityFlags {
    var isReachable: Bool { contains(.reachable) }
    var isConnectionRequired: Bool { contains(.connectionRequired) }
    var canConnectAutomatically: Bool { contains(.connectionOnDemand) || contains(.connectionOnTraffic) }
    var canConnectWithoutUserInteraction: Bool { canConnectAutomatically && !contains(.interventionRequired) }
    var isActuallyReachable: Bool { isReachable && (!isConnectionRequired || canConnectWithoutUserInteraction) }
    var isCellular: Bool {
        #if os(iOS) || os(tvOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }

    /// Human readable `String` for all states, to help with debugging.
    var readableDescription: String {
        let W = isCellular ? "W" : "-"
        let R = isReachable ? "R" : "-"
        let c = isConnectionRequired ? "c" : "-"
        let t = contains(.transientConnection) ? "t" : "-"
        let i = contains(.interventionRequired) ? "i" : "-"
        let C = contains(.connectionOnTraffic) ? "C" : "-"
        let D = contains(.connectionOnDemand) ? "D" : "-"
        let l = contains(.isLocalAddress) ? "l" : "-"
        let d = contains(.isDirect) ? "d" : "-"
        let a = contains(.connectionAutomatic) ? "a" : "-"

        return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)\(a)"
    }
}

#endif
