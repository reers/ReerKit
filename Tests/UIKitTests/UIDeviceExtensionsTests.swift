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

}
