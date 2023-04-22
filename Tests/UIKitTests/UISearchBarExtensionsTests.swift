//
//  UISearchBarExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if os(iOS)
import UIKit

final class UISearchBarExtensionsTests: XCTestCase {
    func testSearchBar() {
        let searchBar = UISearchBar()
        XCTAssertNotEqual(searchBar.re.textField?.text?.isEmpty, false)

        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let aSearchBar = UISearchBar(frame: frame)
        aSearchBar.text = "Hello"
        XCTAssertNotNil(aSearchBar.re.textField)
        XCTAssertEqual(aSearchBar.re.textField?.text, "Hello")
    }

    func testTrimmedText() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let aSearchBar = UISearchBar(frame: frame)
        aSearchBar.text = "Hello \n    \n"
        XCTAssertNotNil(aSearchBar.re.trimmedText)
        XCTAssertEqual(aSearchBar.re.trimmedText!, "Hello")
    }

    func testClear() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        let aSearchBar = UISearchBar(frame: frame)
        aSearchBar.text = "Hello"
        aSearchBar.re.clear()
        XCTAssertEqual(aSearchBar.text!, "")
    }
}

#endif
