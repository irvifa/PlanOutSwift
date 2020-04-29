//
//  OperationError.swift
//  PlanOutSwift


public enum OperationError: Error {
    case stop(_ shouldLogExposure: Bool)
    case missingArgs(args: String, type: Any)
    case typeMismatch(expected: String, got: String)
    case unknownOperator(String)
    case invalidArgs(expected: String, got: String)
    case missingContext(Any)
    case unexpected(_ message: String)
}

extension OperationError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .missingArgs(let args, let type):
            return "Expected arguments: \(args) for operator type: \(String(describing: type))"
        case .typeMismatch(let expectedType, let gottenType):
            return "Expected value of type \(expectedType), but got \(gottenType) instead"
        case .unknownOperator(let operatorType):
            return "Unknown operator type \(operatorType)"
        case .invalidArgs(let expectedValue, let gottenValue):
            return "Expected value: \(expectedValue), but got: \(gottenValue)"
        case .missingContext(let type):
            return "PlanOutOpContext not found for type: \(String(describing: type))"
        case .unexpected(let message):
            return "Unexpected error: \(message)"
        default:
            return "PlanOut operation explicitly stopped"
        }
    }
}
