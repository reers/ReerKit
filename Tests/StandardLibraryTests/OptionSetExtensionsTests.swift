//
//  OptionSetExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/23.
//  Copyright © 2023 reers. All rights reserved.
//

#if canImport(UIKit)
import XCTest
@testable import ReerKit

final class OptionSetExtensionsTests: XCTestCase {

    func testelements() {
        let events: UIControl.Event = [.touchDown, .touchCancel, .touchUpInside]
        var index = 0
        events.re.elements().forEach { event in
            if index == 0 {
                XCTAssertEqual(event.rawValue, 1)
            } else if index == 1 {
                XCTAssertEqual(event.rawValue, 64)
            } else if index == 2 {
                XCTAssertEqual(event.rawValue, 256)
            }
            index += 1
        }
    }

}
#endif
