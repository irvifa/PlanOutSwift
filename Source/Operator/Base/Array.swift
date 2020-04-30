//
//  Array.swift
//  PlanOutSwift


extension PlanOutOperation {
    // Converts an array of value into an array of evaluated values.
    final class Array: PlanOutOp {
        func execute(_ args: [String : Any], _ context: PlanOutOpContext) throws -> [Any?]? {
            guard let values = args[Keys.values.rawValue] as? [Any] else {
                throw OperationError.missingArgs(args: Keys.values.rawValue, type: self)
            }

            return try values.map { try context.evaluate($0) ?? nil }
        }
    }
}
