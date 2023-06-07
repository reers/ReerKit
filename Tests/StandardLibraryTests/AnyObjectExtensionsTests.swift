//
//  AnyObjectExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/7/18.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class TestAnyObject {}
extension TestAnyObject: AnyObjectExtensionable {}

extension TestAnyObject {
    @objc var foo: String {
        get {
            re.associatedValue(forKey: AssociationKey(#function as StaticString), default: "123")
        }
        set {
            re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString))
        }
    }
}
class AnyObjectExtensionsTests: XCTestCase {

    func testAssociation() {
        let obj = TestAnyObject()
        let key = AssociationKey("bar" as StaticString)
        XCTAssertEqual(obj.re.associatedValue(forKey: key, default: 11), 11)
        obj.re.setAssociatedValue(22, forKey: key)
        XCTAssertEqual(obj.re.associatedValue(forKey: key, default: 11), 22)
        
        let string: String? = obj.re.associatedValue(forKey: key)
        XCTAssertNil(string)
        
        XCTAssertEqual(obj.re.associatedValue(forKey: key), 22)
        obj.re.setAssociatedValue(nil, forKey: key)
        XCTAssertNil(obj.re.associatedValue(forKey: key))
        
        let closure = {
            return "11"
        }
        obj.re.setAssociatedValue(closure, forKey: key, withPolicy: .retain)
        let ret = obj.re.associatedValue(forKey: key) as (() -> String)?
        XCTAssertEqual(ret?(), "11")
        
        obj.re.setAssociatedWeakObject(NSObject(), forKey: key)
        let object = obj.re.associatedWeakObject(forKey: key) as NSObject?
        XCTAssertNil(object)
        
        let aObject = NSObject()
        obj.re.setAssociatedWeakObject(aObject, forKey: key)
        let objectRet = obj.re.associatedWeakObject(forKey: key) as NSObject?
        XCTAssertNotNil(objectRet)
        
        let abc = TestAnyObject()
        XCTAssertEqual(abc.foo, "123")
        abc.foo = "abc"
        XCTAssertEqual(abc.foo, "abc")
    }
    
    func testOnce() {
        let obj = TestAnyObject()
        let key = OnceKey()
        var result = 0
        func test() {
            obj.re.executeOnce(byKey: key) {
                result += 1
            }
        }
        test()
        test()
        obj.re.executeOnce(byKey: key) {
            result += 1
        }
        XCTAssertEqual(result, 1)
    }
    
    func testSwizzle() {
        class TestSwizzle: TestAnyObject {
            @objc
            dynamic func test() -> Int {
                return 1
            }
            
            @objc
            func swizzled_test() -> Int {
                return 2
            }
            
            @objc
            dynamic static func classMethodTest() -> Int {
                return 1
            }
            
            @objc static func swizzled_classMethodTest() -> Int {
                return 2
            }
        }
        
        TestSwizzle.re.swizzleInstanceMethod(#selector(TestSwizzle.test), with: #selector(TestSwizzle.swizzled_test))
        XCTAssertEqual(TestSwizzle().test(), 2)
        TestSwizzle.re.swizzleInstanceMethod(#selector(TestSwizzle.test), with: #selector(TestSwizzle.swizzled_test))
        XCTAssertEqual(TestSwizzle().test(), 1)
        
        TestSwizzle.re.swizzleClassMethod(#selector(TestSwizzle.classMethodTest), with: #selector(TestSwizzle.swizzled_classMethodTest))
        XCTAssertEqual(TestSwizzle.classMethodTest(), 2)
        TestSwizzle.re.swizzleClassMethod(#selector(TestSwizzle.classMethodTest), with: #selector(TestSwizzle.swizzled_classMethodTest))
        XCTAssertEqual(TestSwizzle.classMethodTest(), 1)
    }
    
    func testDeinitObservable() {
        let expectation = self.expectation(description: "testDeinitObservable")
        var result = 0
        var foo: TestAnyObject? = TestAnyObject()
        
        foo?.re.onDeinit {
            result += 1
        }
        
        foo?.re.onDeinit {
            result += 1
        }

        RETimer.after(0.5) {
            foo = nil
        }
        
        RETimer.after(1) {
            XCTAssertEqual(result, 2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.5, handler: nil)
    }
}
