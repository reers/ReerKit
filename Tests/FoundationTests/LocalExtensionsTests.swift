//
//  LocalExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/4.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(Foundation)
import Foundation

final class LocaleExtensionsTests: XCTestCase {
    func testPosix() {
        let test: Locale = .re.posix
        XCTAssertEqual(test.identifier, "en_US_POSIX")
    }

    func testIs12HourTimeFormat() {
        let twelveHourLocale = Locale(identifier: "en")
        XCTAssert(twelveHourLocale.re.is12HourTimeFormat)

        let twentyFourLocale = Locale(identifier: "ru")
        XCTAssertFalse(twentyFourLocale.re.is12HourTimeFormat)
    }

    func testFlagEmoji() {
        XCTAssertEqual(Locale.re.flagEmoji(forRegionCode: "AC"), "🇦🇨")
        XCTAssertEqual(Locale.re.flagEmoji(forRegionCode: "ZW"), "🇿🇼")
        #if !os(Linux)
        XCTAssertNil(Locale.re.flagEmoji(forRegionCode: ""))
        XCTAssertNil(Locale.re.flagEmoji(forRegionCode: "ac"))
        #endif

        for regionCode in Locale.isoRegionCodes {
            XCTAssertNotNil(Locale.re.flagEmoji(forRegionCode: regionCode))
        }
    }
}

#endif
