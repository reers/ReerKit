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

#if os(macOS) || os(iOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

public extension Date {
    /// ReerKit: Day name format.
    ///
    /// - threeLetters: 3 letter day abbreviation of day name.
    /// - oneLetter: 1 letter day abbreviation of day name.
    /// - full: Full day name.
    enum NameStyle {
        /// ReerKit: 3 letter day abbreviation of day name.
        case threeLetters

        /// ReerKit: 1 letter day abbreviation of day name.
        case oneLetter

        /// ReerKit: Full day name.
        case full
    }
}

public extension ReerForEquatable where Base == Date {
    /// ReerKit: User’s current calendar.
    var calendar: Calendar { Calendar.current }

    /// ReerKit: Era.
    ///
    ///        Date().re.era -> 1
    ///
    var era: Int {
        return calendar.component(.era, from: base)
    }

#if !os(Linux)
    /// ReerKit: Quarter.
    ///
    ///        Date().quarter -> 3 // date in third quarter of the year.
    ///
    var quarter: Int {
        let month = Double(calendar.component(.month, from: base))
        let numberOfMonths = Double(calendar.monthSymbols.count)
        let numberOfMonthsInQuarter = numberOfMonths / 4
        return Int(ceil(month / numberOfMonthsInQuarter))
    }
#endif

    /// ReerKit: Week of year.
    ///
    ///        Date().weekOfYear -> 2 // second week in the year.
    ///
    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: base)
    }

    /// ReerKit: Week of month.
    ///
    ///        Date().weekOfMonth -> 3 // date is in third week of the month.
    ///
    var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: base)
    }

    /// ReerKit: Year.
    ///
    ///        Date().year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    var year: Int {
        get {
            return calendar.component(.year, from: base)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: base)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: base) {
                base = date
            }
        }
    }

    /// ReerKit: Month.
    ///
    ///     Date().month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.month = 10 // sets someDate's month to 10.
    ///
    var month: Int {
        get {
            return calendar.component(.month, from: base)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: base)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: base) {
                base = date
            }
        }
    }

    /// ReerKit: Day.
    ///
    ///     Date().day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    var day: Int {
        get {
            return calendar.component(.day, from: base)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: base)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: base) {
                base = date
            }
        }
    }

    /// ReerKit: Weekday.
    ///
    ///     Date().weekday -> 5 // fifth day in the current week.
    ///
    var weekday: Int {
        return calendar.component(.weekday, from: base)
    }

    /// ReerKit: Hour.
    ///
    ///     Date().hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
    ///
    var hour: Int {
        get {
            return calendar.component(.hour, from: base)
        }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentHour = calendar.component(.hour, from: base)
            let hoursToAdd = newValue - currentHour
            if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: base) {
                base = date
            }
        }
    }

    /// ReerKit: Minutes.
    ///
    ///     Date().minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    var minute: Int {
        get {
            return calendar.component(.minute, from: base)
        }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = calendar.component(.minute, from: base)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: base) {
                base = date
            }
        }
    }

    /// ReerKit: Seconds.
    ///
    ///     Date().second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15 // sets someDate's seconds to 15.
    ///
    var second: Int {
        get {
            return calendar.component(.second, from: base)
        }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: base)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = calendar.component(.second, from: base)
            let secondsToAdd = newValue - currentSeconds
            if let date = calendar.date(byAdding: .second, value: secondsToAdd, to: base) {
                base = date
            }
        }
    }

    /// ReerKit: Nanoseconds.
    ///
    ///     Date().nanosecond -> 981379985
    ///
    ///     var someDate = Date()
    ///     someDate.nanosecond = 981379985 // sets someDate's seconds to 981379985.
    ///
    var nanosecond: Int {
        get {
            return calendar.component(.nanosecond, from: base)
        }
        set {
#if targetEnvironment(macCatalyst)
            // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
            let allowedRange = 0..<1_000_000_000
#else
            let allowedRange = calendar.range(of: .nanosecond, in: .second, for: base)!
#endif
            guard allowedRange.contains(newValue) else { return }

            let currentNanoseconds = calendar.component(.nanosecond, from: base)
            let nanosecondsToAdd = newValue - currentNanoseconds

            if let date = calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: base) {
                base = date
            }
        }
    }

    /// ReerKit: Milliseconds.
    ///
    ///     Date().millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.millisecond = 68 // sets someDate's nanosecond to 68000000.
    ///
    var millisecond: Int {
        get {
            return calendar.component(.nanosecond, from: base) / 1_000_000
        }
        set {
            let nanoSeconds = newValue * 1_000_000
#if targetEnvironment(macCatalyst)
            // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
            let allowedRange = 0..<1_000_000_000
#else
            let allowedRange = calendar.range(of: .nanosecond, in: .second, for: base)!
#endif
            guard allowedRange.contains(nanoSeconds) else { return }

            if let date = calendar.date(bySetting: .nanosecond, value: nanoSeconds, of: base) {
                base = date
            }
        }
    }

    /// ReerKit: Check if date is in leap year
    var isLeapYear: Bool {
        let year = self.year
        return (year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))
    }

    /// ReerKit: Check if date is within today.
    ///
    ///     Date().isToday -> true
    ///
    var isToday: Bool {
        return Calendar.current.isDateInToday(base)
    }

    /// ReerKit: Check if date is within yesterday.
    ///
    ///     Date().isYesterday -> false
    ///
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(base)
    }

    /// ReerKit: Check if date is in future.
    ///
    ///     Date(timeInterval: 100, since: Date()).isFuture -> true
    ///
    var isFuture: Bool {
        return base > Date()
    }

    /// ReerKit: Check if date is in past.
    ///
    ///     Date(timeInterval: -100, since: Date()).isPast -> true
    ///
    var isPast: Bool {
        return base < Date()
    }

    /// ReerKit: Check if date is within tomorrow.
    ///
    ///     Date().isTomorrow -> false
    ///
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(base)
    }

    /// ReerKit: Check if date is within a weekend period.
    var isWeekend: Bool {
        return Calendar.current.isDateInWeekend(base)
    }

    /// ReerKit: Check if date is within a weekday period.
    var isWorkday: Bool {
        return !Calendar.current.isDateInWeekend(base)
    }

    /// ReerKit: Check if date is within the current week.
    var isThisWeek: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// ReerKit: Check if date is within the current month.
    var isThisMonth: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .month)
    }

    /// ReerKit: Check if date is within the current year.
    var isThisYear: Bool {
        return Calendar.current.isDate(base, equalTo: Date(), toGranularity: .year)
    }

    /// ReerKit: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSS) from date.
    ///
    ///     Date().iso8601String -> "2017-01-12T14:51:29.574Z"
    ///
    var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: base).appending("Z")
    }

    /// ReerKit: Nearest five minutes to date.
    ///
    ///     var date = Date() // "5:54 PM"
    ///     date.minute = 32 // "5:32 PM"
    ///     date.nearestFiveMinutes // "5:30 PM"
    ///
    ///     date.minute = 44 // "5:44 PM"
    ///     date.nearestFiveMinutes // "5:45 PM"
    ///
    var nearestFiveMinutes: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: base)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// ReerKit: Nearest ten minutes to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestTenMinutes // "5:30 PM"
    ///
    ///     date.minute = 48 // "5:48 PM"
    ///     date.nearestTenMinutes // "5:50 PM"
    ///
    var nearestTenMinutes: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: base)
        let min = components.minute!
        components.minute? = min % 10 < 5 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// ReerKit: Nearest quarter hour to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestQuarterHour // "5:30 PM"
    ///
    ///     date.minute = 40 // "5:40 PM"
    ///     date.nearestQuarterHour // "5:45 PM"
    ///
    var nearestQuarterHour: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: base)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// ReerKit: Nearest half hour to date.
    ///
    ///     var date = Date() // "6:07 PM"
    ///     date.minute = 41 // "6:41 PM"
    ///     date.nearestHalfHour // "6:30 PM"
    ///
    ///     date.minute = 51 // "6:51 PM"
    ///     date.nearestHalfHour // "7:00 PM"
    ///
    var nearestHalfHour: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: base)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// ReerKit: Nearest hour to date.
    ///
    ///     var date = Date() // "6:17 PM"
    ///     date.nearestHour // "6:00 PM"
    ///
    ///     date.minute = 36 // "6:36 PM"
    ///     date.nearestHour // "7:00 PM"
    ///
    var nearestHour: Date {
        let min = calendar.component(.minute, from: base)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = calendar.date(from: calendar.dateComponents(components, from: base))!

        if min < 30 {
            return date
        }
        return calendar.date(byAdding: .hour, value: 1, to: date)!
    }

    /// ReerKit: Yesterday date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    ///
    var yesterday: Date {
        return calendar.date(byAdding: .day, value: -1, to: base) ?? Date()
    }

    /// ReerKit: Tomorrow's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    ///
    var tomorrow: Date {
        return calendar.date(byAdding: .day, value: 1, to: base) ?? Date()
    }

    /// ReerKit: UNIX timestamp from date.
    ///
    ///        Date().unixTimestamp -> 1484233862.826291
    ///
    var unixTimestamp: Double {
        return base.timeIntervalSince1970
    }

    /// ReerKit: Date by adding multiples of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.adding(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.adding(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.adding(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.adding(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of components to add.
    /// - Returns: original date + multiples of component added.
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: base)!
    }

    /// ReerKit: Date by changing value of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.changing(.minute, value: 10) // "Jan 12, 2017, 7:10 PM"
    ///     let date3 = date.changing(.day, value: 4) // "Jan 4, 2017, 7:07 PM"
    ///     let date4 = date.changing(.month, value: 2) // "Feb 12, 2017, 7:07 PM"
    ///     let date5 = date.changing(.year, value: 2000) // "Jan 12, 2000, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: new value of component to change.
    /// - Returns: original date after changing given component to given value.
    func changing(_ component: Calendar.Component, value: Int) -> Date? {
        switch component {
        case .nanosecond:
#if targetEnvironment(macCatalyst)
            // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
            let allowedRange = 0..<1_000_000_000
#else
            let allowedRange = calendar.range(of: .nanosecond, in: .second, for: base)!
#endif
            guard allowedRange.contains(value) else { return nil }
            let currentNanoseconds = calendar.component(.nanosecond, from: base)
            let nanosecondsToAdd = value - currentNanoseconds
            return calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: base)

        case .second:
            let allowedRange = calendar.range(of: .second, in: .minute, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentSeconds = calendar.component(.second, from: base)
            let secondsToAdd = value - currentSeconds
            return calendar.date(byAdding: .second, value: secondsToAdd, to: base)

        case .minute:
            let allowedRange = calendar.range(of: .minute, in: .hour, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentMinutes = calendar.component(.minute, from: base)
            let minutesToAdd = value - currentMinutes
            return calendar.date(byAdding: .minute, value: minutesToAdd, to: base)

        case .hour:
            let allowedRange = calendar.range(of: .hour, in: .day, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentHour = calendar.component(.hour, from: base)
            let hoursToAdd = value - currentHour
            return calendar.date(byAdding: .hour, value: hoursToAdd, to: base)

        case .day:
            let allowedRange = calendar.range(of: .day, in: .month, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentDay = calendar.component(.day, from: base)
            let daysToAdd = value - currentDay
            return calendar.date(byAdding: .day, value: daysToAdd, to: base)

        case .month:
            let allowedRange = calendar.range(of: .month, in: .year, for: base)!
            guard allowedRange.contains(value) else { return nil }
            let currentMonth = calendar.component(.month, from: base)
            let monthsToAdd = value - currentMonth
            return calendar.date(byAdding: .month, value: monthsToAdd, to: base)

        case .year:
            guard value > 0 else { return nil }
            let currentYear = calendar.component(.year, from: base)
            let yearsToAdd = value - currentYear
            return calendar.date(byAdding: .year, value: yearsToAdd, to: base)

        default:
            return calendar.date(bySetting: component, value: value, of: base)
        }
    }

#if !os(Linux)
    // swiftlint:enable cyclomatic_complexity, function_body_length

    /// ReerKit: Date at the beginning of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:14 PM"
    ///     let date2 = date.beginning(of: .hour) // "Jan 12, 2017, 7:00 PM"
    ///     let date3 = date.beginning(of: .month) // "Jan 1, 2017, 12:00 AM"
    ///     let date4 = date.beginning(of: .year) // "Jan 1, 2017, 12:00 AM"
    ///
    /// - Parameter component: calendar component to get date at the beginning of.
    /// - Returns: date at the beginning of calendar component (if applicable).
    func beginning(of component: Calendar.Component) -> Date? {
        if component == .day {
            return calendar.startOfDay(for: base)
        }

        var components: Set<Calendar.Component> {
            switch component {
            case .second:
                return [.year, .month, .day, .hour, .minute, .second]

            case .minute:
                return [.year, .month, .day, .hour, .minute]

            case .hour:
                return [.year, .month, .day, .hour]

            case .weekOfYear, .weekOfMonth:
                return [.yearForWeekOfYear, .weekOfYear]

            case .month:
                return [.year, .month]

            case .year:
                return [.year]

            default:
                return []
            }
        }

        guard !components.isEmpty else { return nil }
        return calendar.date(from: calendar.dateComponents(components, from: base))
    }
#endif

    // swiftlint:disable function_body_length
    /// ReerKit: Date at the end of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:27 PM"
    ///     let date2 = date.end(of: .day) // "Jan 12, 2017, 11:59 PM"
    ///     let date3 = date.end(of: .month) // "Jan 31, 2017, 11:59 PM"
    ///     let date4 = date.end(of: .year) // "Dec 31, 2017, 11:59 PM"
    ///
    /// - Parameter component: calendar component to get date at the end of.
    /// - Returns: date at the end of calendar component (if applicable).
    func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = adding(.second, value: 1)
            date = calendar.date(
                from: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            )!
            date.re.add(.second, value: -1)
            return date

        case .minute:
            var date = adding(.minute, value: 1)
            let after = calendar.date(
                from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            )!
            date = after.re.adding(.second, value: -1)
            return date

        case .hour:
            var date = adding(.hour, value: 1)
            let after = calendar.date(
                from: calendar.dateComponents([.year, .month, .day, .hour], from: date)
            )!
            date = after.re.adding(.second, value: -1)
            return date

        case .day:
            var date = adding(.day, value: 1)
            date = calendar.startOfDay(for: date)
            date.re.add(.second, value: -1)
            return date

        case .weekOfYear, .weekOfMonth:
            var date = base
            let beginningOfWeek = calendar.date(
                from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
            )!
            date = beginningOfWeek.re.adding(.day, value: 7).re.adding(.second, value: -1)
            return date

        case .month:
            var date = adding(.month, value: 1)
            let after = calendar.date(
                from: calendar.dateComponents([.year, .month], from: date)
            )!
            date = after.re.adding(.second, value: -1)
            return date

        case .year:
            var date = adding(.year, value: 1)
            let after = calendar.date(
                from: calendar.dateComponents([.year], from: date)
            )!
            date = after.re.adding(.second, value: -1)
            return date

        default:
            return nil
        }
    }

    // swiftlint:enable function_body_length

    /// ReerKit: Check if date is in current given calendar component.
    ///
    ///     Date().isInCurrent(.day) -> true
    ///     Date().isInCurrent(.year) -> true
    ///
    /// - Parameter component: calendar component to check.
    /// - Returns: true if date is in current given calendar component.
    func isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(base, equalTo: Date(), toGranularity: component)
    }

    /// ReerKit: Date string from date.
    ///
    ///     Date().string(withFormat: "dd/MM/yyyy") -> "1/12/17"
    ///     Date().string(withFormat: "HH:mm") -> "23:50"
    ///     Date().string(withFormat: "dd/MM/yyyy HH:mm") -> "1/12/17 23:50"
    ///
    /// - Parameter format: Date format (default is "dd/MM/yyyy").
    /// - Returns: date string.
    func string(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: base)
    }

    /// ReerKit: Date string from date.
    ///
    ///     Date().dateString(ofStyle: .short) -> "1/12/17"
    ///     Date().dateString(ofStyle: .medium) -> "Jan 12, 2017"
    ///     Date().dateString(ofStyle: .long) -> "January 12, 2017"
    ///     Date().dateString(ofStyle: .full) -> "Thursday, January 12, 2017"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date string.
    func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: base)
    }

    /// ReerKit: Date and time string from date.
    ///
    ///     Date().dateTimeString(ofStyle: .short) -> "1/12/17, 7:32 PM"
    ///     Date().dateTimeString(ofStyle: .medium) -> "Jan 12, 2017, 7:32:00 PM"
    ///     Date().dateTimeString(ofStyle: .long) -> "January 12, 2017 at 7:32:00 PM GMT+3"
    ///     Date().dateTimeString(ofStyle: .full) -> "Thursday, January 12, 2017 at 7:32:00 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date and time string.
    func dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: base)
    }

    /// ReerKit: Time string from date.
    ///
    ///     Date().timeString(ofStyle: .short) -> "7:37 PM"
    ///     Date().timeString(ofStyle: .medium) -> "7:37:02 PM"
    ///     Date().timeString(ofStyle: .long) -> "7:37:02 PM GMT+3"
    ///     Date().timeString(ofStyle: .full) -> "7:37:02 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: time string.
    func timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: base)
    }

    /// ReerKit: Day name from date.
    ///
    ///     Date().dayName(ofStyle: .oneLetter) -> "T"
    ///     Date().dayName(ofStyle: .threeLetters) -> "Thu"
    ///     Date().dayName(ofStyle: .full) -> "Thursday"
    ///
    /// - Parameter Style: style of day name (default is NameStyle.full).
    /// - Returns: day name string (example: W, Wed, Wednesday).
    func dayName(ofStyle style: Date.NameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "EEEEE"
            case .threeLetters:
                return "EEE"
            case .full:
                return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: base)
    }

    /// ReerKit: Month name from date.
    ///
    ///     Date().monthName(ofStyle: .oneLetter) -> "J"
    ///     Date().monthName(ofStyle: .threeLetters) -> "Jan"
    ///     Date().monthName(ofStyle: .full) -> "January"
    ///
    /// - Parameter Style: style of month name (default is NameStyle.full).
    /// - Returns: month name string (example: D, Dec, December).
    func monthName(ofStyle style: Date.NameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
            case .oneLetter:
                return "MMMMM"
            case .threeLetters:
                return "MMM"
            case .full:
                return "MMMM"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: base)
    }

    /// ReerKit: get number of seconds between two date
    ///
    /// - Parameter date: date to compare self to.
    /// - Returns: number of seconds between self and given date.
    func secondsSince(_ date: Date) -> Double {
        return base.timeIntervalSince(date)
    }

    /// ReerKit: get number of minutes between two date
    ///
    /// - Parameter date: date to compare self to.
    /// - Returns: number of minutes between self and given date.
    func minutesSince(_ date: Date) -> Double {
        return base.timeIntervalSince(date) / 60
    }

    /// ReerKit: get number of hours between two date
    ///
    /// - Parameter date: date to compare self to.
    /// - Returns: number of hours between self and given date.
    func hoursSince(_ date: Date) -> Double {
        return base.timeIntervalSince(date) / 3600
    }

    /// ReerKit: get number of days between two date
    ///
    /// - Parameter date: date to compare self to.
    /// - Returns: number of days between self and given date.
    func daysSince(_ date: Date) -> Double {
        return base.timeIntervalSince(date) / (3600 * 24)
    }

    /// ReerKit: check if a date is between two other dates.
    ///
    /// - Parameters:
    ///   - startDate: start date to compare self to.
    ///   - endDate: endDate date to compare self to.
    ///   - includeBounds: true if the start and end date should be included (default is false).
    /// - Returns: true if the date is between the two given dates.
    func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(base).rawValue * base.compare(endDate).rawValue >= 0
        }
        return startDate.compare(base).rawValue * base.compare(endDate).rawValue > 0
    }

    /// ReerKit: check if a date is a number of date components of another date.
    ///
    /// - Parameters:
    ///   - value: number of times component is used in creating range.
    ///   - component: Calendar.Component to use.
    ///   - date: Date to compare self to.
    /// - Returns: true if the date is within a number of components of another date.
    func isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = calendar.dateComponents([component], from: base, to: date)
        let componentValue = components.value(for: component)!
        return abs(componentValue) <= value
    }

    /// ReerKit: Returns a random date within the specified range.
    ///
    /// - Parameter range: The range in which to create a random date. `range` must not be empty.
    /// - Returns: A random date within the bounds of `range`.
    static func random(in range: Range<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
                        TimeInterval
            .random(in: range.lowerBound.timeIntervalSinceReferenceDate..<range.upperBound
                .timeIntervalSinceReferenceDate))
    }

    /// ReerKit: Returns a random date within the specified range.
    ///
    /// - Parameter range: The range in which to create a random date.
    /// - Returns: A random date within the bounds of `range`.
    static func random(in range: ClosedRange<Date>) -> Date {
        let interval = TimeInterval.random(
            in: range.lowerBound.timeIntervalSinceReferenceDate...range.upperBound.timeIntervalSinceReferenceDate
        )
        return Date(timeIntervalSinceReferenceDate: interval)
    }

    /// ReerKit: Returns a random date within the specified range, using the given generator as a source for randomness.
    ///
    /// - Parameters:
    ///   - range: The range in which to create a random date. `range` must not be empty.
    ///   - generator: The random number generator to use when creating the new random date.
    /// - Returns: A random date within the bounds of `range`.
    static func random<T>(in range: Range<Date>, using generator: inout T) -> Date where T: RandomNumberGenerator {
        let interval = TimeInterval.random(
            in: range.lowerBound.timeIntervalSinceReferenceDate..<range.upperBound.timeIntervalSinceReferenceDate,
            using: &generator
        )
        return Date(timeIntervalSinceReferenceDate: interval)
    }

    /// ReerKit: Returns a random date within the specified range, using the given generator as a source for randomness.
    ///
    /// - Parameters:
    ///   - range: The range in which to create a random date.
    ///   - generator: The random number generator to use when creating the new random date.
    /// - Returns: A random date within the bounds of `range`.
    static func random<T>(in range: ClosedRange<Date>, using generator: inout T) -> Date
    where T: RandomNumberGenerator {
        let interval = TimeInterval.random(
            in: range.lowerBound.timeIntervalSinceReferenceDate...range.upperBound.timeIntervalSinceReferenceDate,
            using: &generator
        )
        return Date(timeIntervalSinceReferenceDate: interval)
    }
}

extension Date: ReerReferenceCompatible {}
public extension ReerReference where Base == Date {
    /// ReerKit: Add calendar component to date.
    ///
    ///     var date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     date.add(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     date.add(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     date.add(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     date.add(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of component to add.
    mutating func add(_ component: Calendar.Component, value: Int) {
        if let date = base.pointee.re.calendar.date(byAdding: component, value: value, to: base.pointee) {
            base.pointee = date
        }
    }
}

// MARK: - Initializers

public extension Date {
    /// ReerKit: Create a new date form calendar components.
    ///
    ///     let date = Date(year: 2010, month: 1, day: 12) // "Jan 12, 2010, 7:45 PM"
    ///
    /// - Parameters:
    ///   - calendar: Calendar (default is current).
    ///   - timeZone: TimeZone (default is current).
    ///   - era: Era (default is current era).
    ///   - year: Year (default is current year).
    ///   - month: Month (default is current month).
    ///   - day: Day (default is today).
    ///   - hour: Hour (default is current hour).
    ///   - minute: Minute (default is current minute).
    ///   - second: Second (default is current second).
    ///   - nanosecond: Nanosecond (default is current nanosecond).
    static func re(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = NSTimeZone.default,
        era: Int? = Date().re.era,
        year: Int? = Date().re.year,
        month: Int? = Date().re.month,
        day: Int? = Date().re.day,
        hour: Int? = Date().re.hour,
        minute: Int? = Date().re.minute,
        second: Int? = Date().re.second,
        nanosecond: Int? = Date().re.nanosecond
    ) -> Date? {
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timeZone
        components.era = era
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond

        return calendar?.date(from: components)
    }

    /// ReerKit: Create date object from ISO8601 string.
    ///
    ///     let date = Date(iso8601String: "2017-01-12T16:48:00.959Z") // "Jan 12, 2017, 7:48 PM"
    ///
    /// - Parameter iso8601String: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSSZ).
    static func re(iso8601String: String) -> Date? {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: iso8601String)
    }

    /// ReerKit: Create new date object from UNIX timestamp.
    ///
    ///     let date = Date(unixTimestamp: 1484239783.922743) // "Jan 12, 2017, 7:49 PM"
    ///
    /// - Parameter unixTimestamp: UNIX timestamp.
    static func re(unixTimestamp: Double) -> Date {
        return Date(timeIntervalSince1970: unixTimestamp)
    }

    /// ReerKit: Create date object from Int literal.
    ///
    ///     let date = Date(integerLiteral: 2017_12_25) // "2017-12-25 00:00:00 +0000"
    /// - Parameter value: Int value, e.g. 20171225, or 2017_12_25 etc.
    static func re(integerLiteral value: Int) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.date(from: String(value))
    }
}

#endif
