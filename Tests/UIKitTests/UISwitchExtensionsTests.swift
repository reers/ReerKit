//
//  UISwitchExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if os(iOS)
import UIKit

final class UISwitchExtensionsTests: XCTestCase {
    func testToggle() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let aSwitch = UISwitch(frame: frame)
        XCTAssertFalse(aSwitch.isOn)
        aSwitch.re.toggle(animated: false)
        XCTAssert(aSwitch.isOn)
    }
}

#endif
