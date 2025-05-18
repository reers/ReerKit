//
//  CAAnimationExtensionsTests.swift
//  ReerKit
//
//  Created by Zero_D_Saber on 2025/4/29.
//  Copyright © 2025 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(QuartzCore)

final class CAAnimationExtensionsTests: XCTestCase {
    private lazy var view = UIView()
    
    private lazy var scaleAnimation = {
        let a = CABasicAnimation()
        a.fromValue = 0
        a.toValue = 1
        a.duration = 0.25
        a.keyPath = "transform.scale"
        return a
    }()
    
    func testAnimation() {
        let exp = expectation(description: "doAnimation")
        
        var count = 0
        
        scaleAnimation.re
            .onStart { animation in
                count += 1
                XCTAssertEqual(count, 1)
            }
            .onStop { _, _ in
                count -= 1
                XCTAssertEqual(count, 1)
            }
        
        scaleAnimation.re
            .onStart { animation in
                count += 1
                XCTAssertEqual(count, 2)
            }
            .onStop { _, _ in
                count -= 1
                XCTAssertEqual(count, 0)
            }
            .onStop { _, _ in
                count -= 1
                XCTAssertEqual(count, -1)
                
                exp.fulfill()
            }
        
        view.layer.add(scaleAnimation, forKey: "scale")
        
        waitForExpectations(timeout: 5)
    }
}

#endif
