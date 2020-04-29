//
//  And.swift
//  PlanOutSwift


extension PlanOutOperation {
    // AND operator for multiple values.
    final class And: PlanOutOp {
        func execute(_ args: [String : Any], _ context: PlanOutOpContext) throws -> Bool? {
            guard let values = args[Keys.values.rawValue] as? [Any] else {
                throw OperationError.missingArgs(args: Keys.values.rawValue, type: self)
            }

            for value in values {
                let evaluated: Any? = try context.evaluate(value)

                guard evaluated != nil else {
                    return false
                }

                if let result = evaluated, !Literal(result).boolValue {
                    return false
                }
            }

            return true
        }
    }
}
