//
//  TypeNameDescribableTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/21.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

struct Foo {
    struct TT {}
}

extension Foo.TT: TypeNameDescribable {}

enum Bar {
    case test
}
extension Bar: TypeNameDescribable {}

class TypeNameDescribableTests: XCTestCase {
    
    func testModuleName() {
        XCTAssertEqual(moduleName(), "ReerKit_iOSTests")
    }

    func testTypeName() {
        XCTAssertEqual(Foo.TT.fullTypeName, "ReerKit_iOSTests.Foo.TT")
        XCTAssertEqual(Foo.TT().fullTypeName, "ReerKit_iOSTests.Foo.TT")
        XCTAssertEqual(Foo.TT.typeName, "TT")
        XCTAssertEqual(Foo.TT().typeName, "TT")
        
        XCTAssertEqual(Bar.typeName, "Bar")
        XCTAssertEqual(Bar.test.typeName, "Bar")
        
        XCTAssertEqual(UIView.fullTypeName, "UIView")
        XCTAssertEqual(UIView().fullTypeName, "UIView")
    }
}
