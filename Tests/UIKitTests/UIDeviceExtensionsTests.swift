//
//  UIDeviceExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/23.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class UIDeviceExtensionsTests: XCTestCase {

    func testIpad() {
        XCTAssertFalse(UIDevice.re.isPad)
    }
    
    func testIsSimulator() {
        XCTAssertTrue(UIDevice.re.isSimulator)
    }
    
    func testIsJailBroken() {
        XCTAssertFalse(UIDevice.re.isJailbroken)
    }

    private func sendRightRefs(of thread: thread_act_t) -> mach_port_urefs_t {
        var refs = mach_port_urefs_t()
        mach_port_get_refs(mach_task_self_, thread, MACH_PORT_RIGHT_SEND, &refs)
        return refs
    }

    func testAppCPUUsageDoesNotLeakThreadPorts() {
        let thread = mach_thread_self()
        defer { mach_port_deallocate(mach_task_self_, thread) }

        XCTAssertGreaterThanOrEqual(UIDevice.re.appCPUUsage, 0)
        let before = sendRightRefs(of: thread)
        for _ in 0..<500 {
            _ = UIDevice.re.appCPUUsage
        }
        // task_threads adds a send right reference per thread on every call; leaking them grows this count.
        XCTAssertEqual(sendRightRefs(of: thread), before)
    }

}
