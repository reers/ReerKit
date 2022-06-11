//
//  UIViewExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/6/12.
//

import XCTest
import UIKit
@testable import ReerKit

class UIViewExtensionsTests: XCTestCase {

    func testUIViewFrame() {
        let view = UIView()
        
        view.x = 1
        view.y = 2
        view.width = 3
        view.height = 3
        XCTAssertEqual(view.x, 1)
        XCTAssertEqual(view.y, 2)
        XCTAssertEqual(view.width, 3)
        XCTAssertEqual(view.height, 3)
        
        view.left = 5
        view.right = 6
        view.top = 7
        view.bottom = 8
        XCTAssertEqual(view.left, 3)
        XCTAssertEqual(view.right, 6)
        XCTAssertEqual(view.top, 5)
        XCTAssertEqual(view.bottom, 8)
        
        let origin = CGPoint(x: 11, y: 22)
        let size = CGSize(width: 33, height: 44)
        view.origin = origin
        view.size = size
        XCTAssertEqual(view.origin, origin)
        XCTAssertEqual(view.size, size)
        
        view.centerX = 100
        view.centerY = 200
        XCTAssertEqual(view.centerX, 100)
        XCTAssertEqual(view.centerY, 200)
    }

}
