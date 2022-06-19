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
}

