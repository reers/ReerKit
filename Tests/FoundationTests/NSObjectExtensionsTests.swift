//
//  NSObjectExtensionsTests.swift
//  ReerKitTests
//
//  Created by phoenix on 2022/6/12.
//

import XCTest
import Foundation
@testable import ReerKit

fileprivate extension NSObject {
    @objc var foo: String {
        get {
            re.associatedValue(forKey: AssociationKey(#function as StaticString), default: "123")
        }
        set {
            re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString))
        }
    }
}

class NSObjectExtensionsTests: XCTestCase {

    func testOCClassName() {
        XCTAssertEqual(UIView().typeName, "UIView")
        XCTAssertEqual(UIView.typeName, "UIView")
    }

    func testAssociation() {
        let obj = NSObject()
        let key = AssociationKey("bar" as StaticString)
        XCTAssertEqual(obj.re.associatedValue(forKey: key, default: 11), 11)
        obj.re.setAssociatedValue(22, forKey: key)
        XCTAssertEqual(obj.re.associatedValue(forKey: key, default: 11), 22)
        
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
        
        XCTAssertEqual(aObject.foo, "123")
        aObject.foo = "abc"
        XCTAssertEqual(aObject.foo, "abc")
    }
    
    func testOnce() {
        let obj = NSObject()
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
        class TestSwizzle: NSObject {
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
}

