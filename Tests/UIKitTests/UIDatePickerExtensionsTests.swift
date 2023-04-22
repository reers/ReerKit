//
//  UIDatePickerExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && os(iOS)
import UIKit

final class UIDatePickerExtensionsTests: XCTestCase {
    #if !targetEnvironment(macCatalyst)
    func testTextColor() {
        let datePicker = UIDatePicker()
        if let color = datePicker.re.textColor {
            XCTAssertNotEqual(color, .red)
        }

        datePicker.re.textColor = .red
        XCTAssertEqual(datePicker.re.textColor, .red)

        datePicker.re.textColor = .green
        XCTAssertEqual(datePicker.re.textColor, .green)

        datePicker.re.textColor = nil
        XCTAssertNil(datePicker.re.textColor)
    }
    #endif
}

#endif
