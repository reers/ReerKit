//
//  OptionalExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/1.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest

@testable import ReerKit

class OptionalExtensionsTests: XCTestCase {

    func testOptional() {
        var s: String? = nil
        XCTAssertEqual(s.re.isNil, true)
        XCTAssertEqual(s.re.isValid, false)
        var temp = ""
        s.re.run { _ in temp = "sss" }
        XCTAssertNotEqual(temp, "sss")
        
        s = ""
        XCTAssertEqual(s.re.isNil, false)
        XCTAssertEqual(s.re.isValid, true)
        
        XCTAssertEqual(s.re.value(or: "111"), "")
        s = nil
        XCTAssertEqual(s.re.value(or: "111"), "111")
        
        s = "222"
        XCTAssertEqual(try s.re.value(throw: NSError()), "222")
        
        s.re.run { XCTAssertEqual($0, "222") }
        
        
        XCTAssertFalse(s.re.isEmpty)
        s = nil
        XCTAssertTrue(s.re.isEmpty)
        s = ""
        XCTAssertTrue(s.re.isEmpty)
        
        let age: String? = "123"
        let ret = age.re.run { value in
            return Int(value)
        }
        XCTAssertEqual(ret!, 123)
    }
    
    func testBool() {
        let a: Int? = 23
        let b: Int? = 0
        let c: String? = "no"
        let d: String? = "yes"
        let e: String? = "false"
        let f: String? = "true"
        let s: String? = "11"
        let g: Bool? = false
        let h: Bool? = true
        let obj: NSObject? = NSObject()
        let string: String? = "abc"
        let emptyString: String? = nil
        let any: Any = "YES"
        let number: NSNumber? = NSNumber(booleanLiteral: true)
        
        XCTAssertTrue(a.re.bool!)
        XCTAssertTrue(d.re.bool!)
        XCTAssertTrue(f.re.bool!)
        XCTAssertTrue(h.re.bool!)
        XCTAssertFalse(b.re.bool!)
        XCTAssertFalse(c.re.bool!)
        XCTAssertFalse(e.re.bool!)
        XCTAssertTrue(s.re.bool!)
        XCTAssertFalse(g.re.bool!)
        XCTAssertNil(obj.re.bool)
        XCTAssertNil(string.re.bool)
        XCTAssertNil(emptyString.re.bool)
        
        XCTAssertFalse(obj.re.boolValue)
        XCTAssertTrue(obj.re.boolValue(or: true))
        XCTAssertTrue(any~!.re.bool!)
        XCTAssertTrue(number.re.bool!)
    }
    
    func testInt() {
        let a: String? = "2"
        let b: String? = "2.2"
        let c: Double? = 2.2
        let d: Float? = 2.2
        let e: Bool? = true
        let f: Bool? = false
        let any: Any? = "2"
        let string: String? = "abc"
        
        
        XCTAssertEqual(a.re.int!, 2)
        XCTAssertEqual(b.re.int!, 2)
        XCTAssertEqual(c.re.int!, 2)
        XCTAssertEqual(d.re.int!, 2)
        XCTAssertEqual(e.re.int!, 1)
        XCTAssertEqual(f.re.int!, 0)
        XCTAssertEqual(any.re.intValue, 2)
        XCTAssertNil(string.re.int)
        XCTAssertEqual(string.re.intValue(or: 3), 3)
    }
    
    func testString() {
        let s: String? = "cc"
        let a: NSString? = "abc"
        let b: Int? = 2
        let x: UInt8? = 3
        let c: Double? = 2.2
        let d: Bool? = true
        let e: Bool? = false
        let f: Float? = 3.3
        let obj: NSObject? = NSObject()
        
        XCTAssertEqual(s.re.string!, "cc")
        XCTAssertEqual(a.re.string!, "abc")
        XCTAssertEqual(b.re.string!, "2")
        XCTAssertEqual(x.re.string!, "3")
        XCTAssertEqual(c.re.string!, "2.2")
        XCTAssertEqual(d.re.string!, "true")
        XCTAssertEqual(e.re.string!, "false")
        XCTAssertEqual(f.re.string!, "3.3")
        XCTAssertNil(obj.re.string)
        XCTAssertEqual(obj.re.stringValue(or: "obj"), "obj")
    }
    
    func testDouble() {
        let a: String? = "2"
        let b: String? = "2.2"
        let c: Double? = 2.2
        let d: Float? = 2.2
        let e: Bool? = true
        let f: Bool? = false
        let any: Any? = "2"
        let string: String? = "abc"
        
        
        XCTAssertEqual(a.re.double!, 2.0)
        XCTAssertEqual(b.re.double!, 2.2)
        XCTAssertEqual(c.re.double!, 2.2)
        XCTAssertEqual(d.re.double!, 2.2)
        XCTAssertEqual(e.re.double!, 1.0)
        XCTAssertEqual(f.re.double!, 0)
        XCTAssertEqual(any.re.doubleValue, 2.0)
        XCTAssertNil(string.re.double)
        XCTAssertEqual(string.re.doubleValue(or: 3.0), 3.0)
    }
    
    func testFloat() {
        let a: String? = "2"
        let b: String? = "2.2"
        let c: Double? = 2.2
        let d: Float? = 2.2
        let e: Bool? = true
        let f: Bool? = false
        let any: Any? = "2"
        let string: String? = "abc"
        
        
        XCTAssertEqual(a.re.float!, 2.0)
        XCTAssertEqual(b.re.float!, 2.2)
        XCTAssertEqual(c.re.float!, 2.2)
        XCTAssertEqual(d.re.float!, 2.2)
        XCTAssertEqual(e.re.float!, 1.0)
        XCTAssertEqual(f.re.float!, 0)
        XCTAssertEqual(any.re.floatValue, 2.0)
        XCTAssertNil(string.re.float)
        XCTAssertEqual(string.re.floatValue(or: 3.0), 3.0)
    }
    
    func testCGFloat() {
        let a: String? = "2"
        let b: String? = "2.2"
        let c: Double? = 2.2
        let d: Float? = 2.2
        let e: Bool? = true
        let f: Bool? = false
        let any: Any? = "2"
        let string: String? = "abc"
        
        
        XCTAssertEqual(a.re.cgFloat!, 2.0)
        XCTAssertEqual(b.re.cgFloat!, 2.2)
        XCTAssertEqual(c.re.cgFloat!, 2.2)
        XCTAssertEqual(d.re.cgFloat!, 2.2)
        XCTAssertEqual(e.re.cgFloat!, 1.0)
        XCTAssertEqual(f.re.cgFloat!, 0)
        XCTAssertEqual(any.re.cgFloatValue, 2.0)
        XCTAssertNil(string.re.cgFloat)
        XCTAssertEqual(string.re.cgFloatValue(or: 3.0), 3.0)
    }

    func testNonEmptyOperator() {
        let value: String? = ""
        XCTAssertEqual(value ?! "abc", "abc")

        let value1: String? = "123"
        XCTAssertEqual(value1 ?! "abc", "123")
    }

    func testOppositeOperator() {
        var value: Bool? = nil
        XCTAssertEqual(!value, nil)
        value = true
        XCTAssertFalse(!value!)
        value = false
        XCTAssertTrue(!value!)
    }

    func testAnyDictValue() {
        var value: Any? = ["abc": 123]
        XCTAssertEqual(value.re.anyDict!["abc"] as! Int, 123)
        XCTAssertEqual(value.re.anyDictValue["abc"] as! Int, 123)
        value = nil
        XCTAssertEqual((value.re.dictValue(or: ["bcd": 456]))["bcd"], 456)
    }

    func testAnyArrayValue() {
        var value: Any? = [123]
        XCTAssertEqual(value.re.anyArray![0] as! Int, 123)
        XCTAssertEqual(value.re.anyArrayValue[0] as! Int, 123)

        value = nil
        XCTAssertEqual(value.re.arrayValue(or: [123])[0], 123)
    }
}
