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

#if canImport(Darwin)
import Darwin
#endif

public extension Reer where Base: UIDevice {
    
    /// ReerKit: Whether the device is iPad/iPad mini.
    static var isPad: Bool {
        return UI_USER_INTERFACE_IDIOM() == .pad
    }
    
    /// ReerKit: Whether the device is a simulator.
    static var isSimulator: Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }
    
    /// ReerKit: Whether the device is jailbroken.
    static var isJailbroken: Bool {
        if self.isSimulator {
            return false
        }
        
        let paths = [
            "/Applications/Cydia.app",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/stash"
        ]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        let bash = fopen("/bin/bash", "r")
        if bash != nil {
            fclose(bash)
            return true
        }
        
        let path = "/private/" + String.re.random(ofLength: 21)
        do {
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try? FileManager.default.removeItem(atPath: path)
            return true
        } catch _ {
            
        }
        
        return false
    }
    
    /// YYSwift: Wherher the device can make phone calls.
    var canMakePhoneCalls: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "tel://")!)
    }

    #if canImport(Darwin)
    /// YYSwift: WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"
    var ipAddressWIFI: String? {
        return ipAddress(withIfaName: "en0")
    }
    
    /// YYSwift: Cell IP address of this device (can be nil). e.g. @"10.2.2.222"
    var ipAddressCell: String? {
        return ipAddress(withIfaName: "pdp_ip0")
    }
    #endif
    
    /// YYSwift: The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
    ///
    /// [reference](http://theiphonewiki.com/wiki/Models)
    var machineModel: String? {
        var machineSwiftString: String?
        var size: size_t = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        machineSwiftString = String(cString: machine, encoding: .utf8)
        return machineSwiftString
    }
    
    /// YYSwift: Total disk space in byte. (-1 when error occurs)
    var diskSpace: Int64 {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            var space = attrs[.systemSize] as! Int64
            if space < 0 {
                space = -1
            }
            return space
        } catch _ {
            return -1
        }
    }
    
    /// YYSwift: Free disk space in byte. (-1 when error occurs)
    var diskSpaceFree: Int64 {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            var space = attrs[.systemFreeSize] as! Int64
            if space < 0 {
                space = -1
            }
            return space
        } catch _ {
            return -1
        }
    }
    
    /// YYSwift: Used disk space in byte. (-1 when error occurs)
    var diskSpaceUsed: Int64 {
        let total = diskSpace
        let free = diskSpaceFree
        if total < 0 || free < 0 {
            return -1
        }
        var used = total - free
        if used < 0 {
            used = -1
        }
        return used
    }
    
    /// YYSwift: Total physical memory in byte. (-1 when error occurs)
    var memoryTotal: Int64 {
        let mem = ProcessInfo.processInfo.physicalMemory
        guard mem > 0 else {
            return -1
        }
        return Int64(mem)
    }
    
    #if canImport(Darwin)
    /// YYSwift: Used app memory and total memory
    ///
    /// [Reference](https://github.com/zixun/SystemEye/blob/master/SystemEye/Classes/Memory.swift)
    var appMemoryUsage: (used: Int64, total: Int64) {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
        let kerr = withUnsafeMutablePointer(to: &info) {
            return $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                return task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        guard kerr == KERN_SUCCESS else {
            return (0, self.memoryTotal)
        }
        
        return (Int64(info.resident_size), self.memoryTotal)
    }

    /// YYSwift: System memory usage
    var systemMemoryUsage: (
        free: Int64,
        active: Int64,
        inactive: Int64,
        wired: Int64,
        compressed: Int64,
        purgable: Int64,
        total: Int64
    ) {
        var statistics: vm_statistics64 {
            var size = HOST_VM_INFO64_COUNT
            var hostInfo = vm_statistics64()
            let result = withUnsafeMutablePointer(to: &hostInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                    host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &size)
                }
            }
            #if DEBUG
            if result != KERN_SUCCESS {
                print("ERROR - \(#file):\(#function) - kern_result_t = "
                      + "\(result)")
            }
            #endif
            return hostInfo
        }
        
        let free = Double(statistics.free_count) * PAGE_SIZE
        let active = Double(statistics.active_count) * PAGE_SIZE
        let inactive = Double(statistics.inactive_count) * PAGE_SIZE
        let wired = Double(statistics.wire_count) * PAGE_SIZE
        let compressed = Double(statistics.compressor_page_count) * PAGE_SIZE
        let purgable = Double(statistics.purgeable_count) * PAGE_SIZE
        return (
            Int64(free),
            Int64(active),
            Int64(inactive),
            Int64(wired),
            Int64(compressed),
            Int64(purgable),
            memoryTotal
        )
    }
    
    /// YYSwift: App CPU usage
    var appCPUUsage: Double {
        let threads = UIDevice.re.threadBasicInfos()
        var result : Double = 0.0
        threads.forEach { (thread: thread_basic_info) in
            if UIDevice.re.flag(thread) {
                result += Double.init(thread.cpu_usage) / Double.init(TH_USAGE_SCALE);
            }
        }
        return result * 100
    }
    
    /// YYSwift: System CPU usage
    var systemCPUUsage: (
        system: Double,
        user: Double,
        idle: Double,
        nice: Double
    ) {
        let load = UIDevice.re.hostCPULoadInfo
        
        let userDiff = Double(load.cpu_ticks.0 - UIDevice.loadPrevious.cpu_ticks.0)
        let sysDiff  = Double(load.cpu_ticks.1 - UIDevice.loadPrevious.cpu_ticks.1)
        let idleDiff = Double(load.cpu_ticks.2 - UIDevice.loadPrevious.cpu_ticks.2)
        let niceDiff = Double(load.cpu_ticks.3 - UIDevice.loadPrevious.cpu_ticks.3)
        
        let totalTicks = sysDiff + userDiff + niceDiff + idleDiff
        
        let sys  = sysDiff  / totalTicks * 100.0
        let user = userDiff / totalTicks * 100.0
        let idle = idleDiff / totalTicks * 100.0
        let nice = niceDiff / totalTicks * 100.0
        
        UIDevice.loadPrevious = load
        return (sys, user, idle, nice)
    }
    
    private static var hostCPULoadInfo: host_cpu_load_info {
        get {
            var size     = HOST_CPU_LOAD_INFO_COUNT
            var hostInfo = host_cpu_load_info()
            let result = withUnsafeMutablePointer(to: &hostInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                    host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
                }
            }
            
            #if DEBUG
            if result != KERN_SUCCESS {
                fatalError("ERROR - \(#file):\(#function) - kern_result_t = "
                    + "\(result)")
            }
            #endif
            
            return hostInfo
        }
    }
    #endif
}

extension Reer where Base: UIDevice {
    #if canImport(Darwin)
    // https://stackoverflow.com/questions/30748480/swift-get-devices-ip-address/30748582
    private func ipAddress(withIfaName ifaName: String) -> String? {
        if ifaName.count == 0 { return nil }
        var address: String?
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                let name = String(cString: interface.ifa_name)
                if name == ifaName {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(
                        interface.ifa_addr,
                        socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname,
                        socklen_t(hostname.count),
                        nil,
                        socklen_t(0),
                        NI_NUMERICHOST
                    )
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    private static func flag(_ thread: thread_basic_info) -> Bool {
        let foo = thread.flags & TH_FLAGS_IDLE
        let number = NSNumber.init(value: foo)
        return !Bool.init(truncating: number)
    }
    
    private static func threadBasicInfos() -> [thread_basic_info]  {
        var result: [thread_basic_info] = []
        
        var thinfo : thread_info_t = thread_info_t.allocate(capacity: Int(THREAD_INFO_MAX))
        let thread_info_count = UnsafeMutablePointer<mach_msg_type_number_t>.allocate(capacity: 128)
        let count: Int = MemoryLayout<thread_basic_info_data_t>.size / MemoryLayout<integer_t>.size
        for act_t in threadActPointers() {
            thread_info_count.pointee = UInt32(THREAD_INFO_MAX);
            let kr = thread_info(act_t ,thread_flavor_t(THREAD_BASIC_INFO),thinfo, thread_info_count);
            if (kr != KERN_SUCCESS) {
                return [thread_basic_info]();
            }
            
            let th_basic_info = withUnsafePointer(to: &thinfo, {
                return $0.withMemoryRebound(to: thread_basic_info_t.self, capacity: count, {
                    return $0.pointee
                })
            }).pointee
            
            result.append(th_basic_info)
        }
        return result
    }
    
    private static func threadActPointers() -> [thread_act_t] {
        var threads_act: [thread_act_t] = []
        
        var threads_array: thread_act_array_t? = nil
        var count = mach_msg_type_number_t()
        
        let result = task_threads(mach_task_self_, &(threads_array), &count)
        
        guard result == KERN_SUCCESS else {
            return threads_act
        }
        
        guard let array = threads_array  else {
            return threads_act
        }
        
        for i in 0..<count {
            threads_act.append(array[Int(i)])
        }
        
        let krsize = count * UInt32.init(MemoryLayout<thread_t>.size)
        _ = vm_deallocate(mach_task_self_, vm_address_t(array.pointee), vm_size_t(krsize));
        return threads_act
    }
    #endif
}

extension UIDevice {
    fileprivate static var loadPrevious = host_cpu_load_info()
}

private let HOST_VM_INFO64_COUNT: mach_msg_type_number_t =
    UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)

private let PAGE_SIZE: Double = Double(vm_kernel_page_size)

private let HOST_CPU_LOAD_INFO_COUNT: mach_msg_type_number_t =
    UInt32(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)


#endif
