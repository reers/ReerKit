//
//  CalendarExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/1.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit
#if canImport(Foundation)
import Foundation

final class CalendarExtensionsTests: XCTestCase {

    func testNumberOfDaysInAMonth() {
        let calendar = Calendar(identifier: .gregorian)
        let longMonths = [1, 3, 5, 7, 8, 10, 12]
        let shortMonths = [4, 6, 9, 11]
        let febDateComponent = DateComponents(year: 2015, month: 2)
        let febDate = calendar.date(from: febDateComponent)!
        let leapYearDateComponent = DateComponents(year: 2020, month: 2)
        let leapYearDate = calendar.date(from: leapYearDateComponent)!
        let longMonthsDateComponents = longMonths.map { DateComponents(year: 2015, month: $0) }
        let shortMonthsDateComponents = shortMonths.map { DateComponents(year: 2015, month: $0) }
        let longMonthDates = longMonthsDateComponents.compactMap { calendar.date(from: $0) }
        let shortMonthDates = shortMonthsDateComponents.compactMap { calendar.date(from: $0) }
        longMonthDates.forEach { XCTAssertEqual(calendar.re.numberOfDaysInMonth(for: $0), 31) }
        shortMonthDates.forEach { XCTAssertEqual(calendar.re.numberOfDaysInMonth(for: $0), 30) }
        XCTAssertEqual(calendar.re.numberOfDaysInMonth(for: febDate), 28)
        XCTAssertEqual(calendar.re.numberOfDaysInMonth(for: leapYearDate), 29)
    }

}
#endif
