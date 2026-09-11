#if canImport(ReerKitMacros) && canImport(SwiftSyntaxMacrosTestSupport)

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import ReerKitMacros

final class DefaultsMacroTests: XCTestCase {
    private let testMacros: [String: Macro.Type] = [
        "Defaults": DefaultsMacro.self
    ]

    func testDefaultsMacroExpandsExplicitDefaultValue() {
        assertMacroExpansion(
            """
            final class Example {
                @Defaults("key111", false)
                var isAppeared: Bool
            }
            """,
            expandedSource: """
            final class Example {
                var isAppeared: Bool {
                    get {
                        ReerDefaults.value(forKey: "key111", default: false)
                    }
                    set {
                        ReerDefaults.set(newValue, forKey: "key111")
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testDefaultsMacroExpandsKnownTypeDefaultValue() {
        assertMacroExpansion(
            """
            final class Example {
                @Defaults("key111")
                var isAppeared: Bool
            }
            """,
            expandedSource: """
            final class Example {
                var isAppeared: Bool {
                    get {
                        ReerDefaults.value(forKey: "key111", default: false)
                    }
                    set {
                        ReerDefaults.set(newValue, forKey: "key111")
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testDefaultsMacroExpandsContainer() {
        assertMacroExpansion(
            """
            final class Example {
                @Defaults("key111", false, container: .standard)
                var isAppeared: Bool
            }
            """,
            expandedSource: """
            final class Example {
                var isAppeared: Bool {
                    get {
                        ReerDefaults.value(forKey: "key111", default: false, container: .standard)
                    }
                    set {
                        ReerDefaults.set(newValue, forKey: "key111", container: .standard)
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testDefaultsMacroExpandsOptionalProperty() {
        assertMacroExpansion(
            """
            final class Example {
                @Defaults("title")
                var title: String?
            }
            """,
            expandedSource: """
            final class Example {
                var title: String? {
                    get {
                        ReerDefaults.value(forKey: "title")
                    }
                    set {
                        ReerDefaults.set(newValue, forKey: "title")
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testDefaultsMacroUsesPropertyInitializerAsDefaultValue() {
        assertMacroExpansion(
            """
            final class Example {
                @Defaults("count")
                var count: Int = 7
            }
            """,
            expandedSource: """
            final class Example {
                var count: Int {
                    get {
                        ReerDefaults.value(forKey: "count", default: 7)
                    }
                    set {
                        ReerDefaults.set(newValue, forKey: "count")
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testDefaultsMacroExpandsStaticProperty() {
        assertMacroExpansion(
            """
            final class Example {
                @Defaults("count", 0)
                static var count: Int
            }
            """,
            expandedSource: """
            final class Example {
                static var count: Int {
                    get {
                        ReerDefaults.value(forKey: "count", default: 0)
                    }
                    set {
                        ReerDefaults.set(newValue, forKey: "count")
                    }
                }
            }
            """,
            macros: testMacros
        )
    }

    func testDefaultsMacroDiagnosesUnsupportedNonOptionalPropertyWithoutDefault() {
        assertMacroExpansion(
            """
            final class Example {
                @Defaults("profile")
                var profile: Profile
            }
            """,
            expandedSource: """
            final class Example {
                var profile: Profile
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@Defaults requires a default value for non-optional properties unless the property type has a known default",
                    line: 2,
                    column: 5
                )
            ],
            macros: testMacros
        )
    }

    func testKnownDefaultValuesIncludeSupportedTypes() {
        let expectations = [
            "Int": "0",
            "Int8": "0",
            "Int16": "0",
            "Int32": "0",
            "Int64": "0",
            "Int128": "0",
            "UInt": "0",
            "UInt8": "0",
            "UInt16": "0",
            "UInt32": "0",
            "UInt64": "0",
            "UInt128": "0",
            "Bool": "false",
            "String": "\"\"",
            "Float": "0.0",
            "Double": "0.0",
            "Date": "Date()",
            "Data": "Data()",
            "URL": "URL(string: \"/\")!",
            "UUID": "UUID()",
            "Decimal": "Decimal(0)"
        ]

        for (typeName, defaultValue) in expectations {
            XCTAssertEqual(
                KnownDefaultValues.defaultValue(for: TypeSyntax(stringLiteral: typeName)),
                defaultValue
            )
        }
    }
}

#endif
