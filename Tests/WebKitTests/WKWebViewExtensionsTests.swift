//
//  WKWebViewExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/22.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(WebKit)
import WebKit

final class WKWebViewExtensionsTests: XCTestCase {
    private let timeout = TimeInterval(10)

    var webView: WKWebView!

    override func setUp() {
        webView = WKWebView()
    }

    func testLoadURL() {
        let successExpectation = WebViewSuccessExpectation(description: "Correct URL", webView: webView)

        let url = URL(string: "https://example.com/")!
        let navigation = webView.re.loadURL(url)

        XCTAssertNotNil(navigation)

        wait(for: [successExpectation], timeout: timeout)
    }

    func testLoadURLString() {
        let successExpectation = WebViewSuccessExpectation(description: "Correct URL string", webView: webView)

        let urlString = "https://example.com/"
        let navigation = webView.re.loadURLString(urlString)

        XCTAssertNotNil(navigation)

        wait(for: [successExpectation], timeout: timeout)
    }

    func testLoadInvalidURLString() {
        let invalidURLString = "invalid url"
        let navigation = webView.re.loadURLString(invalidURLString)

        XCTAssertNil(navigation)
    }

    func testLoadDeadURLString() {
        let failureExpectation = WebViewFailureExpectation(description: "Dead URL string", webView: webView)

        let deadURLString = "https://xxxxsdfasf.com"
        let navigation = webView.re.loadURLString(deadURLString, timeout: 5.0)

        XCTAssertNotNil(navigation)

        wait(for: [failureExpectation], timeout: timeout)
    }
}

class WebViewSuccessExpectation: XCTestExpectation, WKNavigationDelegate {
    init(description: String, webView: WKWebView) {
        super.init(description: description)
        webView.navigationDelegate = self
    }

    func webView(_: WKWebView, didCommit _: WKNavigation!) {
        fulfill()
    }
}

class WebViewFailureExpectation: XCTestExpectation, WKNavigationDelegate {
    init(description: String, webView: WKWebView) {
        super.init(description: description)
        webView.navigationDelegate = self
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
        fulfill()
    }

    func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError _: Error) {
        fulfill()
    }
}

#endif
