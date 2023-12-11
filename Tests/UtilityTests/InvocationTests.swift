//
//  InvocationTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/12/11.
//  Copyright © 2023 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

class Test: NSObject {
    
    @objc 
    class func classMethodTest(name: String) -> String {
        print("classMethodTest.....")
        return name + "_returned"
    }
    
    @objc var name: String? {
        didSet {
            NSLog("didSetCalled")
        }
    }
    
    @objc
    func instanceMethodTest(name: String) -> String {
        print("instanceMethodTest....")
        return (name + "_returned")
    }
    
    @objc
    func add() {
        print("add")
    }
    
}

final class InvocationTests: XCTestCase {
    
    func testInstanceMethodWithoutParamsInvocation() {
        let sel = NSSelectorFromString("add")
        let obj = Test()
        if let sig = Invocation.instanceMethodSignatureForSelector(sel, of: obj) {
            let invocation = Invocation(signature: sig)
            invocation.setSelector(sel)
            invocation.invoke(withTarget: obj)
        }
    }
    
    func testClassMethodInvocation() {
        let sel = NSSelectorFromString("classMethodTestWithName:")

        if let sig = Invocation.classMethodSignatureForSelector(sel, of: Test.self) {
            let invocation = Invocation(signature: sig)
            invocation.setSelector(sel)
            var name: NSObjectProtocol = "classMethod" as NSObject
            invocation.setArgument(&name, atIndex: 2)
            invocation.retainArguments()
            invocation.invoke(withTarget: Test.self)
            var ret: Any = NSObject()
            invocation.getReturnValue(&ret)
            XCTAssertEqual(ret as! NSString, "classMethod_returned")
        }
    }
    func testInsatanceMethodInvocation() {
        let sel = NSSelectorFromString("instanceMethodTestWithName:")
        let obj = Test()
        if let sig = Invocation.instanceMethodSignatureForSelector(sel, of: obj) {
            let invocation = Invocation(signature: sig)
            invocation.setSelector(sel)
            var name: NSObjectProtocol = "instanceMethod" as NSObject
            invocation.setArgument(&name, atIndex: 2)
            invocation.retainArguments()
            invocation.invoke(withTarget: obj)
            var ret: Any = NSObject()
            invocation.getReturnValue(&ret)
            XCTAssertEqual(ret as! NSString, "instanceMethod_returned")
        }
    }
}
