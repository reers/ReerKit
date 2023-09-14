//
//  UIButtonExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/19.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UIButtonExtensionsTests: XCTestCase {
    func testImageForDisabled() {
        let button = UIButton()
        XCTAssertEqual(button.re.imageForDisabled, button.image(for: .disabled))

        let newImage = UIImage()
        button.re.imageForDisabled = newImage
        XCTAssertEqual(button.re.imageForDisabled, newImage)
    }

    func testImageForHighlighted() {
        let button = UIButton()
        XCTAssertEqual(button.re.imageForHighlighted, button.image(for: .highlighted))

        let newImage = UIImage()
        button.re.imageForHighlighted = newImage
        XCTAssertEqual(button.re.imageForHighlighted, newImage)
    }

    func testImageForNormal() {
        let button = UIButton()
        XCTAssertEqual(button.re.imageForNormal, button.image(for: .normal))

        let newImage = UIImage()
        button.re.imageForNormal = newImage
        XCTAssertEqual(button.re.imageForNormal, newImage)
    }

    func testImageForSelected() {
        let button = UIButton()
        XCTAssertEqual(button.re.imageForSelected, button.image(for: .selected))

        let newImage = UIImage()
        button.re.imageForSelected = newImage
        XCTAssertEqual(button.re.imageForSelected, newImage)
    }

    func testImageForFocused() {
        let button = UIButton()
        XCTAssertEqual(button.re.imageForFocused, button.image(for: .focused))

        let newImage = UIImage()
        button.re.imageForFocused = newImage
        XCTAssertEqual(button.re.imageForFocused, newImage)
    }
    
    func testTitleColorForDisabled() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleColorForDisabled, button.titleColor(for: .disabled))

        button.re.titleColorForDisabled = .green
        XCTAssertEqual(button.re.titleColorForDisabled, .green)
    }

    func testTitleColorForHighlighted() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleColorForHighlighted, button.titleColor(for: .highlighted))

        button.re.titleColorForHighlighted = .green
        XCTAssertEqual(button.re.titleColorForHighlighted, .green)
    }

    func testTitleColorForNormal() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleColorForNormal, button.titleColor(for: .normal))

        button.re.titleColorForNormal = .green
        XCTAssertEqual(button.re.titleColorForNormal, .green)
    }

    func testTitleColorForSelected() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleColorForSelected, button.titleColor(for: .selected))

        button.re.titleColorForSelected = .green
        XCTAssertEqual(button.re.titleColorForSelected, .green)
    }

    func testTitleColorForFocused() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleColorForFocused, button.titleColor(for: .focused))

        button.re.titleColorForFocused = .green
        XCTAssertEqual(button.re.titleColorForFocused, .green)
    }
    
    func testTitleForDisabled() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleForDisabled, button.title(for: .disabled))

        let title = "Disabled"
        button.re.titleForDisabled = title
        XCTAssertEqual(button.re.titleForDisabled, title)
    }

    func testTitleForHighlighted() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleForHighlighted, button.title(for: .highlighted))

        let title = "Highlighted"
        button.re.titleForHighlighted = title
        XCTAssertEqual(button.re.titleForHighlighted, title)
    }

    func testTitleForNormal() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleForNormal, button.title(for: .normal))

        let title = "Normal"
        button.re.titleForNormal = title
        XCTAssertEqual(button.re.titleForNormal, title)
    }

    func testTitleForSelected() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleForSelected, button.title(for: .selected))

        let title = "Selected"
        button.re.titleForSelected = title
        XCTAssertEqual(button.re.titleForSelected, title)
    }
    
    func testTitleForFocused() {
        let button = UIButton()
        XCTAssertEqual(button.re.titleForFocused, button.title(for: .focused))

        let title = "Focused"
        button.re.titleForFocused = title
        XCTAssertEqual(button.re.titleForFocused, title)
    }
    
    func testAttributedTitleForDisabled() {
        let button = UIButton()
        XCTAssertEqual(button.re.attributedTitleForDisabled, button.attributedTitle(for: .disabled))

        let title = NSAttributedString(string: "Disabled", attributes: [.foregroundColor:UIColor.yellow, .backgroundColor:UIColor.green])
        button.re.attributedTitleForDisabled = title
        XCTAssertEqual(button.re.attributedTitleForDisabled, title)
    }

    func testAttributedTitleForHighlighted() {
        let button = UIButton()
        XCTAssertEqual(button.re.attributedTitleForHighlighted, button.attributedTitle(for: .highlighted))

        let title = NSAttributedString(string: "Highlighted", attributes: [.foregroundColor:UIColor.yellow, .backgroundColor:UIColor.green])
        button.re.attributedTitleForHighlighted = title
        XCTAssertEqual(button.re.attributedTitleForHighlighted, title)
    }

    func testAttributedTitleForNormal() {
        let button = UIButton()
        XCTAssertEqual(button.re.attributedTitleForNormal, button.attributedTitle(for: .normal))

        let title = NSAttributedString(string: "Normal", attributes: [.foregroundColor:UIColor.yellow, .backgroundColor:UIColor.green])
        button.re.attributedTitleForNormal = title
        XCTAssertEqual(button.re.attributedTitleForNormal, title)
    }

    func testAttributedTitleForSelected() {
        let button = UIButton()
        XCTAssertEqual(button.re.attributedTitleForSelected, button.attributedTitle(for: .selected))

        let title = NSAttributedString(string: "Selected", attributes: [.foregroundColor:UIColor.yellow, .backgroundColor:UIColor.green])
        button.re.attributedTitleForSelected = title
        XCTAssertEqual(button.re.attributedTitleForSelected, title)
    }

    func testAttributedTitleForFocused() {
        let button = UIButton()
        XCTAssertEqual(button.re.attributedTitleForFocused, button.attributedTitle(for: .focused))

        let title = NSAttributedString(string: "Focused", attributes: [.foregroundColor:UIColor.yellow, .backgroundColor:UIColor.green])
        button.re.attributedTitleForFocused = title
        XCTAssertEqual(button.re.attributedTitleForFocused, title)
    }
    
    func testSetImageForAllStates() {
        let button = UIButton()
        let image = UIImage()
        button.re.setImageForAllStates(image)
        
        XCTAssertEqual(button.re.imageForDisabled, image)
        XCTAssertEqual(button.re.imageForHighlighted, image)
        XCTAssertEqual(button.re.imageForNormal, image)
        XCTAssertEqual(button.re.imageForSelected, image)
        XCTAssertEqual(button.re.imageForFocused, image)
    }

    func testSetTitleColorForAllStates() {
        let button = UIButton()
        let color = UIColor.green
        button.re.setTitleColorForAllStates(color)
        
        XCTAssertEqual(button.re.titleColorForDisabled, color)
        XCTAssertEqual(button.re.titleColorForHighlighted, color)
        XCTAssertEqual(button.re.titleColorForNormal, color)
        XCTAssertEqual(button.re.titleColorForSelected, color)
        XCTAssertEqual(button.re.titleColorForFocused, color)
    }

    func testSetTitleForAllStates() {
        let button = UIButton()
        let title = "Title"
        button.re.setTitleForAllStates(title)
        
        XCTAssertEqual(button.re.titleForDisabled, title)
        XCTAssertEqual(button.re.titleForHighlighted, title)
        XCTAssertEqual(button.re.titleForNormal, title)
        XCTAssertEqual(button.re.titleForSelected, title)
        XCTAssertEqual(button.re.titleForFocused, title)
    }
    
    func testSetAttrbiutedTitleForAllStates() {
        let button = UIButton()
        let title = NSAttributedString(string: "Title", attributes: [.foregroundColor:UIColor.yellow, .backgroundColor:UIColor.green])
        button.re.setAttributedTitleForAllStates(title)

        XCTAssertEqual(button.re.attributedTitleForDisabled, title)
        XCTAssertEqual(button.re.attributedTitleForHighlighted, title)
        XCTAssertEqual(button.re.attributedTitleForNormal, title)
        XCTAssertEqual(button.re.attributedTitleForSelected, title)
        XCTAssertEqual(button.re.attributedTitleForFocused, title)
    }
    
    func testSetBackgroundColorForState() {
//        let button = UIButton()
//        let color = UIColor.orange
//
//        button.re.setBackgroundColor(color: color, forState: .highlighted)
//
//        let highlightedBackgroundImage = button.backgroundImage(for: .highlighted)
//        let averageColor = highlightedBackgroundImage!.averageColor()!
//
//        XCTAssertEqual(averageColor, color, accuracy: 0.01)
    }
}

#endif

