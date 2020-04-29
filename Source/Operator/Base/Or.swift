//
//  Or.swift
//  PlanOutSwift


extension PlanOutOperation {
    /// OR operator for multiple values.
    final class Or: PlanOutOp {
        func execute(_ args: [String : Any], _ context: PlanOutOpContext) throws -> Bool? {
            guard let values = args[Keys.values.rawValue] as? [Any] else {
                throw OperationError.missingArgs(args: Keys.values.rawValue, type: self)
            }

            for value in values {
                if let evaluated = try context.evaluate(value),
                    Literal(evaluated).boolValue {
                    return true
                }
            }

            return false
        }
    }
}
