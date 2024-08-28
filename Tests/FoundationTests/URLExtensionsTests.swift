//
//  URLExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2022/12/3.
//  Copyright © 2022 reers. All rights reserved.
//

import XCTest
@testable import ReerKit
import Foundation

final class URLExtensionsTests: XCTestCase {

    func testInit() {
        XCTAssertEqual(URL.re(string: "myapp://example.com/over/there?hello=123"), URL(string: "myapp://example.com/over/there?hello=123"))
        XCTAssertEqual(URL.re(string: "myapp://example.com/over/there?hello=你好#nose"), URL(string: "myapp://example.com/over/there?hello=%E4%BD%A0%E5%A5%BD#nose"))
        XCTAssertEqual(URL.re(string: "https://example.com/audio/嗯好的.ogg"), URL(string: "https://example.com/audio/%E5%97%AF%E5%A5%BD%E7%9A%84.ogg"))
        XCTAssertEqual(URL.re(string: "https://example.com/嗯好的/audio.ogg"), URL(string: "https://example.com/%E5%97%AF%E5%A5%BD%E7%9A%84/audio.ogg"))
        XCTAssertEqual(URL.re(string: "https://example.com/嗯好的/audio.ogg?key="), URL(string: "https://example.com/%E5%97%AF%E5%A5%BD%E7%9A%84/audio.ogg?key="))
        XCTAssertEqual(URL.re(string: "https://上来看对方就爱上了对方/嗯好的/audio.ogg"), URL(string: "https://xn--fhqa68ag85bca74aj38cea959a2t9ai1l/%E5%97%AF%E5%A5%BD%E7%9A%84/audio.ogg"))
        XCTAssertEqual(URL.re(string: "https://例子.测试/路径/子路径?参数1=值1&参数2=值2#片段"), URL(string: "https://xn--fsqu00a.xn--0zwm56d/%E8%B7%AF%E5%BE%84/%E5%AD%90%E8%B7%AF%E5%BE%84?%E5%8F%82%E6%95%B01=%E5%80%BC1&%E5%8F%82%E6%95%B02=%E5%80%BC2#%E7%89%87%E6%AE%B5"))
    }

    var url = URL(string: "https://www.google.com")!
    let params = ["q": "swifter swift"]
    let queryUrl = URL(string: "https://www.google.com?q=swifter%20swift")!

    func testQueryParameters() {
        let url = URL(string: "https://www.google.com?q=swifter%20swift&steve=jobs&empty")!
        guard let parameters = url.re.queryParameters else {
            XCTAssert(false)
            return
        }

        XCTAssertEqual(parameters.count, 2)
        XCTAssertEqual(parameters["q"], "swifter swift")
        XCTAssertEqual(parameters["steve"], "jobs")
        XCTAssertNil(parameters["empty"])
    }

    func testOptionalStringInitializer() {
        XCTAssertNil(URL.re(string: nil, relativeTo: nil))
        XCTAssertNil(URL.re(string: nil))

        let baseURL = URL(string: "https://www.example.com")
        XCTAssertNotNil(baseURL)
        XCTAssertNil(URL.re(string: nil, relativeTo: baseURL))

        let string = "/index.html"
        let optionalString: String? = string
        XCTAssertEqual(URL.re(string: optionalString, relativeTo: baseURL), URL.re(string: string, relativeTo: baseURL))
        XCTAssertEqual(
            URL.re(string: optionalString, relativeTo: baseURL)?.absoluteString,
            "https://www.example.com/index.html")
    }

    func testAppendingQueries() {
        XCTAssertEqual(url.re.appendingQueries(params), queryUrl)
    }

    func testAppendQueryParameters() {
        url.re.appendQueries(params)
        XCTAssertEqual(url, queryUrl)
    }
    
    func testRemovingQueries() {
        XCTAssertEqual(queryUrl.re.removingQueries(["q"]), url)
    }
    
    func testRevmoeQueries() {
        var testURL = queryUrl
        testURL.re.removeQueries(["q"])
        XCTAssertEqual(testURL, url)
    }

    func testValueForQueryKey() {
        let url = URL(string: "https://google.com?code=12345&empty")!

        let codeResult = url.re.queryValue(for: "code")
        let emtpyResult = url.re.queryValue(for: "empty")
        let otherResult = url.re.queryValue(for: "other")

        XCTAssertEqual(codeResult, "12345")
        XCTAssertNil(emtpyResult)
        XCTAssertNil(otherResult)
    }

    func testDeletingAllPathComponents() {
        let url = URL(string: "https://domain.com/path/other/")!
        let result = url.re.deletingAllPathComponents()
        XCTAssertEqual(result.absoluteString, "https://domain.com/")

        let pathlessURL = URL(string: "https://domain.com")!
        let pathlessResult = pathlessURL.re.deletingAllPathComponents()
        XCTAssertEqual(pathlessResult.absoluteString, "https://domain.com")
    }

    func testDeleteAllPathComponents() {
        var url = URL(string: "https://domain.com/path/other/")!
        url.re.deleteAllPathComponents()
        XCTAssertEqual(url.absoluteString, "https://domain.com/")

        var pathlessURL = URL(string: "https://domain.com")!
        pathlessURL.re.deleteAllPathComponents()
        XCTAssertEqual(pathlessURL.absoluteString, "https://domain.com")
    }

    #if os(iOS) || os(tvOS)
    func testThumbnail() {
        XCTAssertNil(url.re.thumbnail())

        let videoUrl = Bundle(for: URLExtensionsTests.self)
            .url(forResource: "big_buck_bunny_720p_1mb", withExtension: "mp4")!
        XCTAssertNotNil(videoUrl.re.thumbnail())
        XCTAssertNotNil(videoUrl.re.thumbnail(fromTime: 1))
    }
    #endif

    func testDropScheme() {
        let urls: [String: String?] = [
            "https://domain.com/path/other/": "domain.com/path/other/",
            "https://domain.com": "domain.com",
            "http://domain.com": "domain.com",
            "file://domain.com/image.jpeg": "domain.com/image.jpeg",
            "://apple.com": "apple.com",
            "//apple.com": "apple.com",
            "apple.com": "apple.com",
            "http://": nil,
            "//": "//"
        ]

        urls.forEach { input, expected in
            guard let url = URL(string: input) else { return XCTFail("Failed to initialize URL.") }
            XCTAssertEqual(url.re.droppedScheme()?.absoluteString, expected, "input url: \(input)")
        }
    }

}
