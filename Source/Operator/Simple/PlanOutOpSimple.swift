//
//  PlanOutOpSimple.swift
//  PlanOutSwift


/// Evaluates all arguments before the operator is executed.
///
/// Operator will evaluate all arguments recursively through `PlanOutOpContext`, before simpleExecute is called.
protocol PlanOutOpSimple: PlanOutOp {
    func simpleExecute(_ args: [String: Any?], _ context: PlanOutOpContext) throws -> ResultType?
}

extension PlanOutOpSimple {
    /// Default implementation that evaluates all provided arguments before calling `simpleExecute`.
    ///
    /// - Parameters:
    ///   - args: Operation arguments
    ///   - context: PlanOut operation context
    /// - Returns: Value from executed operation
    /// - Throws: OperationError
    func execute(_ args: [String: Any], _ context: PlanOutOpContext) throws -> ResultType? {
        // evaluate all arguments first.
        var evaluatedArgs: [String: Any] = [:]
        try args.forEach { key, value in
            // use updateValue instead of setting the value through subscripting.
            // when dealing with nil values, setting the value through subscripting will remove the key instead of preserving nil values for that key.
            let evaluatedValue = try context.evaluate(value) as Any
            evaluatedArgs.updateValue(evaluatedValue, forKey: key)
        }

        return try simpleExecute(evaluatedArgs, context)
    }
}
