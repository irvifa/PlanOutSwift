//
//  Set.swift
//  PlanOutSwift


extension PlanOutOperation {
    /// Assign value to the provided context.
    final class Set: PlanOutOp {
        @discardableResult
        func execute(_ args: [String : Any], _ context: PlanOutOpContext) throws -> Any? {
            guard let variableName = args[Keys.variable.rawValue] as? String else {
                throw OperationError.missingArgs(args: Keys.variable.rawValue, type: String(describing: self.self))
            }

            guard let value = args[Keys.value.rawValue] else {
                throw OperationError.missingArgs(args: Keys.value.rawValue, type: String(describing: self.self))
            }

            if let evaluatedValue = try context.evaluate(value) {
                try context.set(variableName, value: evaluatedValue)
            }
            
            return nil
        }
    }
}
