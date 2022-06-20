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
        
        view.re.x = 1
        view.re.y = 2
        view.re.width = 3
        view.re.height = 3
        
        XCTAssertEqual(view.re.x, 1)
        XCTAssertEqual(view.re.y, 2)
        XCTAssertEqual(view.re.width, 3)
        XCTAssertEqual(view.re.height, 3)
        
        view.re.left = 5
        view.re.right = 6
        view.re.top = 7
        view.re.bottom = 8
        XCTAssertEqual(view.re.left, 3)
        XCTAssertEqual(view.re.right, 6)
        XCTAssertEqual(view.re.top, 5)
        XCTAssertEqual(view.re.bottom, 8)
        
        let origin = CGPoint(x: 11, y: 22)
        let size = CGSize(width: 33, height: 44)
        view.re.origin = origin
        view.re.size = size
        XCTAssertEqual(view.re.origin, origin)
        XCTAssertEqual(view.re.size, size)
        
        view.re.centerX = 100
        view.re.centerY = 200
        XCTAssertEqual(view.re.centerX, 100)
        XCTAssertEqual(view.re.centerY, 200)
    }

}
