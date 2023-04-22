//
//  UITextFieldExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class UITextFieldExtensionsTests: XCTestCase {
    func testIsEmpty() {
        let textField = UITextField()
        XCTAssert(textField.re.isEmpty)
        textField.text = "Hello"
        XCTAssertFalse(textField.re.isEmpty)
        textField.text = nil
        XCTAssert(textField.re.isEmpty)
    }

    func testTrimmedText() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let textField = UITextField(frame: frame)
        textField.text = "Hello \n    \n"
        XCTAssertNotNil(textField.re.trimmedText)
        XCTAssertEqual(textField.re.trimmedText!, "Hello")
    }

    func testTextType() {
        let tf1 = UITextField(frame: .zero)
        tf1.re.textType = .emailAddress
        XCTAssertEqual(tf1.re.textType, .emailAddress)
        XCTAssertEqual(tf1.keyboardType, .emailAddress)
        XCTAssertEqual(tf1.autocorrectionType, .no)
        XCTAssertEqual(tf1.autocapitalizationType, .none)
        XCTAssertFalse(tf1.isSecureTextEntry)
        XCTAssertEqual(tf1.placeholder, "Email Address")

        let tf2 = UITextField(frame: .zero)
        tf2.re.textType = .password
        XCTAssertEqual(tf2.re.textType, .password)
        XCTAssertEqual(tf2.keyboardType, .asciiCapable)
        XCTAssertEqual(tf2.autocorrectionType, .no)
        XCTAssertEqual(tf2.autocapitalizationType, .none)
        XCTAssert(tf2.isSecureTextEntry)
        XCTAssertEqual(tf2.placeholder, "Password")

        let tf3 = UITextField(frame: .zero)
        tf3.re.textType = .generic
        XCTAssertEqual(tf3.re.textType, .generic)
        XCTAssertFalse(tf3.isSecureTextEntry)
    }

    func testHasValidEmail() {
        let textField = UITextField(frame: .zero)
        textField.text = "john@doe.com"
        XCTAssert(textField.re.hasValidEmail)
        textField.text = "ReerKit"
        XCTAssertFalse(textField.re.hasValidEmail)
        textField.text = nil
        XCTAssertFalse(textField.re.hasValidEmail)
    }

    func testLeftViewTintColor() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let textField = UITextField(frame: frame)

        let imageView = UIImageView()
        imageView.tintColor = .red

        textField.leftView = imageView
        XCTAssertEqual(textField.re.leftViewTintColor, .red)

        textField.re.leftViewTintColor = .blue
        XCTAssertEqual(textField.re.leftViewTintColor, .blue)

        textField.leftView = nil
        XCTAssertNil(textField.re.leftViewTintColor)

        textField.re.leftViewTintColor = .yellow
        XCTAssertNil(textField.re.leftViewTintColor)
    }

    func testRightViewTintColor() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let textField = UITextField(frame: frame)

        let imageView = UIImageView()
        imageView.tintColor = .red

        textField.rightView = imageView
        XCTAssertEqual(textField.re.rightViewTintColor, .red)

        textField.re.rightViewTintColor = .blue
        XCTAssertEqual(textField.re.rightViewTintColor, .blue)

        textField.rightView = nil
        XCTAssertNil(textField.re.rightViewTintColor)

        textField.re.rightViewTintColor = .yellow
        XCTAssertNil(textField.re.rightViewTintColor)
    }

    func testClear() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let textField = UITextField(frame: frame)
        textField.text = "Hello"
        textField.re.clear()
        XCTAssertEqual(textField.text!, "")
    }

    func testSetPlaceHolderTextColor() {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Attributed Placeholder")
        textField.re.setPlaceHolderTextColor(.blue)
        let color = textField.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        XCTAssertEqual(color, .blue)

        textField.placeholder = nil
        textField.re.setPlaceHolderTextColor(.yellow)
        let emptyColor = textField.attributedPlaceholder?.attribute(
            .foregroundColor,
            at: 0,
            effectiveRange: nil) as? UIColor
        XCTAssertNil(emptyColor)
    }

    func testAddPaddingLeft() {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        textfield.re.addPaddingLeft(40)
        XCTAssertEqual(textfield.leftView?.frame.width, 40)
    }

    func testAddPaddingRight() {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        textfield.re.addPaddingRight(40)
        XCTAssertEqual(textfield.rightView?.frame.width, 40)
    }

    func testAddPaddingImageLeftIcon() {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 0, y: 0, width: 100, height: 44)

        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        textfield.re.addPaddingLeftIcon(image, padding: 5)
        XCTAssertEqual(textfield.leftView?.frame.width, image.size.width + 5)
    }

    func testAddPaddingImageRightIcon() {
        let textfield = UITextField()
        textfield.frame = CGRect(x: 0, y: 0, width: 100, height: 44)

        let bundle = Bundle(for: UIImageExtensionsTests.self)
        let image = UIImage(named: "TestImage", in: bundle, compatibleWith: nil)!
        textfield.re.addPaddingRightIcon(image, padding: 5)
        XCTAssertEqual(textfield.rightView?.frame.width, image.size.width + 5)
    }

    #if os(iOS)
    func testAddToolbar() {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        
        textField.re.addToolbar(items: [doneBarButtonItem, addBarButtonItem])
        
        guard let toolBar = textField.inputAccessoryView as? UIToolbar else {
            XCTFail("Expecting toolbar added to textfield accessory view")
            return
        }
        
        guard let doneBarButton = toolBar.items?.first,
              let addBarButton = toolBar.items?[1] else {
            XCTFail("Expecting done and add bar button added to textfield accessory view")
            return
        }
        XCTAssertEqual(doneBarButton, doneBarButtonItem)
        XCTAssertEqual(addBarButton, addBarButtonItem)
    }
    #endif
}

#endif

