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
    
    func testChainableMethods() {
        #if canImport(UIKit) || canImport(AppKit)
        let testString = "Hello World!"
        let attributedString = NSAttributedString(string: testString)
        
        // Test font method
        let withFont = attributedString.re.font(REFont.systemFont(ofSize: 16))
        var attributes = withFont.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.font])
        #if canImport(UIKit)
        XCTAssertEqual(attributes[.font] as! UIFont, UIFont.systemFont(ofSize: 16))
        #endif
        
        // Test fontSize method
        let withFontSize = attributedString.re.fontSize(18)
        attributes = withFontSize.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.font])
        #if canImport(UIKit)
        XCTAssertEqual(attributes[.font] as! UIFont, UIFont.systemFont(ofSize: 18))
        #endif
        
        // Test color method
        let withColor = attributedString.re.color(.red)
        attributes = withColor.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.foregroundColor])
        XCTAssertEqual(attributes[.foregroundColor] as! REColor, .red)
        
        // Test backgroundColor method
        let withBackgroundColor = attributedString.re.backgroundColor(.blue)
        attributes = withBackgroundColor.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.backgroundColor])
        XCTAssertEqual(attributes[.backgroundColor] as! REColor, .blue)
        
        // Test paragraphStyle method
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let withParagraphStyle = attributedString.re.paragraphStyle(paragraphStyle)
        attributes = withParagraphStyle.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.paragraphStyle])
        XCTAssertEqual((attributes[.paragraphStyle] as! NSParagraphStyle).alignment, .center)
        
        // Test paragraphStyle with configure method
        let withParagraphStyleConfigure = attributedString.re.paragraphStyle { style in
            style.alignment = .right
        }
        attributes = withParagraphStyleConfigure.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.paragraphStyle])
        XCTAssertEqual((attributes[.paragraphStyle] as! NSParagraphStyle).alignment, .right)
        
        // Test underline method
        let withUnderline = attributedString.re.underline(.single)
        attributes = withUnderline.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.underlineStyle])
        XCTAssertEqual(attributes[.underlineStyle] as! Int, NSUnderlineStyle.single.rawValue)
        
        // Test strikethrough method
        let withStrikethrough = attributedString.re.strikethrough(.single)
        attributes = withStrikethrough.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.strikethroughStyle])
        XCTAssertEqual(attributes[.strikethroughStyle] as! Int, NSUnderlineStyle.single.rawValue)
        
        // Test kern method
        let withKern = attributedString.re.kern(2.0)
        attributes = withKern.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.kern])
        XCTAssertEqual(attributes[.kern] as! CGFloat, 2.0, accuracy: 0.01)
        
        // Test baselineOffset method
        let withBaselineOffset = attributedString.re.baselineOffset(3.0)
        attributes = withBaselineOffset.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.baselineOffset])
        XCTAssertEqual(attributes[.baselineOffset] as! CGFloat, 3.0, accuracy: 0.01)
        
        // Test shadow method
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 2.0
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        let withShadow = attributedString.re.shadow(shadow)
        attributes = withShadow.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.shadow])
        let retrievedShadow = attributes[.shadow] as! NSShadow
        XCTAssertEqual(retrievedShadow.shadowBlurRadius, 2.0, accuracy: 0.01)
        XCTAssertEqual(retrievedShadow.shadowOffset, CGSize(width: 1, height: 1))
        
        // Test strokeWidth method
        let withStrokeWidth = attributedString.re.strokeWidth(1.5)
        attributes = withStrokeWidth.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.strokeWidth])
        XCTAssertEqual(attributes[.strokeWidth] as! CGFloat, 1.5, accuracy: 0.01)
        
        // Test strokeColor method
        let withStrokeColor = attributedString.re.strokeColor(.green)
        attributes = withStrokeColor.attributes(at: 0, effectiveRange: nil)
        XCTAssertNotNil(attributes[.strokeColor])
        XCTAssertEqual(attributes[.strokeColor] as! REColor, .green)
        #endif
    }
    
    func testChainableMethodsCombined() {
        #if canImport(UIKit) || canImport(AppKit)
        let testString = "Chained Methods Test"
        let attributedString = NSMutableAttributedString(string: testString)
        
        // Test chaining multiple methods
        let chained = attributedString
            .re.fontSize(20)
            .re.color(.red)
            .re.backgroundColor(.yellow)
            .re.kern(1.0)
            .re.underline(.single)
        
        let attributes = chained.attributes(at: 0, effectiveRange: nil)
        
        // Verify all attributes are applied
        XCTAssertNotNil(attributes[.font])
        #if canImport(UIKit)
        XCTAssertEqual(attributes[.font] as! UIFont, UIFont.systemFont(ofSize: 20))
        #endif
        XCTAssertEqual(attributes[.foregroundColor] as! REColor, .red)
        XCTAssertEqual(attributes[.backgroundColor] as! REColor, .yellow)
        XCTAssertEqual(attributes[.kern] as! CGFloat, 1.0, accuracy: 0.01)
        XCTAssertEqual(attributes[.underlineStyle] as! Int, NSUnderlineStyle.single.rawValue)
        
        // Verify the string content is preserved
        XCTAssertEqual(chained.string, testString)
        #endif
    }
    
    func testMutableAttributedStringChainableMethods() {
        #if canImport(UIKit) || canImport(AppKit)
        let testString = "Mutable Test"
        let mutableString = NSMutableAttributedString(string: testString)
        
        // Test in-place modifications
        let result1 = mutableString.re.font(REFont.systemFont(ofSize: 14))
        XCTAssertNotNil(result1.re.attributes[.font])
        
        let result2 = mutableString.re.color(.blue)
        XCTAssertEqual(result2.re.attributes[.foregroundColor] as! REColor, .blue)
        #endif
    }
    #endif
}

#endif
