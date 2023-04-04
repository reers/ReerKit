//
//  NotificationCenterExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/4.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

final class NotificationCenterExtensionsTests: XCTestCase {
    func testObserveOnce() {
        var count = 0

        let notificationCenter = NotificationCenter()
        let notificationName = Notification.Name(rawValue: "foo")
        let object = NSObject()
        let operationQueue = OperationQueue()
        let increment = { (_: Notification) in count += 1 }
        notificationCenter.re.observeOnce(
            forName: notificationName,
            object: object,
            queue: operationQueue,
            using: increment)

        let wrongNotificationName = Notification.Name(rawValue: "bar")

        notificationCenter.post(name: wrongNotificationName, object: object)
        XCTAssertEqual(count, 0)
        notificationCenter.post(name: notificationName, object: nil)
        XCTAssertEqual(count, 0)
        notificationCenter.post(name: notificationName, object: object)
        XCTAssertEqual(count, 1)
        notificationCenter.post(name: notificationName, object: object)
        XCTAssertEqual(count, 1)

        notificationCenter.re.observeOnce(
            forName: nil,
            object: object,
            queue: operationQueue,
            using: increment)
        notificationCenter.post(name: wrongNotificationName, object: object)
        XCTAssertEqual(count, 2)

        notificationCenter.re.observeOnce(
            forName: notificationName,
            object: nil,
            queue: operationQueue,
            using: increment)
        notificationCenter.post(name: notificationName, object: nil)
        XCTAssertEqual(count, 3)

        notificationCenter.re.observeOnce(
            forName: notificationName,
            object: object,
            queue: nil,
            using: increment)
        notificationCenter.post(name: notificationName, object: object)
        XCTAssertEqual(count, 4)
    }
}
