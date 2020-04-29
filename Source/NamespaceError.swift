//
//  NamespaceError.swift
//  PlanOutSwift

enum NamespaceError: Error {
    case missingUnitKeys
    case duplicateDefinition(String)
    case duplicateExperiment(String)
    case definitionNotFound(String)
}

extension NamespaceError: CustomStringConvertible {
    var description: String {
        switch self {
        case .missingUnitKeys:
            return "Unit keys must have at least one element."
        case .duplicateDefinition(let id):
            return "Duplicate definition found with id: \(id)"
        case .duplicateExperiment(let id):
            return "Duplicate experiment found with id: \(id)"
        case .definitionNotFound(let id):
            return "Experiment definition not found: \(id)"
        }
    }
}
