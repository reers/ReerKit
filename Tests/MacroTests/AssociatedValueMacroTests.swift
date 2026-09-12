#if canImport(ReerKitMacros) && canImport(SwiftSyntaxMacrosTestSupport)

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import ReerKitMacros

final class AssociatedValueMacroTests: XCTestCase {
    private let testMacros: [String: Macro.Type] = [
        "AssociatedValue": AssociatedValueMacro.self
    ]

    func testAssociatedValueMacroExpandsOptionalPropertyAccessors() {
        assertMacroExpansion(
            """
            final class Example {
                @AssociatedValue
                var title: String?
            }
            """,
            expandedSource: """
            final class Example {
                var title: String? {
                    get {
                        re.associatedValue(forKey: AssociationKey(#function as StaticString))
                    }
                    set {
                        re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString), withPolicy: .retain)
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAssociatedValueMacroExpandsDefaultValueAndPolicy() {
        assertMacroExpansion(
            """
            final class Example {
                @AssociatedValue(default: 0, policy: .assign)
                var count: Int
            }
            """,
            expandedSource: """
            final class Example {
                var count: Int {
                    get {
                        re.associatedValue(forKey: AssociationKey(#function as StaticString), default: 0)
                    }
                    set {
                        re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString), withPolicy: .assign)
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAssociatedValueMacroExpandsExtensionPropertyAccessors() {
        assertMacroExpansion(
            """
            extension UIViewController {
                @AssociatedValue(default: false)
                var isAppeared: Bool
            }
            """,
            expandedSource: """
            extension UIViewController {
                var isAppeared: Bool {
                    get {
                        re.associatedValue(forKey: AssociationKey(#function as StaticString), default: false)
                    }
                    set {
                        re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString), withPolicy: .retain)
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAssociatedValueMacroUsesPropertyInitializerAsDefaultValue() {
        assertMacroExpansion(
            """
            final class Example {
                @AssociatedValue
                var count: Int = 7
            }
            """,
            expandedSource: """
            final class Example {
                var count: Int {
                    get {
                        re.associatedValue(forKey: AssociationKey(#function as StaticString), default: 7)
                    }
                    set {
                        re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString), withPolicy: .retain)
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAssociatedValueMacroUsesKnownTypeDefaultValue() {
        assertMacroExpansion(
            """
            final class Example {
                @AssociatedValue
                var isAppeared: Bool
            }
            """,
            expandedSource: """
            final class Example {
                var isAppeared: Bool {
                    get {
                        re.associatedValue(forKey: AssociationKey(#function as StaticString), default: false)
                    }
                    set {
                        re.setAssociatedValue(newValue, forKey: AssociationKey(#function as StaticString), withPolicy: .retain)
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testAssociatedValueMacroDiagnosesStaticProperty() {
        assertMacroExpansion(
            """
            final class Example {
                @AssociatedValue
                static var count: Int
            }
            """,
            expandedSource: """
            final class Example {
                static var count: Int
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@AssociatedValue can only be attached to an instance var property",
                    line: 2,
                    column: 5
                )
            ],
            macros: testMacros
        )
    }

    func testAssociatedValueMacroDiagnosesClassProperty() {
        assertMacroExpansion(
            """
            class Example {
                @AssociatedValue
                class var title: String?
            }
            """,
            expandedSource: """
            class Example {
                class var title: String?
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@AssociatedValue can only be attached to an instance var property",
                    line: 2,
                    column: 5
                )
            ],
            macros: testMacros
        )
    }
}

#endif
