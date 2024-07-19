//
//  NSAttributedStringExtensionsTests.swift
//  ReerKit-iOSTests
//
//  Created by phoenix on 2023/4/4.
//  Copyright © 2023 reers. All rights reserved.
//

@testable import ReerKit
import XCTest

#if canImport(Foundation)
import Foundation

#if canImport(UIKit)
private typealias REFont = UIFont
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
private typealias Font = NSFont
#endif

// swiftlint:disable:next type_body_length
final class NSAttributedStringExtensionsTests: XCTestCase {
    

    // MARK: - Methods

    func testApplying() {
        #if canImport(AppKit) || canImport(UIKit)
        let string = NSAttributedString(string: "Applying")
        var out = string.re.with(attributes: [:])
        var attributes = out.attributes(at: 0, effectiveRange: nil)
        XCTAssert(attributes.isEmpty)

        out = string.re.with(attributes: [
            .strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue),
            .foregroundColor: REColor.red
        ])
        attributes = out.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes.count, 2)
        XCTAssertEqual(attributes[.strikethroughStyle] as! NSNumber, // swiftlint:disable:this force_cast
                       NSNumber(value: NSUnderlineStyle.single.rawValue))
        XCTAssertEqual(attributes[.foregroundColor] as! REColor, .red) // swiftlint:disable:this force_cast
        #endif
    }
   
    // MARK: - func joined(separator:)

    #if canImport(AppKit) || canImport(UIKit)
    private let firstStringToJoin = "Hello"
    private let secondStringToJoin = " "
    private let thirdStringToJoin = "World"

    private var stringsToJoin: [NSAttributedString] {
        let string1 = NSAttributedString(
            string: firstStringToJoin,
            attributes: [
                .strokeWidth: NSNumber(value: 1),
                .kern: NSNumber(value: 2)
            ]
        )
        let string2 = NSAttributedString(
            string: secondStringToJoin,
            attributes: [
                .expansion: NSNumber(value: 3),
                .obliqueness: NSNumber(value: 4)
            ]
        )
        let string3 = NSAttributedString(string: thirdStringToJoin, attributes: [:])
        return [string1, string2, string3]
    }

    private func expectedAttrbiutedString(
        with separator: String,
        separatorAttrbiutes: [NSAttributedString.Key: Any]
    ) -> NSAttributedString {
        let expectation = NSMutableAttributedString(
            string: firstStringToJoin + separator + secondStringToJoin + separator + thirdStringToJoin,
            attributes: [:]
        )

        expectation.addAttributes([
            .strokeWidth: NSNumber(value: 1),
            .kern: NSNumber(value: 2)
        ], range: NSRange(location: 0, length: firstStringToJoin.count))

        expectation.addAttributes(
            separatorAttrbiutes,
            range: NSRange(location: firstStringToJoin.count, length: separator.count)
        )

        expectation.addAttributes([
            .expansion: NSNumber(value: 3),
            .obliqueness: NSNumber(value: 4)
        ], range: NSRange(location: (firstStringToJoin + separator).count, length: secondStringToJoin.count))

        expectation.addAttributes(
            separatorAttrbiutes,
            range: NSRange(location: (firstStringToJoin + separator + secondStringToJoin).count, length: separator.count)
        )

        return expectation
    }

    func testJoinedWithEmptySeparator() {
        XCTAssertEqual(
            stringsToJoin.re.joined(separator: ""),
            expectedAttrbiutedString(with: "", separatorAttrbiutes: [:])
        )
    }

    func testJoinedWithEmptyAttributedSeparator() {
        XCTAssertEqual(
            stringsToJoin.re.joined(separator: NSAttributedString(string: "")),
            expectedAttrbiutedString(with: "", separatorAttrbiutes: [:])
        )
    }

    func testJoinedWithNonEmptySeparator() {
        XCTAssertEqual(
            stringsToJoin.re.joined(separator: " non empty "),
            expectedAttrbiutedString(with: " non empty ", separatorAttrbiutes: [:])
        )
    }

    func testJoinedWithNonEmptyAttributedSeparator() {
        XCTAssertEqual(
            stringsToJoin.re.joined(separator: NSAttributedString(string: " non empty ", attributes: [
                .expansion: NSNumber(value: 3),
                .obliqueness: NSNumber(value: 4)
            ])),
            expectedAttrbiutedString(with: " non empty ", separatorAttrbiutes: [
                .expansion: NSNumber(value: 3),
                .obliqueness: NSNumber(value: 4)
            ])
        )
    }

    func testEmptyArrayJoinedWithSeparator() {
        XCTAssertEqual(
            [].re.joined(separator: NSAttributedString(string: "Hello")),
            NSAttributedString(string: "")
        )
    }
    
    func testCalculateLinesOfAttributedString() {
        let attr1 = NSAttributedString(string: "1231fsfkjalskj1l2kj312l312afasldfkj1l2k3j12l3kj")
            .re.with(attributes: [.font: UIFont.systemFont(ofSize: 15)])
        let label = UILabel()
        label.backgroundColor = .red
        label.numberOfLines = 0
        label.attributedText = attr1
        label.frame = attr1.boundingRect(with: .init(width: 80, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
        let lines = attr1.re.numberOfLines(forWidth: 80)
        XCTAssertEqual(lines, 4)
        
        do {
            let multilineString = """
                
                
                131123
                abdcassdf
                
                ssssdfasdfaasefasdfasdfasdf
                123
                
                
                fsdlkfj1231
                
                """
            let attr2 = NSAttributedString(string: multilineString)
                .re.with(attributes: [.font: UIFont.systemFont(ofSize: 15)])
            label.attributedText = attr2
            label.frame = attr2.boundingRect(with: .init(width: 80, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
            let lines2 = attr2.re.numberOfLines(forWidth: 80)
            XCTAssertEqual(lines2, 13)
        }
        
        do {
            let multilineString = """
                
                
                131123
                abdcassdf
                
                ssssdfasdfaasefasdfasdfasdf
                123
                
                
                fsdlkfj1231
                
                """
            let attr2 = NSAttributedString(string: multilineString)
                .re.with(attributes: [.font: UIFont.systemFont(ofSize: 15)])
            label.attributedText = attr2
            label.frame = attr2.boundingRect(with: .init(width: 80, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
            let lines2 = attr2.re.numberOfLines(forWidth: 80, ignoreBlankLines: true)
            XCTAssertEqual(lines2, 7)
        }
        
    }
    #endif
}

#endif
