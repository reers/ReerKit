import Foundation
import SwiftSyntax

enum KnownDefaultValues {
    private static let values = [
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

    static func defaultValue(for type: TypeSyntax?) -> String? {
        guard let type, !type.isOptional else {
            return nil
        }
        guard let name = type.knownDefaultTypeName else {
            return nil
        }
        return values[name]
    }
}

extension TypeSyntax {
    var isOptional: Bool {
        let type = trimmed
        if type.as(OptionalTypeSyntax.self) != nil ||
            type.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) != nil {
            return true
        }
        if let identifier = type.as(IdentifierTypeSyntax.self) {
            return identifier.name.text == "Optional"
        }
        return false
    }

    var knownDefaultTypeName: String? {
        let type = trimmed
        if let identifier = type.as(IdentifierTypeSyntax.self) {
            return identifier.name.text
        }
        if let member = type.as(MemberTypeSyntax.self) {
            return member.name.text
        }
        if let optional = type.as(OptionalTypeSyntax.self) {
            return optional.wrappedType.knownDefaultTypeName
        }
        if let optional = type.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
            return optional.wrappedType.knownDefaultTypeName
        }
        if let attributed = type.as(AttributedTypeSyntax.self) {
            return attributed.baseType.knownDefaultTypeName
        }
        let description = type.description.trimmingCharacters(in: .whitespacesAndNewlines)
        return description.split(separator: ".").last.map(String.init)
    }
}
