//
//  URLRequestExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/5.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(Foundation)
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class URLRequestExtensionsTests: XCTestCase {
    func testInitFromURLString() {
        let urlString = "https://www.w3schools.com/"
        let request1 = URLRequest(url: URL(string: urlString)!)
        let request2 = URLRequest.re(urlString: urlString)
        XCTAssertNotNil(request2)
        XCTAssertEqual(request1.url, request2!.url)

        let invalidURLString = "invalid url"
        XCTAssertNil(URLRequest.re(urlString: invalidURLString))
    }

    func testCUrlSring() {
        let insightNASAcURL =
            "curl https://api.nasa.gov/insight_weather/?api_key=mxbd8VDIy5CheCbrYgknXVH6X9ElpQaHMhne2YXP&feedtype=json&ver=1.0"
        let planetaryNASAcURL =
            "curl https://api.nasa.gov/planetary/apod?api_key=mxbd8VDIy5CheCbrYgknXVH6X9ElpQaHMhne2YXP&date=2020-01-09&hd=true"
        var components = URLComponents(string: "https://api.nasa.gov")
        let apiKey = "mxbd8VDIy5CheCbrYgknXVH6X9ElpQaHMhne2YXP"

        // #1 scenario
        components?.path = "/insight_weather/"

        let feedType = "json"
        let version = "1.0"

        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "feedtype", value: feedType),
            URLQueryItem(name: "ver", value: version)
        ]

        XCTAssertNotNil(components?.url)
        let insightRequest = URLRequest(url: components!.url!)
        XCTAssertEqual(insightRequest.re.curlString, insightNASAcURL)

        // #2 scenario
        components?.path = "/planetary/apod"

        let date = "2020-01-09"
        let isHD = "true"

        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "hd", value: isHD)
        ]

        XCTAssertNotNil(components?.url)
        let planetaryRequest = URLRequest(url: components!.url!)
        XCTAssertEqual(planetaryRequest.re.curlString, planetaryNASAcURL)
    }
}

#endif
