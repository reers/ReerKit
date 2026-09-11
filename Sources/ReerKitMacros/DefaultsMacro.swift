import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DefaultsMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        guard let variableDecl = declaration.as(VariableDeclSyntax.self),
              variableDecl.bindingSpecifier.tokenKind == .keyword(.var),
              variableDecl.bindings.count == 1,
              let binding = variableDecl.bindings.first,
              binding.pattern.as(IdentifierPatternSyntax.self) != nil,
              binding.accessorBlock == nil
        else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DefaultsDiagnostic.requiresStoredVar))
            return []
        }

        guard variableDecl.isInstanceProperty else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DefaultsDiagnostic.requiresInstanceVar))
            return []
        }

        let arguments = DefaultsArguments(attribute: node)
        guard let key = arguments.key else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DefaultsDiagnostic.requiresKey))
            return []
        }

        let initializerDefault = binding.initializer?.value.description.trimmingCharacters(in: .whitespacesAndNewlines)
        let knownTypeDefault = KnownDefaultValues.defaultValue(for: binding.typeAnnotation?.type)
        let defaultValue = arguments.defaultValue ?? initializerDefault ?? knownTypeDefault
        let isOptional = binding.typeAnnotation?.type.isOptional == true

        guard defaultValue != nil || isOptional else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DefaultsDiagnostic.requiresDefaultValue))
            return []
        }

        let containerArgument = arguments.container.map { ", container: \($0)" } ?? ""
        let getterExpression: String
        if let defaultValue {
            getterExpression = "ReerDefaults.value(forKey: \(key), default: \(defaultValue)\(containerArgument))"
        } else {
            getterExpression = "ReerDefaults.value(forKey: \(key)\(containerArgument))"
        }

        return [
            """
            get {
                \(raw: getterExpression)
            }
            """,
            """
            set {
                ReerDefaults.set(newValue, forKey: \(raw: key)\(raw: containerArgument))
            }
            """
        ]
    }
}

private struct DefaultsArguments {
    var key: String?
    var defaultValue: String?
    var container: String?

    init(attribute: AttributeSyntax) {
        guard case let .argumentList(arguments) = attribute.arguments else {
            return
        }

        var positionalIndex = 0
        for argument in arguments {
            let expression = argument.expression.description.trimmingCharacters(in: .whitespacesAndNewlines)
            if argument.label?.text == "container" {
                container = expression
                continue
            }

            guard argument.label == nil else {
                continue
            }

            switch positionalIndex {
            case 0:
                key = expression
            case 1:
                defaultValue = expression
            default:
                break
            }
            positionalIndex += 1
        }
    }
}

private enum DefaultsDiagnostic: DiagnosticMessage {
    case requiresStoredVar
    case requiresInstanceVar
    case requiresKey
    case requiresDefaultValue

    var message: String {
        switch self {
        case .requiresStoredVar:
            return "@Defaults can only be attached to a single stored var property"
        case .requiresInstanceVar:
            return "@Defaults can only be attached to an instance var property"
        case .requiresKey:
            return "@Defaults requires a UserDefaults key"
        case .requiresDefaultValue:
            return "@Defaults requires a default value for non-optional properties unless the property type has a known default"
        }
    }

    var diagnosticID: MessageID {
        switch self {
        case .requiresStoredVar:
            return MessageID(domain: "ReerKitMacros", id: "defaultsRequiresStoredVar")
        case .requiresInstanceVar:
            return MessageID(domain: "ReerKitMacros", id: "defaultsRequiresInstanceVar")
        case .requiresKey:
            return MessageID(domain: "ReerKitMacros", id: "defaultsRequiresKey")
        case .requiresDefaultValue:
            return MessageID(domain: "ReerKitMacros", id: "defaultsRequiresDefaultValue")
        }
    }

    var severity: DiagnosticSeverity {
        return .error
    }
}
