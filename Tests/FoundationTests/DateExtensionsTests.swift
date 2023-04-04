//
//  DateExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/4.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class DateExtensionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        NSTimeZone.default = TimeZone(abbreviation: "UTC")!
    }

    // swiftlint:disable:next cyclomatic_complexity
    func testCalendar() {
        switch Calendar.current.identifier {
        case .buddhist:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .buddhist).identifier)
        case .chinese:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .chinese).identifier)
        case .coptic:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .coptic).identifier)
        case .ethiopicAmeteAlem:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .ethiopicAmeteAlem).identifier)
        case .ethiopicAmeteMihret:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .ethiopicAmeteMihret).identifier)
        case .gregorian:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .gregorian).identifier)
        case .hebrew:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .hebrew).identifier)
        case .indian:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .indian).identifier)
        case .islamic:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .islamic).identifier)
        case .islamicCivil:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .islamicCivil).identifier)
        case .islamicTabular:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .islamicTabular).identifier)
        case .islamicUmmAlQura:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .islamicUmmAlQura).identifier)
        case .iso8601:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .iso8601).identifier)
        case .japanese:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .japanese).identifier)
        case .persian:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .persian).identifier)
        case .republicOfChina:
            XCTAssertEqual(Date().re.calendar.identifier, Calendar(identifier: .republicOfChina).identifier)
        @unknown default:
            break
        }
    }

    func testEra() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.re.era, 1)
    }

    func testQuarter() {
        #if !os(Linux)
        let date1 = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date1.re.quarter, 1)

        let date2 = Calendar.current.date(byAdding: .month, value: 4, to: date1)
        XCTAssertEqual(date2?.re.quarter, 2)

        let date3 = Calendar.current.date(byAdding: .month, value: 8, to: date1)
        XCTAssertEqual(date3?.re.quarter, 3)

        let date4 = Calendar.current.date(byAdding: .month, value: 11, to: date1)
        XCTAssertEqual(date4?.re.quarter, 4)
        #endif
    }

    func testWeekOfYear() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.re.weekOfYear, 1)

        let dateAfter7Days = Calendar.current.date(byAdding: .day, value: 7, to: date)
        XCTAssertEqual(dateAfter7Days?.re.weekOfYear, 2)

        let originalDate = Calendar.current.date(byAdding: .day, value: -7, to: dateAfter7Days!)
        XCTAssertEqual(originalDate?.re.weekOfYear, 1)
    }

    func testWeekOfMonth() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.re.weekOfMonth, 1)

        let dateAfter7Days = Calendar.current.date(byAdding: .day, value: 7, to: date)
        XCTAssertEqual(dateAfter7Days?.re.weekOfMonth, 2)

        let originalDate = Calendar.current.date(byAdding: .day, value: -7, to: dateAfter7Days!)
        XCTAssertEqual(originalDate?.re.weekOfMonth, 1)
    }

    func testYear() {
        var date = Date(timeIntervalSince1970: 100_000.123450040)
        XCTAssertEqual(date.re.year, 1970)

        var isLowerComponentsValid: Bool {
            guard date.re.month == 1 else { return false }
            guard date.re.day == 2 else { return false }
            guard date.re.hour == 3 else { return false }
            guard date.re.minute == 46 else { return false }
            guard date.re.second == 40 else { return false }
            guard date.re.nanosecond == 123_450_040 else { return false }
            return true
        }

        date.re.setYear(2000)
        XCTAssertEqual(date.re.year, 2000)
        XCTAssert(isLowerComponentsValid)

        date.re.setYear(2017)
        XCTAssertEqual(date.re.year, 2017)
        XCTAssert(isLowerComponentsValid)

        date.re.setYear(1988)
        XCTAssertEqual(date.re.year, 1988)
        XCTAssert(isLowerComponentsValid)

        date.re.setYear(-100)
        XCTAssertEqual(date.re.year, 1988)
        XCTAssert(isLowerComponentsValid)

        date.re.setYear(0)
        XCTAssertEqual(date.re.year, 1988)
        XCTAssert(isLowerComponentsValid)
    }

    func testMonth() {
        var date = Date(timeIntervalSince1970: 100_000.123450040)
        XCTAssertEqual(date.re.month, 1)

        var isLowerComponentsValid: Bool {
            guard date.re.day == 2 else { return false }
            guard date.re.hour == 3 else { return false }
            guard date.re.minute == 46 else { return false }
            guard date.re.second == 40 else { return false }
            guard date.re.nanosecond == 123_450_040 else { return false }
            return true
        }

        date.re.setMonth(2)
        XCTAssert(isLowerComponentsValid)

        date.re.setMonth(14)
        XCTAssertEqual(date.re.month, 2)
        XCTAssert(isLowerComponentsValid)

        date.re.setMonth(1)
        XCTAssertEqual(date.re.month, 1)
        XCTAssert(isLowerComponentsValid)

        date.re.setMonth(0)
        XCTAssertEqual(date.re.month, 1)
        XCTAssert(isLowerComponentsValid)

        date.re.setMonth(-3)
        XCTAssertEqual(date.re.month, 1)
        XCTAssert(isLowerComponentsValid)
    }

    func testDay() {
        var date = Date(timeIntervalSince1970: 100_000.123450040)
        XCTAssertEqual(date.re.day, 2)

        var isLowerComponentsValid: Bool {
            guard date.re.hour == 3 else { return false }
            guard date.re.minute == 46 else { return false }
            guard date.re.second == 40 else { return false }
            guard date.re.nanosecond == 123_450_040 else { return false }
            return true
        }

        date.re.setDay(4)
        XCTAssertEqual(date.re.day, 4)
        XCTAssert(isLowerComponentsValid)

        date.re.setDay(1)
        XCTAssertEqual(date.re.day, 1)
        XCTAssert(isLowerComponentsValid)

        date.re.setDay(0)
        XCTAssertEqual(date.re.day, 1)
        XCTAssert(isLowerComponentsValid)

        date.re.setDay(-3)
        XCTAssertEqual(date.re.day, 1)
        XCTAssert(isLowerComponentsValid)

        date.re.setDay(45)
        XCTAssertEqual(date.re.day, 1)
        XCTAssert(isLowerComponentsValid)
    }

    func testWeekday() {
        let date = Date(timeIntervalSince1970: 100_000)
        XCTAssertEqual(date.re.weekday, 6)
    }

    func testHour() {
        var date = Date(timeIntervalSince1970: 100_000.123450040)
        XCTAssertEqual(date.re.hour, 3)

        var isLowerComponentsValid: Bool {
            guard date.re.minute == 46 else { return false }
            guard date.re.second == 40 else { return false }
            guard date.re.nanosecond == 123_450_040 else { return false }
            return true
        }

        date.re.setHour(-3)
        XCTAssertEqual(date.re.hour, 3)
        XCTAssert(isLowerComponentsValid)

        date.re.setHour(25)
        XCTAssertEqual(date.re.hour, 3)
        XCTAssert(isLowerComponentsValid)

        date.re.setHour(4)
        XCTAssertEqual(date.re.hour, 4)
        XCTAssert(isLowerComponentsValid)

        date.re.setHour(1)
        XCTAssertEqual(date.re.hour, 1)
        XCTAssert(isLowerComponentsValid)
    }

    func testMinute() {
        var date = Date(timeIntervalSince1970: 100_000.123450040)
        XCTAssertEqual(date.re.minute, 46)

        var isLowerComponentsValid: Bool {
            guard date.re.second == 40 else { return false }
            guard date.re.nanosecond == 123_450_040 else { return false }
            return true
        }

        date.re.setMinute(-3)
        XCTAssertEqual(date.re.minute, 46)
        XCTAssert(isLowerComponentsValid)

        date.re.setMinute(71)
        XCTAssertEqual(date.re.minute, 46)
        XCTAssert(isLowerComponentsValid)

        date.re.setMinute(4)
        XCTAssertEqual(date.re.minute, 4)
        XCTAssert(isLowerComponentsValid)

        date.re.setMinute(1)
        XCTAssertEqual(date.re.minute, 1)
        XCTAssert(isLowerComponentsValid)
    }

    func testSecond() {
        var date = Date(timeIntervalSince1970: 100_000.123450040)
        XCTAssertEqual(date.re.second, 40)

        var isLowerComponentsValid: Bool {
            guard date.re.nanosecond == 123_450_040 else { return false }
            return true
        }

        date.re.setSecond(-3)
        XCTAssertEqual(date.re.second, 40)
        XCTAssert(isLowerComponentsValid)

        date.re.setSecond(71)
        XCTAssertEqual(date.re.second, 40)
        XCTAssert(isLowerComponentsValid)

        date.re.setSecond(12)
        XCTAssertEqual(date.re.second, 12)
        XCTAssert(isLowerComponentsValid)

        date.re.setSecond(1)
        XCTAssertEqual(date.re.second, 1)
        XCTAssert(isLowerComponentsValid)
    }

    func testNanosecond() {
        var date = Date(timeIntervalSince1970: 100_000.123450040)
        XCTAssertEqual(date.re.nanosecond, 123_450_040)

        date.re.setNanosecond(-3)
        XCTAssertEqual(date.re.nanosecond, 123_450_040)

        date.re.setNanosecond(10000)
        XCTAssert(date.re.nanosecond >= 1000)
        XCTAssert(date.re.nanosecond <= 100_000)
    }

    func testMillisecond() {
        var date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.re.millisecond, 0)

        date.re.setMillisecond(-3)
        XCTAssertEqual(date.re.millisecond, 0)

        date.re.setMillisecond(10)
        XCTAssert(date.re.millisecond >= 9)
        XCTAssert(date.re.millisecond <= 11)

        date.re.setMillisecond(3)
        XCTAssert(date.re.millisecond >= 2)
        XCTAssert(date.re.millisecond <= 4)
    }

    func testIsInFuture() {
        let oldDate = Date(timeIntervalSince1970: 512) // 1970-01-01T00:08:32.000Z
        let futureDate = Date(timeIntervalSinceNow: 512)

        XCTAssert(futureDate.re.isFuture)
        XCTAssertFalse(oldDate.re.isFuture)
    }

    func testIsInPast() {
        let oldDate = Date(timeIntervalSince1970: 512) // 1970-01-01T00:08:32.000Z
        let futureDate = Date(timeIntervalSinceNow: 512)

        XCTAssert(oldDate.re.isPast)
        XCTAssertFalse(futureDate.re.isPast)
    }

    func testIsInToday() {
        XCTAssert(Date().re.isToday)
        let tomorrow = Date().re.adding(.day, value: 1)
        XCTAssertFalse(tomorrow.re.isToday)
        let yesterday = Date().re.adding(.day, value: -1)
        XCTAssertFalse(yesterday.re.isToday)
    }

    func testIsInYesterday() {
        XCTAssertFalse(Date().re.isYesterday)
        let tomorrow = Date().re.adding(.day, value: 1)
        XCTAssertFalse(tomorrow.re.isYesterday)
        let yesterday = Date().re.adding(.day, value: -1)
        XCTAssert(yesterday.re.isYesterday)
    }

    func testIsInTomorrow() {
        XCTAssertFalse(Date().re.isTomorrow)
        let tomorrow = Date().re.adding(.day, value: 1)
        XCTAssert(tomorrow.re.isTomorrow)
        let yesterday = Date().re.adding(.day, value: -1)
        XCTAssertFalse(yesterday.re.isTomorrow)
    }

    func testIsInWeekend() {
        let date = Date()
        XCTAssertEqual(date.re.isWeekend, Calendar.current.isDateInWeekend(date))
    }

    func testIsWorkday() {
        let date = Date()
        XCTAssertEqual(date.re.isWorkday, !Calendar.current.isDateInWeekend(date))
    }

    func testIsInCurrentWeek() {
        let date = Date()
        XCTAssert(date.re.isThisWeek)
        let dateOneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: date) ?? Date()
        XCTAssertFalse(dateOneYearFromNow.re.isThisWeek)
    }

    func testIsInCurrentMonth() {
        let date = Date()
        XCTAssert(date.re.isThisMonth)
        let dateOneYearFromNow = date.re.adding(.year, value: 1)
        XCTAssertFalse(dateOneYearFromNow.re.isThisMonth)
    }

    func testIsInCurrentYear() {
        let date = Date()
        XCTAssert(date.re.isThisYear)
        let dateOneYearFromNow = date.re.adding(.year, value: 1)
        XCTAssertFalse(dateOneYearFromNow.re.isThisYear)
    }

    func testIso8601String() {
        let date = Date(timeIntervalSince1970: 512) // 1970-01-01T00:08:32.000Z
        XCTAssertEqual(date.re.iso8601String, "1970-01-01T00:08:32.000Z")
    }

    func testNearestFiveMinutes() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.re.nearestFiveMinutes, date)

        let date2 = date.re.adding(.minute, value: 4) // adding 4 minutes
        XCTAssertNotEqual(date2.re.nearestFiveMinutes, date2)
        XCTAssertEqual(date2.re.nearestFiveMinutes, date2.re.adding(.minute, value: 1))

        let date3 = date.re.adding(.minute, value: 7) // adding 7 minutes
        XCTAssertEqual(date3.re.nearestFiveMinutes, date3.re.adding(.minute, value: -2))

        let date4 = date.re.adding(.minute, value: 2)
        XCTAssertEqual(date4.re.nearestFiveMinutes, date)

        let date5 = date.re.adding(.minute, value: 3)
        XCTAssertEqual(date5.re.nearestFiveMinutes, date.re.adding(.minute, value: 5))
    }

    func testNearestTenMinutes() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.re.nearestTenMinutes, date)

        let date2 = date.re.adding(.minute, value: 4) // adding 4 minutes
        XCTAssertEqual(date2.re.nearestTenMinutes, date)

        let date3 = date.re.adding(.minute, value: 7) // adding 7 minutes
        XCTAssertEqual(date3.re.nearestTenMinutes, date.re.adding(.minute, value: 10))

        let date4 = date.re.adding(.hour, value: 1).re.adding(.minute, value: 2) // adding 1 hour and 2 minutes
        XCTAssertEqual(date4.re.nearestTenMinutes, date.re.adding(.hour, value: 1))

        let date5 = date.re.adding(.minute, value: 5) // adding 5 minutes
        XCTAssertEqual(date5.re.nearestTenMinutes, date.re.adding(.minute, value: 10))
    }

    func testNearestQuarterHour() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.re.nearestQuarterHour, date)

        let date2 = date.re.adding(.minute, value: 4) // adding 4 minutes
        XCTAssertEqual(date2.re.nearestQuarterHour, date)

        let date3 = date.re.adding(.minute, value: 12) // adding 12 minutes
        XCTAssertEqual(date3.re.nearestQuarterHour, date.re.adding(.minute, value: 15))

        let date4 = date.re.adding(.hour, value: 1).re.adding(.minute, value: 2) // adding 1 hour and 2 minutes
        XCTAssertEqual(date4.re.nearestQuarterHour, date.re.adding(.hour, value: 1))

        let date5 = date.re.adding(.minute, value: 8) // adding 8 minutes
        XCTAssertEqual(date5.re.nearestQuarterHour, date.re.adding(.minute, value: 15))

        let date6 = date.re.adding(.minute, value: 7) // adding 7 minutes
        XCTAssertEqual(date6.re.nearestQuarterHour, date)
    }

    func testNearestHalfHour() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.re.nearestHalfHour, date)

        let date2 = date.re.adding(.minute, value: 4) // adding 4 minutes
        XCTAssertEqual(date2.re.nearestHalfHour, date)

        let date3 = date.re.adding(.minute, value: 19) // adding 19 minutes
        XCTAssertEqual(date3.re.nearestHalfHour, date.re.adding(.minute, value: 30))

        let date4 = date.re.adding(.hour, value: 1).re.adding(.minute, value: 2) // adding 1 hour and 2 minutes
        XCTAssertEqual(date4.re.nearestHalfHour, date.re.adding(.hour, value: 1))

        let date5 = date.re.adding(.minute, value: 15) // adding 15 minutes
        XCTAssertEqual(date5.re.nearestHalfHour, date.re.adding(.minute, value: 30))
    }

    func testNearestHour() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.re.nearestHour, date)

        let date2 = date.re.adding(.minute, value: 4) // adding 4 minutes
        XCTAssertEqual(date2.re.nearestHour, date)

        let date3 = date.re.adding(.minute, value: 34) // adding 34 minutes
        XCTAssertEqual(date3.re.nearestHour, date.re.adding(.hour, value: 1))

        let date4 = date.re.adding(.minute, value: 30) // adding 30 minutes
        XCTAssertEqual(date4.re.nearestHour, date.re.adding(.hour, value: 1))
    }

    func testUnixTimestamp() {
        let date = Date()
        XCTAssertEqual(date.re.unixTimestamp, date.timeIntervalSince1970)

        let date2 = Date(timeIntervalSince1970: 100)
        XCTAssertEqual(date2.re.unixTimestamp, 100)
    }

    func testAdding() {
        let date = Date(timeIntervalSince1970: 3610) // Jan 1, 1970, 3:00:10 AM

        XCTAssertEqual(date.re.adding(.second, value: 0), date)
        let date1 = date.re.adding(.second, value: 10)
        XCTAssertEqual(date1.re.second, date.re.second + 10)
        XCTAssertEqual(date1.re.adding(.second, value: -10), date)

        XCTAssertEqual(date.re.adding(.minute, value: 0), date)
        let date2 = date.re.adding(.minute, value: 10)
        XCTAssertEqual(date2.re.minute, date.re.minute + 10)
        XCTAssertEqual(date2.re.adding(.minute, value: -10), date)

        XCTAssertEqual(date.re.adding(.hour, value: 0), date)
        let date3 = date.re.adding(.hour, value: 2)
        XCTAssertEqual(date3.re.hour, date.re.hour + 2)
        XCTAssertEqual(date3.re.adding(.hour, value: -2), date)

        XCTAssertEqual(date.re.adding(.day, value: 0), date)
        let date4 = date.re.adding(.day, value: 2)
        XCTAssertEqual(date4.re.day, date.re.day + 2)
        XCTAssertEqual(date4.re.adding(.day, value: -2), date)

        XCTAssertEqual(date.re.adding(.weekOfYear, value: 0), date)
        let date5 = date.re.adding(.weekOfYear, value: 1)
        XCTAssertEqual(date5.re.day, date.re.day + 7)
        XCTAssertEqual(date5.re.adding(.weekOfYear, value: -1), date)

        XCTAssertEqual(date.re.adding(.weekOfMonth, value: 0), date)
        let date6 = date.re.adding(.weekOfMonth, value: 1)

        XCTAssertEqual(date6.re.day, date.re.day + 7)
        XCTAssertEqual(date6.re.adding(.weekOfMonth, value: -1), date)

        XCTAssertEqual(date.re.adding(.month, value: 0), date)
        let date7 = date.re.adding(.month, value: 2)
        XCTAssertEqual(date7.re.month, date.re.month + 2)
        XCTAssertEqual(date7.re.adding(.month, value: -2), date)

        XCTAssertEqual(date.re.adding(.year, value: 0), date)
        let date8 = date.re.adding(.year, value: 4)
        XCTAssertEqual(date8.re.year, date.re.year + 4)
        XCTAssertEqual(date8.re.adding(.year, value: -4), date)
    }

    // swiftlint:disable:next function_body_length
    func testAdd() {
        var date = Date(timeIntervalSince1970: 0)

        date.re.setSecond(10)
        date.re.add(.second, value: -1)
        XCTAssertEqual(date.re.second, 9)
        date.re.add(.second, value: 0)
        XCTAssertEqual(date.re.second, 9)

        date.re.add(.second, value: 1)
        XCTAssertEqual(date.re.second, 10)

        date.re.setMinute(10)
        date.re.add(.minute, value: -1)
        XCTAssertEqual(date.re.minute, 9)
        date.re.add(.minute, value: 0)
        XCTAssertEqual(date.re.minute, 9)

        date.re.add(.minute, value: 1)
        XCTAssertEqual(date.re.minute, 10)

        date.re.setHour(10)
        date.re.add(.hour, value: -1)
        XCTAssertEqual(date.re.hour, 9)
        date.re.add(.hour, value: 0)
        XCTAssertEqual(date.re.hour, 9)

        date.re.add(.hour, value: 1)
        XCTAssertEqual(date.re.hour, 10)

        date.re.setDay(10)
        date.re.add(.day, value: -1)
        XCTAssertEqual(date.re.day, 9)
        date.re.add(.day, value: 0)
        XCTAssertEqual(date.re.day, 9)

        date.re.add(.day, value: 1)
        XCTAssertEqual(date.re.day, 10)

        date.re.setMonth(10)
        date.re.add(.month, value: -1)
        XCTAssertEqual(date.re.month, 9)
        date.re.add(.month, value: 0)
        XCTAssertEqual(date.re.month, 9)

        date.re.add(.month, value: 1)
        XCTAssertEqual(date.re.month, 10)

        date = Date(timeIntervalSince1970: 1_514_764_800)

        date.re.add(.year, value: -1)
        XCTAssertEqual(date.re.year, 2017)
        date.re.add(.year, value: 0)
        XCTAssertEqual(date.re.year, 2017)

        date.re.add(.year, value: 1)
        XCTAssertEqual(date.re.year, 2018)
    }

    func testChanging() {
        let date = Date(timeIntervalSince1970: 0)

        XCTAssertNil(date.re.changing(.nanosecond, value: -10))
        XCTAssertNotNil(date.re.changing(.nanosecond, value: 123_450_040))
        XCTAssertEqual(date.re.changing(.nanosecond, value: 123_450_040)?.re.nanosecond, 123_450_040)

        XCTAssertNil(date.re.changing(.second, value: -10))
        XCTAssertNil(date.re.changing(.second, value: 70))
        XCTAssertNotNil(date.re.changing(.second, value: 20))
        XCTAssertEqual(date.re.changing(.second, value: 20)?.re.second, 20)

        XCTAssertNil(date.re.changing(.minute, value: -10))
        XCTAssertNil(date.re.changing(.minute, value: 70))
        XCTAssertNotNil(date.re.changing(.minute, value: 20))
        XCTAssertEqual(date.re.changing(.minute, value: 20)?.re.minute, 20)

        XCTAssertNil(date.re.changing(.hour, value: -2))
        XCTAssertNil(date.re.changing(.hour, value: 25))
        XCTAssertNotNil(date.re.changing(.hour, value: 6))
        XCTAssertEqual(date.re.changing(.hour, value: 6)?.re.hour, 6)

        XCTAssertNil(date.re.changing(.day, value: -2))
        XCTAssertNil(date.re.changing(.day, value: 35))
        XCTAssertNotNil(date.re.changing(.day, value: 6))
        XCTAssertEqual(date.re.changing(.day, value: 6)?.re.day, 6)

        XCTAssertNil(date.re.changing(.month, value: -2))
        XCTAssertNil(date.re.changing(.month, value: 13))
        XCTAssertNotNil(date.re.changing(.month, value: 6))
        XCTAssertEqual(date.re.changing(.month, value: 6)?.re.month, 6)

        XCTAssertNil(date.re.changing(.year, value: -2))
        XCTAssertNil(date.re.changing(.year, value: 0))
        XCTAssertNotNil(date.re.changing(.year, value: 2015))
        XCTAssertEqual(date.re.changing(.year, value: 2015)?.re.year, 2015)

        let date1 = Date()
        let date2 = date1.re.changing(.weekOfYear, value: 10)
        XCTAssertEqual(date2, Calendar.current.date(bySetting: .weekOfYear, value: 10, of: date1))
    }

    func testBeginning() {
        #if !os(Linux)
        let date = Date()

        XCTAssertNotNil(date.re.beginning(of: .second))
        XCTAssertEqual(date.re.beginning(of: .second)?.re.nanosecond, 0)

        XCTAssertNotNil(date.re.beginning(of: .minute))
        XCTAssertEqual(date.re.beginning(of: .minute)?.re.second, 0)

        XCTAssertNotNil(date.re.beginning(of: .hour))
        XCTAssertEqual(date.re.beginning(of: .hour)?.re.minute, 0)

        XCTAssertNotNil(date.re.beginning(of: .day))
        XCTAssertEqual(date.re.beginning(of: .day)?.re.hour, 0)
        XCTAssertEqual(date.re.beginning(of: .day)?.re.isToday, true)

        let comps = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        let beginningOfWeek = Calendar.current.date(from: comps)
        XCTAssertNotNil(date.re.beginning(of: .weekOfMonth))
        XCTAssertNotNil(beginningOfWeek)
        XCTAssertEqual(date.re.beginning(of: .weekOfMonth)?.re.day, beginningOfWeek?.re.day)

        let beginningOfMonth = Date.re(year: 2016, month: 8, day: 1, hour: 5)
        XCTAssertNotNil(date.re.beginning(of: .month))
        XCTAssertNotNil(beginningOfMonth)
        XCTAssertEqual(date.re.beginning(of: .month)?.re.day, beginningOfMonth?.re.day)

        let beginningOfYear = Date.re(year: 2016, month: 1, day: 1, hour: 5)
        XCTAssertNotNil(date.re.beginning(of: .year))
        XCTAssertNotNil(beginningOfYear)
        XCTAssertEqual(date.re.beginning(of: .year)?.re.day, beginningOfYear?.re.day)

        XCTAssertNil(date.re.beginning(of: .quarter))
        #endif
    }

    func testEnd() {
        let date = Date(timeIntervalSince1970: 512) // January 1, 1970 at 2:08:32 AM GMT+2

        XCTAssertEqual(date.re.end(of: .second)?.re.second, 32)
        XCTAssertEqual(date.re.end(of: .hour)?.re.minute, 59)
        XCTAssertEqual(date.re.end(of: .minute)?.re.second, 59)

        XCTAssertEqual(date.re.end(of: .day)?.re.hour, 23)
        XCTAssertEqual(date.re.end(of: .day)?.re.minute, 59)
        XCTAssertEqual(date.re.end(of: .day)?.re.second, 59)

        #if !os(Linux)
        var endOfWeek = date.re.beginning(of: .weekOfYear)
        endOfWeek?.re.add(.day, value: 7)
        endOfWeek?.re.add(.second, value: -1)
        XCTAssertEqual(date.re.end(of: .weekOfYear), endOfWeek)
        #endif

        XCTAssertEqual(date.re.end(of: .month)?.re.day, 31)
        XCTAssertEqual(date.re.end(of: .month)?.re.hour, 23)
        XCTAssertEqual(date.re.end(of: .month)?.re.minute, 59)
        XCTAssertEqual(date.re.end(of: .month)?.re.second, 59)

        XCTAssertEqual(date.re.end(of: .year)?.re.month, 12)
        XCTAssertEqual(date.re.end(of: .year)?.re.day, 31)
        XCTAssertEqual(date.re.end(of: .year)?.re.hour, 23)
        XCTAssertEqual(date.re.end(of: .year)?.re.minute, 59)
        XCTAssertEqual(date.re.end(of: .year)?.re.second, 59)

        XCTAssertNil(date.re.end(of: .quarter))
    }

    func testDateString() {
        let date = Date(timeIntervalSince1970: 512)
        let formatter = DateFormatter()
        formatter.timeStyle = .none

        formatter.dateStyle = .short
        XCTAssertEqual(date.re.dateString(ofStyle: .short), formatter.string(from: date))

        formatter.dateStyle = .medium
        XCTAssertEqual(date.re.dateString(ofStyle: .medium), formatter.string(from: date))

        formatter.dateStyle = .long
        XCTAssertEqual(date.re.dateString(ofStyle: .long), formatter.string(from: date))

        formatter.dateStyle = .full
        XCTAssertEqual(date.re.dateString(ofStyle: .full), formatter.string(from: date))

        formatter.dateStyle = .none

        formatter.dateFormat = "dd/MM/yyyy"
        XCTAssertEqual(date.re.string(withFormat: "dd/MM/yyyy"), formatter.string(from: date))

        formatter.dateFormat = "HH:mm"
        XCTAssertEqual(date.re.string(withFormat: "HH:mm"), formatter.string(from: date))

        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        XCTAssertEqual(date.re.string(withFormat: "dd/MM/yyyy HH:mm"), formatter.string(from: date))

        formatter.dateFormat = "iiiii"
        XCTAssertEqual(date.re.string(withFormat: "iiiii"), formatter.string(from: date))
    }

    func testDateTimeString() {
        let date = Date(timeIntervalSince1970: 512)
        let formatter = DateFormatter()

        formatter.timeStyle = .short
        formatter.dateStyle = .short
        XCTAssertEqual(date.re.dateTimeString(ofStyle: .short), formatter.string(from: date))

        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        XCTAssertEqual(date.re.dateTimeString(ofStyle: .medium), formatter.string(from: date))

        formatter.timeStyle = .long
        formatter.dateStyle = .long
        XCTAssertEqual(date.re.dateTimeString(ofStyle: .long), formatter.string(from: date))

        formatter.timeStyle = .full
        formatter.dateStyle = .full
        XCTAssertEqual(date.re.dateTimeString(ofStyle: .full), formatter.string(from: date))
    }

    func testIsInCurrent() {
        let date = Date()
        let oldDate = Date(timeIntervalSince1970: 512) // 1970-01-01T00:08:32.000Z

        XCTAssert(date.re.isInCurrent(.second))
        XCTAssertFalse(oldDate.re.isInCurrent(.second))

        XCTAssert(date.re.isInCurrent(.minute))
        XCTAssertFalse(oldDate.re.isInCurrent(.minute))

        XCTAssert(date.re.isInCurrent(.hour))
        XCTAssertFalse(oldDate.re.isInCurrent(.hour))

        XCTAssert(date.re.isInCurrent(.day))
        XCTAssertFalse(oldDate.re.isInCurrent(.day))

        XCTAssert(date.re.isInCurrent(.weekOfMonth))
        XCTAssertFalse(oldDate.re.isInCurrent(.weekOfMonth))

        XCTAssert(date.re.isInCurrent(.month))
        XCTAssertFalse(oldDate.re.isInCurrent(.month))

        XCTAssert(date.re.isInCurrent(.year))
        XCTAssertFalse(oldDate.re.isInCurrent(.year))

        XCTAssert(date.re.isInCurrent(.era))
    }

    func testTimeString() {
        let date = Date(timeIntervalSince1970: 512)
        let formatter = DateFormatter()
        formatter.dateStyle = .none

        formatter.timeStyle = .short
        XCTAssertEqual(date.re.timeString(ofStyle: .short), formatter.string(from: date))

        formatter.timeStyle = .medium
        XCTAssertEqual(date.re.timeString(ofStyle: .medium), formatter.string(from: date))

        formatter.timeStyle = .long
        XCTAssertEqual(date.re.timeString(ofStyle: .long), formatter.string(from: date))

        formatter.timeStyle = .full
        XCTAssertEqual(date.re.timeString(ofStyle: .full), formatter.string(from: date))
    }

    func testDayName() {
        let date = Date(timeIntervalSince1970: 1_486_121_165)
        XCTAssertEqual(date.re.dayName(ofStyle: .full), "Friday")
        XCTAssertEqual(date.re.dayName(ofStyle: .threeLetters), "Fri")
        XCTAssertEqual(date.re.dayName(ofStyle: .oneLetter), "F")
    }

    func testMonthName() {
        let date = Date(timeIntervalSince1970: 1_486_121_165)
        XCTAssertEqual(date.re.monthName(ofStyle: .full), "February")
        XCTAssertEqual(date.re.monthName(ofStyle: .threeLetters), "Feb")
        XCTAssertEqual(date.re.monthName(ofStyle: .oneLetter), "F")
    }

    func testSecondsSince() {
        let date1 = Date(timeIntervalSince1970: 100)
        let date2 = Date(timeIntervalSince1970: 180)
        XCTAssertEqual(date2.re.secondsSince(date1), 80)
        XCTAssertEqual(date1.re.secondsSince(date2), -80)
    }

    func testMinutesSince() {
        let date1 = Date(timeIntervalSince1970: 120)
        let date2 = Date(timeIntervalSince1970: 180)
        XCTAssertEqual(date2.re.minutesSince(date1), 1)
        XCTAssertEqual(date1.re.minutesSince(date2), -1)
    }

    func testHoursSince() {
        let date1 = Date(timeIntervalSince1970: 3600)
        let date2 = Date(timeIntervalSince1970: 7200)
        XCTAssertEqual(date2.re.hoursSince(date1), 1)
        XCTAssertEqual(date1.re.hoursSince(date2), -1)
    }

    func testDaysSince() {
        let date1 = Date(timeIntervalSince1970: 0)
        let date2 = Date(timeIntervalSince1970: 86400)
        XCTAssertEqual(date2.re.daysSince(date1), 1)
        XCTAssertEqual(date1.re.daysSince(date2), -1)
    }

    func testIsBetween() {
        let date1 = Date(timeIntervalSince1970: 0)
        let date2 = date1.addingTimeInterval(60)
        let date3 = date2.addingTimeInterval(60)

        XCTAssert(date2.re.isBetween(date1, date3))
        XCTAssertFalse(date1.re.isBetween(date2, date3))
        XCTAssert(date1.re.isBetween(date1, date2, includeBounds: true))
        XCTAssertFalse(date1.re.isBetween(date1, date2))
    }

    func testIsWithin() {
        let date1 = Date(timeIntervalSince1970: 60 * 60 * 24) // 1970-01-01T00:00:00.000Z
        let date2 = date1.addingTimeInterval(60 * 60) // 1970-01-01T00:01:00.000Z, one hour later than date1

        // The regular
        XCTAssertFalse(date1.re.isWithin(1, .second, of: date2))
        XCTAssertFalse(date1.re.isWithin(1, .minute, of: date2))
        XCTAssert(date1.re.isWithin(1, .hour, of: date2))
        XCTAssert(date1.re.isWithin(1, .day, of: date2))

        // The other way around
        XCTAssertFalse(date2.re.isWithin(1, .second, of: date1))
        XCTAssertFalse(date2.re.isWithin(1, .minute, of: date1))
        XCTAssert(date2.re.isWithin(1, .hour, of: date1))
        XCTAssert(date2.re.isWithin(1, .day, of: date1))

        // With itself
        XCTAssert(date1.re.isWithin(1, .second, of: date1))
        XCTAssert(date1.re.isWithin(1, .minute, of: date1))
        XCTAssert(date1.re.isWithin(1, .hour, of: date1))
        XCTAssert(date1.re.isWithin(1, .day, of: date1))

        // Invalid
        XCTAssertFalse(Date().re.isWithin(1, .calendar, of: Date()))
    }

    func testNewDateFromComponenets() {
        let date = Date.re(
            calendar: Date().re.calendar,
            timeZone: NSTimeZone.default,
            era: Date().re.era,
            year: Date().re.year,
            month: Date().re.month,
            day: Date().re.day,
            hour: Date().re.hour,
            minute: Date().re.minute,
            second: Date().re.second,
            nanosecond: Date().re.nanosecond)
        XCTAssertNotNil(date)
        let date1 = Date(timeIntervalSince1970: date!.timeIntervalSince1970)

        XCTAssertEqual(date?.timeIntervalSince1970, date1.timeIntervalSince1970)

        let date2 = Date.re(
            calendar: nil,
            timeZone: NSTimeZone.default,
            era: Date().re.era,
            year: nil,
            month: nil,
            day: Date().re.day,
            hour: Date().re.hour,
            minute: Date().re.minute,
            second: Date().re.second,
            nanosecond: Date().re.nanosecond)
        XCTAssertNil(date2)
    }

    func testNewDateFromIso8601String() {
        let date = Date(timeIntervalSince1970: 512) // 1970-01-01T00:08:32.000Z
        let dateFromIso8601 = Date.re(iso8601String: "1970-01-01T00:08:32.000Z")
        XCTAssertEqual(date, dateFromIso8601)
        XCTAssertNil(Date.re(iso8601String: "hello"))
    }

    func testNewDateFromUnixTimestamp() {
        let date = Date(timeIntervalSince1970: 512) // 1970-01-01T00:08:32.000Z
        let dateFromUnixTimestamp = Date.re(unixTimestamp: 512)
        XCTAssertEqual(date, dateFromUnixTimestamp)
    }

    func testRandomRange() {
        var sinceDate = Date(timeIntervalSinceReferenceDate: 0)
        var toDate = Date(timeIntervalSinceReferenceDate: 10000)
        XCTAssert(Date.re.random(in: sinceDate..<toDate).re.isBetween(sinceDate, toDate, includeBounds: false))

        sinceDate = Date(timeIntervalSince1970: -10000)
        toDate = Date(timeIntervalSince1970: -10)
        XCTAssert(Date.re.random(in: sinceDate..<toDate).re.isBetween(sinceDate, toDate, includeBounds: false))

        sinceDate = Date(timeIntervalSinceReferenceDate: -1000)
        toDate = Date(timeIntervalSinceReferenceDate: 10000)
        XCTAssert(Date.re.random(in: sinceDate..<toDate).re.isBetween(sinceDate, toDate, includeBounds: false))

        sinceDate = Date.distantPast
        toDate = Date.distantFuture
        XCTAssert(Date.re.random(in: sinceDate..<toDate).re.isBetween(sinceDate, toDate, includeBounds: false))
    }

    func testRandomClosedRange() {
        var sinceDate = Date(timeIntervalSinceReferenceDate: 0)
        var toDate = Date(timeIntervalSinceReferenceDate: 10000)
        XCTAssert(Date.re.random(in: sinceDate...toDate).re.isBetween(sinceDate, toDate, includeBounds: true))

        sinceDate = Date(timeIntervalSince1970: -10000)
        toDate = Date(timeIntervalSince1970: -10)
        XCTAssert(Date.re.random(in: sinceDate...toDate).re.isBetween(sinceDate, toDate, includeBounds: true))

        sinceDate = Date(timeIntervalSinceReferenceDate: -1000)
        toDate = Date(timeIntervalSinceReferenceDate: 10000)
        XCTAssert(Date.re.random(in: sinceDate...toDate).re.isBetween(sinceDate, toDate, includeBounds: true))

        sinceDate = Date.distantPast
        toDate = Date.distantFuture
        XCTAssert(Date.re.random(in: sinceDate...toDate).re.isBetween(sinceDate, toDate, includeBounds: true))

        let singleDate = Date(timeIntervalSinceReferenceDate: 0)
        XCTAssertFalse(Date.re.random(in: singleDate...singleDate).re.isBetween(singleDate, singleDate, includeBounds: false))
        XCTAssert(Date.re.random(in: singleDate...singleDate).re.isBetween(singleDate, singleDate, includeBounds: true))
    }

    func testRandomRangeWithGenerator() {
        var generator = SystemRandomNumberGenerator()
        let sinceDate = Date.distantPast
        let toDate = Date.distantFuture
        XCTAssert(Date.re.random(in: sinceDate..<toDate, using: &generator)
            .re.isBetween(sinceDate, toDate, includeBounds: false))
    }

    func testRandomClosedRangeWithGenerator() {
        var generator = SystemRandomNumberGenerator()
        let sinceDate = Date.distantPast
        let toDate = Date.distantFuture
        XCTAssert(Date.re.random(in: sinceDate...toDate, using: &generator)
            .re.isBetween(sinceDate, toDate, includeBounds: true))

        let singleDate = Date(timeIntervalSinceReferenceDate: 0)
        XCTAssertFalse(Date.re.random(in: singleDate...singleDate, using: &generator)
            .re.isBetween(singleDate, singleDate, includeBounds: false))
        XCTAssert(Date.re.random(in: singleDate...singleDate, using: &generator)
            .re.isBetween(singleDate, singleDate, includeBounds: true))
    }

    func testYesterday() {
        let date = Date()
        let yesterday = date.re.yesterday
        let yesterdayCheck = Calendar.current.date(byAdding: .day, value: -1, to: date)
        XCTAssertEqual(yesterday, yesterdayCheck)
    }

    func testTomorrow() {
        let date = Date()
        let tomorrow = date.re.tomorrow
        let tomorrowCheck = Calendar.current.date(byAdding: .day, value: 1, to: date)
        XCTAssertEqual(tomorrow, tomorrowCheck)
    }

}
