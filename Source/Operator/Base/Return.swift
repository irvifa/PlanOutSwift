//
//  Return.swift
//  PlanOutSwift


extension PlanOutOperation {
    // Throws an exception/immediate return.
    final class Return: PlanOutOp {
        func execute(_ args: [String : Any], _ context: PlanOutOpContext) throws -> Any? {
            var shouldLogExposure: Bool = false

            if let value = args[Keys.value.rawValue],
                let evaluatedValue = try context.evaluate(value) {
                shouldLogExposure = Literal(evaluatedValue).boolValue
            }

            throw OperationError.stop(shouldLogExposure)
        }
    }
}
