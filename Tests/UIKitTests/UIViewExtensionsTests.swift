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
    
    func testRoundedCorners() {
        let view = UIView()
        view.frame = .re(0, 0, 100, 100)
        view.backgroundColor = .red
        view.re.roundCorners(.allCorners, radius: 20)
        XCTAssertNotNil(view)
    }

    func testBorderColor() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.re.borderColor = nil
        XCTAssertNil(view.re.borderColor)
        view.re.borderColor = UIColor.red
        XCTAssertNotNil(view.layer.borderColor)
        XCTAssertEqual(view.re.borderColor!, UIColor.red)
        XCTAssertEqual(view.layer.borderColor!.re.uiColor, UIColor.red)
    }

    func testBorderWidth() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.re.borderWidth = 0
        XCTAssertEqual(view.layer.borderWidth, 0)

        view.re.borderWidth = 5
        XCTAssertEqual(view.re.borderWidth, 5)
    }

    func testCornerRadius() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        XCTAssertEqual(view.layer.cornerRadius, 0)

        view.re.cornerRadius = 50
        XCTAssertEqual(view.re.cornerRadius, 50)
    }

    func testFirstResponder() {
        // When there's no firstResponder
        XCTAssertNil(UIView().re.firstResponder)

        let window = UIWindow()

        // When self is firstResponder
        let txtView = UITextField(frame: CGRect.zero)
        window.addSubview(txtView)
        txtView.becomeFirstResponder()
        XCTAssert(txtView.re.firstResponder === txtView)

        // When a subview is firstResponder
        let superView = UIView()
        window.addSubview(superView)
        let subView = UITextField(frame: CGRect.zero)
        superView.addSubview(subView)
        subView.becomeFirstResponder()
        XCTAssert(superView.re.firstResponder === subView)

        // When you have to find recursively
        XCTAssert(window.re.firstResponder === subView)
    }

    func testHeight() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        XCTAssertEqual(view.re.height, 100)
        view.re.height = 150
        XCTAssertEqual(view.frame.size.height, 150)
    }

    func testIsRightToLeft() {
        let view = UIView()
        XCTAssertFalse(view.re.isRightToLeft)
    }

    func testRoundCorners() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.re.roundCorners([.allCorners], radius: 5.0)
    }

    func testShadowColor() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.layer.shadowColor = nil
        XCTAssertNil(view.re.shadowColor)
        view.re.shadowColor = UIColor.orange
        XCTAssertNotNil(view.layer.shadowColor!)
        XCTAssertEqual(view.re.shadowColor, UIColor.orange)
    }

    func testScreenshot() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.backgroundColor = .black
        let screenshot = view.re.snapshotImage
        XCTAssertNotNil(screenshot)

        let view2 = UIView()
        XCTAssertNil(view2.re.snapshotImage)
    }

    func testShadowOffset() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.layer.shadowOffset = CGSize.zero
        XCTAssertEqual(view.re.shadowOffset, CGSize.zero)
        let size = CGSize(width: 5, height: 5)
        view.re.shadowOffset = size
        XCTAssertEqual(view.layer.shadowOffset, size)
    }

    func testShadowOpacity() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.layer.shadowOpacity = 0
        XCTAssertEqual(view.re.shadowOpacity, 0)
        view.re.shadowOpacity = 0.5
        XCTAssertEqual(view.layer.shadowOpacity, 0.5)
    }

    func testShadowRadius() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.layer.shadowRadius = 0
        XCTAssertEqual(view.re.shadowRadius, 0)
        view.re.shadowRadius = 0.5
        XCTAssertEqual(view.layer.shadowRadius, 0.5)
    }

    func testAddShadow() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        view.re.addShadow(ofColor: .red, radius: 5.0, offset: .zero, opacity: 0.5)
        XCTAssertEqual(view.re.shadowColor, UIColor.red)
        XCTAssertEqual(view.re.shadowRadius, 5.0)
        XCTAssertEqual(view.re.shadowOffset, CGSize.zero)
        XCTAssertEqual(view.re.shadowOpacity, 0.5)
    }

    func testSize() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        XCTAssertEqual(view.re.size, view.frame.size)

        view.re.size = CGSize(width: 50, height: 50)
        XCTAssertEqual(view.frame.size.width, 50)
        XCTAssertEqual(view.frame.size.height, 50)
    }

    func testParentViewController() {
        let viewController = UIViewController()
        XCTAssertNotNil(viewController.view.re.viewController)
        XCTAssertEqual(viewController.view.re.viewController, viewController)

        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        XCTAssertNil(view.re.viewController)
    }

    func testX() {
        let frame = CGRect(x: 20, y: 20, width: 100, height: 100)
        let view = UIView(frame: frame)
        XCTAssertEqual(view.re.x, 20)
        view.re.x = 10
        XCTAssertEqual(view.frame.origin.x, 10)
    }

    func testY() {
        let frame = CGRect(x: 20, y: 20, width: 100, height: 100)
        let view = UIView(frame: frame)
        XCTAssertEqual(view.re.y, 20)
        view.re.y = 10
        XCTAssertEqual(view.frame.origin.y, 10)
    }

    func testWidth() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        XCTAssertEqual(view.re.width, 100)
        view.re.width = 150
        XCTAssertEqual(view.frame.size.width, 150)
    }

    func testAddSubviews() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        XCTAssertEqual(view.subviews.count, 0)

        view.re.addSubviews([UIView(), UIView()])
        XCTAssertEqual(view.subviews.count, 2)
    }

    func testFadeIn() {
        let view1 = UIView()
        view1.isHidden = true
        view1.alpha = 0

        view1.re.fadeIn(duration: 0, completion: nil)
        XCTAssertFalse(view1.isHidden)
        XCTAssertEqual(view1.alpha, 1)

        let fadeInExpectation = expectation(description: "Faded in")

        let view2 = UIView()
        view2.alpha = 0
        XCTAssertFalse(view1.isHidden)

        view2.re.fadeIn(duration: 0.5) { _ in
            fadeInExpectation.fulfill()
        }

        XCTAssertEqual(view2.alpha, 1)
        waitForExpectations(timeout: 0.5)
    }

    func testFadeOut() {
        let view1 = UIView()
        view1.isHidden = true

        view1.re.fadeOut(duration: 0, completion: nil)
        XCTAssertFalse(view1.isHidden)
        XCTAssertEqual(view1.alpha, 0)

        let fadeOutExpectation = expectation(description: "Faded out")

        let view2 = UIView()
        XCTAssertFalse(view1.isHidden)

        view2.re.fadeOut(duration: 0.5) { _ in
            fadeOutExpectation.fulfill()
        }
        XCTAssertEqual(view2.alpha, 0)
        waitForExpectations(timeout: 0.5)
    }

    
    #if os(tvOS)
    func testLoadFromNib() {
        let bundle = Bundle(for: UIViewExtensionsTests.self)
        XCTAssertNotNil(UIView.loadFromNib(named: "UIImageViewTvOS", bundle: bundle))
    }
    #else
    func testLoadFromNib() {
        let bundle = Bundle(for: UIViewExtensionsTests.self)
        XCTAssertNotNil(UIView.re.loadFromNib(named: "UIImageView", bundle: bundle))
        XCTAssertNotNil(UIView.re.loadFromNib(withClass: UIImageView.self, bundle: bundle))
    }
    #endif

    func testRemoveSubviews() {
        let view = UIView()
        view.re.addSubviews([UIView(), UIView()])
        view.re.removeAllSubviews()
        XCTAssertEqual(view.subviews.count, 0)
    }

    func testRemoveGestureRecognizers() {
        let view = UIView()
        XCTAssertNil(view.gestureRecognizers)
        view.re.removeGestureRecognizers()
        XCTAssertNil(view.gestureRecognizers)

        let tap = UIGestureRecognizer(target: nil, action: nil)
        view.addGestureRecognizer(tap)
        XCTAssertNotNil(view.gestureRecognizers)
        view.re.removeGestureRecognizers()
        XCTAssertEqual(view.gestureRecognizers!.count, 0)
    }

    func testAddGestureRecognizers() {
        let view = UIView()

        XCTAssertNil(view.gestureRecognizers)

        let tap = UITapGestureRecognizer(target: nil, action: nil)
        let pan = UIPanGestureRecognizer(target: nil, action: nil)
        let swipe = UISwipeGestureRecognizer(target: nil, action: nil)

        view.re.addGestureRecognizers([tap, pan, swipe])

        XCTAssertNotNil(view.gestureRecognizers)
        XCTAssertEqual(view.gestureRecognizers!.count, 3)
    }

    func testRemoveGestureRecognizersVariadic() {
        let view = UIView()

        XCTAssertNil(view.gestureRecognizers)

        let tap = UITapGestureRecognizer(target: nil, action: nil)
        let pan = UIPanGestureRecognizer(target: nil, action: nil)
        let swipe = UISwipeGestureRecognizer(target: nil, action: nil)

        view.re.addGestureRecognizers([tap, pan, swipe])

        XCTAssertNotNil(view.gestureRecognizers)
        XCTAssertEqual(view.gestureRecognizers!.count, 3)

        view.re.removeGestureRecognizers([tap, pan, swipe])

        XCTAssertNotNil(view.gestureRecognizers)
        XCTAssert(view.gestureRecognizers!.isEmpty)
    }

    func testAnchor() {
        let view = UIView()
        let subview = UIView()
        view.addSubview(subview)
        subview.re.anchor(top: nil, left: nil, bottom: nil, right: nil)
        XCTAssert(subview.constraints.isEmpty)

        subview.re.anchor(top: view.topAnchor)
        XCTAssertNotNil(subview.topAnchor)

        subview.re.anchor(left: view.leftAnchor)
        XCTAssertNotNil(subview.leftAnchor)

        subview.re.anchor(bottom: view.bottomAnchor)
        XCTAssertNotNil(subview.bottomAnchor)

        subview.re.anchor(right: view.rightAnchor)
        XCTAssertNotNil(subview.rightAnchor)

        subview.re.anchor(widthConstant: 10.0, heightConstant: 10.0)
        XCTAssertNotNil(subview.widthAnchor)
        XCTAssertNotNil(subview.heightAnchor)
    }

    func testAnchorCenterXToSuperview() {
        let superview = UIView()
        let view = UIView()
        superview.addSubview(view)
        view.re.anchorCenterXToSuperview()
        let subview = UIView()
        view.addSubview(subview)
        view.re.anchorCenterXToSuperview(constant: 10.0)
        XCTAssertNotNil(subview.centerXAnchor)
    }

    func testAnchorCenterYToSuperview() {
        let superview = UIView()
        let view = UIView()
        superview.addSubview(view)
        view.re.anchorCenterXToSuperview()
        let subview = UIView()
        view.addSubview(subview)
        view.re.anchorCenterYToSuperview(constant: 10.0)
        XCTAssertNotNil(subview.centerYAnchor)
    }

    func testAnchorCenterToSuperview() {
        let superview = UIView()
        let view = UIView()
        superview.addSubview(view)
        view.re.anchorCenterSuperview()
        let subview = UIView()
        view.addSubview(subview)
        view.re.anchorCenterSuperview()
        XCTAssertNotNil(subview.centerXAnchor)
        XCTAssertNotNil(subview.centerYAnchor)
    }

    func testAncestorViewWhere() {
        let tableView = UITableView(frame: .zero)
        let tableViewCell = UITableViewCell(frame: .zero)
        tableView.addSubview(tableViewCell)
        tableView.tag = 2
        let button = UIButton(frame: .zero)
        tableViewCell.addSubview(button)
        button.tag = 1
        let buttonSubview = UIView(frame: .zero)
        button.addSubview(buttonSubview)
        XCTAssertEqual(buttonSubview.re.ancestorView { $0.tag == 1 }, button)
        XCTAssertEqual(buttonSubview.re.ancestorView { $0.tag == 2 }, tableView)
        XCTAssertNil(buttonSubview.re.ancestorView { $0.tag == 3 })
        XCTAssertEqual(button.re.ancestorView { $0 is UITableViewCell }, tableViewCell)
        XCTAssertEqual(button.re.ancestorView { $0.superview == nil }, tableView)
    }

    func testAncestorViewWithClass() {
        let tableView = UITableView(frame: .zero)
        let tableViewCell = UITableViewCell(frame: .zero)
        tableView.addSubview(tableViewCell)
        let button = UIButton(frame: .zero)
        tableViewCell.addSubview(button)
        let buttonSubview = UIView(frame: .zero)
        button.addSubview(buttonSubview)

        XCTAssertEqual(button.re.ancestorView(ofType: UITableViewCell.self), tableViewCell)
        XCTAssertEqual(button.re.ancestorView(ofType: UITableView.self), tableView)
        XCTAssertNil(button.re.ancestorView(ofType: UIButton.self))
        XCTAssertNil(tableView.re.ancestorView(ofType: UIButton.self))
        XCTAssertEqual(buttonSubview.re.ancestorView(ofType: UITableViewCell.self), tableViewCell)
        XCTAssertEqual(buttonSubview.re.ancestorView(ofType: UITableView.self), tableView)
    }

    func testSubviewsOfType() {
        // Test view with subviews with no subviews
        XCTAssertEqual(UIView().re.subviews(ofType: UILabel.self), [])

        // Test view with subviews that have subviews
        let parentView = UIView()

        let childView = UIView()
        let childViewSubViews = [UILabel(), UIButton(), UITextView(), UILabel(), UIImageView()]
        childView.re.addSubviews(childViewSubViews)

        let childView2 = UIView()
        let childView2SubViews = [UISegmentedControl(), UILabel(), UITextView(), UIImageView()]
        childView2.re.addSubviews(childView2SubViews)

        parentView.re.addSubviews([childView, childView2])

        let expected = [childViewSubViews[0], childViewSubViews[3], childView2SubViews[1]]
        XCTAssertEqual(parentView.re.subviews(ofType: UILabel.self, recursive: true), expected)
        XCTAssertEqual(parentView.re.subviews(ofType: UITableViewCell.self), [])
    }

    func testFindConstraint() {
        let view = UIView()
        let container = UIView()
        container.addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 1),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3)
        ])
        XCTAssertNotNil(view.re.findConstraint(attribute: .width, for: view))
        XCTAssertNil(view.re.findConstraint(attribute: .height, for: view))

        // pathological case
        XCTAssertNil(view.re.findConstraint(attribute: .height, for: UIView()))
    }

    func testConstraintProperties() {
        let container = UIView()
        let view = UIView()
        container.addSubview(view)

        // setup constraints, some in container and some in view
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 1),
            view.heightAnchor.constraint(equalToConstant: 2),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 4),
            view.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 6)
        ])

        // find them
        XCTAssertEqual(view.re.widthConstraint!.constant, 1)
        XCTAssertEqual(view.re.heightConstraint!.constant, 2)
        XCTAssertEqual(view.re.leadingConstraint!.constant, 3)
        XCTAssertEqual(view.re.trailingConstraint!.constant, 4)
        XCTAssertEqual(view.re.topConstraint!.constant, 5)
        XCTAssertEqual(view.re.bottomConstraint!.constant, 6)

        // simple empty case test
        XCTAssertNil(container.re.widthConstraint)
    }
    
    func testPickColor() {
        let view = UIView()
        view.backgroundColor = .red
        view.frame = .re(0, 0, 100, 100)
        XCTAssertEqual(view.re.color(at: .re(10, 10)), UIColor.red)
        view.backgroundColor = .blue
        XCTAssertEqual(view.re.color(at: .re(10, 10)), UIColor.blue)
        
        XCTAssertNil(view.re.color(at: .re(200, 200)))
    }
}
