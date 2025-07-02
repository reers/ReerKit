//
//  PropertyWrappersTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/9/18.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

final class PropertyWrappersTests: XCTestCase {
    
    @Clamped(0...150)
    var age: Int = 0

    func testClamped() {
        age = -4
        XCTAssertEqual(age, 0)
        age = 200
        XCTAssertEqual(age, 150)
        age = 80
        XCTAssertEqual(age, 80)
    }
    
    @Trimmed
    var userName: String = ""
    
    func testTrimmed() {
        userName = "abc"
        XCTAssertEqual(userName, "abc")
        
        userName = " aaa "
        XCTAssertEqual(userName, "aaa")
        
        userName = " b bb \n"
        XCTAssertEqual(userName, "b bb")
    }
    
    @Rounded(rule: .down)
    var weight: Double = 0
    
    func testRounded() {
        weight = 90.4
        XCTAssertEqual(weight, 90)
        
        weight = -22.5
        XCTAssertEqual(weight, -23)
        
        weight = 0
        XCTAssertEqual(weight, 0)
    }
    
    @LazyResettable("Marshall")
    var bluetoothSpeaker: String?
    
    @LazyResettable({
        if true {
            return "iPhone"
        } else {
            return "xxx"
        }
    })
    var phone: String
    
    func testLazyResettable() {
        XCTAssertEqual(bluetoothSpeaker, "Marshall")
        bluetoothSpeaker = nil
        XCTAssertFalse($bluetoothSpeaker.isInitialized)
        bluetoothSpeaker = "Sony"
        XCTAssertEqual(bluetoothSpeaker, "Sony")
        XCTAssertTrue($bluetoothSpeaker.isInitialized)
        
        XCTAssertEqual(phone, "iPhone")
        XCTAssertTrue($phone.isInitialized)
        $phone.reset()
        XCTAssertFalse($phone.isInitialized)
        phone = "oppo"
        XCTAssertEqual(phone, "oppo")
    }

}
