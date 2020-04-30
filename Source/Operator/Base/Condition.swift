//
//  Condition.swift
//  PlanOutSwift


extension PlanOutOperation {
    // Simple if-then operation. `then` value is returned if the `if` value evaluates to true.
    final class Condition: PlanOutOp {
        func execute(_ args: [String : Any], _ context: PlanOutOpContext) throws -> Any? {
            guard let conditions = args[Keys.conditions.rawValue] as? [[String: Any]] else {
                throw OperationError.missingArgs(args: Keys.conditions.rawValue, type: self)
            }

            for condition in conditions {
                // validate argument existence.
                guard let ifValue = condition[Keys.ifCondition.rawValue] else {
                    throw OperationError.missingArgs(args: Keys.ifCondition.rawValue, type: self)
                }

                guard let thenValue = condition[Keys.thenCondition.rawValue] else {
                    throw OperationError.missingArgs(args: Keys.thenCondition.rawValue, type: self)
                }

                if let evaluatedIf = try context.evaluate(ifValue), Literal(evaluatedIf).boolValue == true {
                    return try context.evaluate(thenValue)
                }
            }

            return nil
        }
    }
}
