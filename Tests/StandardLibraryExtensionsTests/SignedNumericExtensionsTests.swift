//
//  SignedNumericExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/14.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class SignedNumericExtensionsTests: XCTestCase {

    func testString() {
        let number1: Double = -1.2
        XCTAssertEqual(number1.re.string, "-1.2")

        let number2: Float = 2.3
        XCTAssertEqual(number2.re.string, "2.3")
    }

    func testAsLocaleCurrency() {
        let number1: Double = 3.2
        XCTAssertEqual(number1.re.localeCurrency(), "$3.20")

        let number2 = Double(10.23)
        if let symbol = Locale.current.currencySymbol {
            XCTAssertNotNil(number2.re.localeCurrency()!)
            XCTAssert(number2.re.localeCurrency()!.contains(symbol))
        }
        XCTAssertNotNil(number2.re.localeCurrency()!)
        XCTAssert(number2.re.localeCurrency()!.contains("\(number2)"))

        let number3 = 10
        if let symbol = Locale.current.currencySymbol {
            XCTAssertNotNil(number3.re.localeCurrency())
            XCTAssert(number3.re.localeCurrency()!.contains(symbol))
        }
        XCTAssertNotNil(number3.re.localeCurrency())
        XCTAssert(number3.re.localeCurrency()!.contains("\(number3)"))
    }
    
    func testSpelledOutString() {
        XCTAssertEqual((12.32).re.spelledOutString(), "twelve point three two")
    }

}
