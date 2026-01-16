//
//  UserDefaultsExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2026/1/16.
//  Copyright © 2026 reers. All rights reserved.
//

import XCTest
@testable import ReerKit

#if canImport(Foundation)
import Foundation

final class UserDefaultsExtensionsTests: XCTestCase {
    
    // Test suite name for UserDefaults keys
    private let suiteName = "com.reerkit.tests.userdefaults"
    
    private func getDefaults() -> UserDefaults {
        return UserDefaults(suiteName: suiteName)!
    }
    
    override func setUp() {
        super.setUp()
        // Clean up before each test
        UserDefaults().removePersistentDomain(forName: suiteName)
    }
    
    override func tearDown() {
        // Clean up after each test
        UserDefaults().removePersistentDomain(forName: suiteName)
        super.tearDown()
    }
    
    // MARK: - Test Models
    
    struct User: Codable, Equatable {
        let name: String
        let age: Int
    }
    
    struct Settings: Codable, Equatable {
        let isDarkMode: Bool
        let fontSize: Double
        let language: String
    }
    
    struct ComplexModel: Codable, Equatable {
        let id: Int
        let tags: [String]
        let metadata: [String: String]
        let createdAt: Date
    }
    
    // MARK: - Codable Object Tests
    
    func testSetAndGetCodableObject() throws {
        let user = User(name: "John", age: 30)
        
        try getDefaults().re.set(object: user, forKey: "user")
        let retrievedUser: User? = getDefaults().re.object(User.self, forKey: "user")
        
        XCTAssertNotNil(retrievedUser)
        XCTAssertEqual(retrievedUser, user)
    }
    
    func testGetCodableObjectForNonExistentKey() {
        let user: User? = getDefaults().re.object(User.self, forKey: "nonExistentKey")
        XCTAssertNil(user)
    }
    
    func testSetAndGetComplexCodableObject() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let date = Date(timeIntervalSince1970: 1000000)
        let model = ComplexModel(
            id: 123,
            tags: ["swift", "ios", "reerkit"],
            metadata: ["version": "1.0", "platform": "iOS"],
            createdAt: date
        )
        
        try getDefaults().re.set(object: model, forKey: "complexModel", encoder: encoder)
        let retrievedModel: ComplexModel? = getDefaults().re.object(ComplexModel.self, forKey: "complexModel", decoder: decoder)
        
        XCTAssertNotNil(retrievedModel)
        XCTAssertEqual(retrievedModel?.id, model.id)
        XCTAssertEqual(retrievedModel?.tags, model.tags)
        XCTAssertEqual(retrievedModel?.metadata, model.metadata)
    }
    
    func testObjectWithInvalidDataReturnsNil() {
        // Store invalid data for User type
        getDefaults().set("invalid data".data(using: .utf8), forKey: "invalidUser")
        
        let user: User? = getDefaults().re.object(User.self, forKey: "invalidUser")
        XCTAssertNil(user)
    }
    
    // MARK: - Codable Array Tests
    
    func testSetAndGetCodableArray() throws {
        let users = [
            User(name: "John", age: 30),
            User(name: "Jane", age: 25),
            User(name: "Bob", age: 35)
        ]
        
        try getDefaults().re.set(array: users, forKey: "users")
        let retrievedUsers: [User]? = getDefaults().re.array(of: User.self, forKey: "users")
        
        XCTAssertNotNil(retrievedUsers)
        XCTAssertEqual(retrievedUsers?.count, 3)
        XCTAssertEqual(retrievedUsers, users)
    }
    
    func testGetCodableArrayForNonExistentKey() {
        let users: [User]? = getDefaults().re.array(of: User.self, forKey: "nonExistentKey")
        XCTAssertNil(users)
    }
    
    func testSetAndGetEmptyArray() throws {
        let emptyUsers: [User] = []
        
        try getDefaults().re.set(array: emptyUsers, forKey: "emptyUsers")
        let retrievedUsers: [User]? = getDefaults().re.array(of: User.self, forKey: "emptyUsers")
        
        XCTAssertNotNil(retrievedUsers)
        XCTAssertEqual(retrievedUsers?.count, 0)
    }
    
    func testArrayWithInvalidDataReturnsNil() {
        getDefaults().set("invalid data".data(using: .utf8), forKey: "invalidArray")
        
        let users: [User]? = getDefaults().re.array(of: User.self, forKey: "invalidArray")
        XCTAssertNil(users)
    }
    
    // MARK: - Has Key Tests
    
    func testHasKey() throws {
        XCTAssertFalse(getDefaults().re.hasKey("testKey"))
        
        getDefaults().set("value", forKey: "testKey")
        XCTAssertTrue(getDefaults().re.hasKey("testKey"))
    }
    
    func testHasKeyWithCodableObject() throws {
        XCTAssertFalse(getDefaults().re.hasKey("user"))
        
        let user = User(name: "John", age: 30)
        try getDefaults().re.set(object: user, forKey: "user")
        
        XCTAssertTrue(getDefaults().re.hasKey("user"))
    }
    
    // MARK: - Date Tests
    
    func testSetAndGetDate() {
        let date = Date(timeIntervalSince1970: 1000000)
        
        getDefaults().re.set(date: date, forKey: "testDate")
        let retrievedDate: Date? = getDefaults().re.date(forKey: "testDate")
        
        XCTAssertNotNil(retrievedDate)
        XCTAssertEqual(retrievedDate?.timeIntervalSince1970, date.timeIntervalSince1970)
    }
    
    func testSetAndGetDateBefore1970() {
        // Date before 1970 (negative timeInterval)
        let date = Date(timeIntervalSince1970: -1000000)
        
        getDefaults().re.set(date: date, forKey: "oldDate")
        let retrievedDate: Date? = getDefaults().re.date(forKey: "oldDate")
        
        XCTAssertNotNil(retrievedDate)
        XCTAssertEqual(retrievedDate?.timeIntervalSince1970, date.timeIntervalSince1970)
    }
    
    func testSetAndGetDateAt1970() {
        // Exact 1970-01-01 00:00:00 (timeInterval = 0)
        let date = Date(timeIntervalSince1970: 0)
        
        getDefaults().re.set(date: date, forKey: "epochDate")
        let retrievedDate: Date? = getDefaults().re.date(forKey: "epochDate")
        
        XCTAssertNotNil(retrievedDate)
        XCTAssertEqual(retrievedDate?.timeIntervalSince1970, 0)
    }
    
    func testSetAndGetDateWithFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        let date = Date(timeIntervalSince1970: 1000000)
        
        getDefaults().re.set(date: date, forKey: "formattedDate", formatter: formatter)
        let retrievedDate: Date? = getDefaults().re.date(forKey: "formattedDate", formatter: formatter)
        
        XCTAssertNotNil(retrievedDate)
        // Compare formatted strings since there might be precision differences
        XCTAssertEqual(formatter.string(from: retrievedDate!), formatter.string(from: date))
    }
    
    func testSetNilDate() {
        getDefaults().re.set(date: Date(), forKey: "dateToRemove")
        XCTAssertTrue(getDefaults().re.hasKey("dateToRemove"))
        
        getDefaults().re.set(date: nil, forKey: "dateToRemove")
        XCTAssertFalse(getDefaults().re.hasKey("dateToRemove"))
    }
    
    func testGetDateForNonExistentKey() {
        let date: Date? = getDefaults().re.date(forKey: "nonExistentDate")
        XCTAssertNil(date)
    }
    
    func testGetDateWithFormatterForNonExistentKey() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date: Date? = getDefaults().re.date(forKey: "nonExistentDate", formatter: formatter)
        XCTAssertNil(date)
    }
    
    // MARK: - Edge Cases
    
    func testOverwriteCodableObject() throws {
        let user1 = User(name: "John", age: 30)
        let user2 = User(name: "Jane", age: 25)
        
        try getDefaults().re.set(object: user1, forKey: "user")
        try getDefaults().re.set(object: user2, forKey: "user")
        
        let retrievedUser: User? = getDefaults().re.object(User.self, forKey: "user")
        XCTAssertEqual(retrievedUser, user2)
    }
    
    func testOverwriteCodableArray() throws {
        let users1 = [User(name: "John", age: 30)]
        let users2 = [User(name: "Jane", age: 25), User(name: "Bob", age: 35)]
        
        try getDefaults().re.set(array: users1, forKey: "users")
        try getDefaults().re.set(array: users2, forKey: "users")
        
        let retrievedUsers: [User]? = getDefaults().re.array(of: User.self, forKey: "users")
        XCTAssertEqual(retrievedUsers, users2)
    }
    
    func testCodableWithNestedTypes() throws {
        struct Parent: Codable, Equatable {
            struct Child: Codable, Equatable {
                let value: String
            }
            let children: [Child]
        }
        
        let parent = Parent(children: [
            Parent.Child(value: "first"),
            Parent.Child(value: "second")
        ])
        
        try getDefaults().re.set(object: parent, forKey: "parent")
        let retrievedParent: Parent? = getDefaults().re.object(Parent.self, forKey: "parent")
        
        XCTAssertNotNil(retrievedParent)
        XCTAssertEqual(retrievedParent, parent)
    }
    
    func testCodableWithOptionalProperties() throws {
        struct OptionalModel: Codable, Equatable {
            let required: String
            let optional: String?
        }
        
        let model1 = OptionalModel(required: "test", optional: "value")
        let model2 = OptionalModel(required: "test", optional: nil)
        
        try getDefaults().re.set(object: model1, forKey: "optional1")
        try getDefaults().re.set(object: model2, forKey: "optional2")
        
        let retrieved1: OptionalModel? = getDefaults().re.object(OptionalModel.self, forKey: "optional1")
        let retrieved2: OptionalModel? = getDefaults().re.object(OptionalModel.self, forKey: "optional2")
        
        XCTAssertEqual(retrieved1, model1)
        XCTAssertEqual(retrieved2, model2)
    }
    
    func testCodableWithEnumProperty() throws {
        enum Status: String, Codable {
            case active
            case inactive
            case pending
        }
        
        struct StatusModel: Codable, Equatable {
            let status: Status
        }
        
        let model = StatusModel(status: .active)
        
        try getDefaults().re.set(object: model, forKey: "statusModel")
        let retrieved: StatusModel? = getDefaults().re.object(StatusModel.self, forKey: "statusModel")
        
        XCTAssertEqual(retrieved, model)
    }
}

#endif
