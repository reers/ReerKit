import Foundation
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct ReerKitMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AssociatedValueMacro.self,
        DefaultsMacro.self
    ]
}

public struct AssociatedValueMacro: AccessorMacro {
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
            context.diagnose(Diagnostic(node: Syntax(node), message: AssociatedValueDiagnostic.requiresStoredVar))
            return []
        }

        guard variableDecl.isInstanceProperty else {
            context.diagnose(Diagnostic(node: Syntax(node), message: AssociatedValueDiagnostic.requiresInstanceVar))
            return []
        }

        let arguments = AssociatedValueArguments(attribute: node)
        guard !arguments.hasDefaultValueArgument else {
            context.diagnose(Diagnostic(node: Syntax(node), message: AssociatedValueDiagnostic.usesDefaultValueArgument))
            return []
        }

        let key = "AssociationKey(#function as StaticString)"
        let initializerDefault = binding.initializer?.value.description.trimmingCharacters(in: .whitespacesAndNewlines)
        let knownTypeDefault = KnownDefaultValues.defaultValue(for: binding.typeAnnotation?.type)
        let defaultValue = initializerDefault ?? knownTypeDefault
        let getterExpression: String
        if let defaultValue {
            getterExpression = "re.associatedValue(forKey: \(key), default: \(defaultValue))"
        } else {
            getterExpression = "re.associatedValue(forKey: \(key))"
        }

        return [
            """
            get {
                \(raw: getterExpression)
            }
            """,
            """
            set {
                re.setAssociatedValue(newValue, forKey: \(raw: key), withPolicy: \(raw: arguments.policy))
            }
            """
        ]
    }
}

extension VariableDeclSyntax {
    var isInstanceProperty: Bool {
        return !modifiers.contains { modifier in
            modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
        }
    }
}

private struct AssociatedValueArguments {
    var policy = ".retain"
    var hasDefaultValueArgument = false

    init(attribute: AttributeSyntax) {
        guard case let .argumentList(arguments) = attribute.arguments else {
            return
        }

        for argument in arguments {
            let expression = argument.expression.description.trimmingCharacters(in: .whitespacesAndNewlines)
            switch argument.label?.text {
            case "policy":
                policy = expression
            case "default", "defaultValue":
                hasDefaultValueArgument = true
            case nil:
                hasDefaultValueArgument = true
            default:
                continue
            }
        }
    }
}

private enum AssociatedValueDiagnostic: DiagnosticMessage {
    case requiresStoredVar
    case requiresInstanceVar
    case usesDefaultValueArgument

    var message: String {
        switch self {
        case .requiresStoredVar:
            return "@AssociatedValue can only be attached to a single stored var property"
        case .requiresInstanceVar:
            return "@AssociatedValue can only be attached to an instance var property"
        case .usesDefaultValueArgument:
            return "@AssociatedValue default value should be provided with the property initializer"
        }
    }

    var diagnosticID: MessageID {
        switch self {
        case .requiresStoredVar:
            return MessageID(domain: "ReerKitMacros", id: "requiresStoredVar")
        case .requiresInstanceVar:
            return MessageID(domain: "ReerKitMacros", id: "requiresInstanceVar")
        case .usesDefaultValueArgument:
            return MessageID(domain: "ReerKitMacros", id: "usesDefaultValueArgument")
        }
    }

    var severity: DiagnosticSeverity {
        return .error
    }
}
