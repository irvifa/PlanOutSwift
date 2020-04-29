//
//  LiteralOperation.swift
//  PlanOutSwift

extension PlanOutOperation {
    /// Return value from the given argument.
    final class LiteralOperation: PlanOutOp {
        typealias ResultType = Any

        func execute(_ args: [String : Any], _ context: PlanOutOpContext) throws -> Any? {
            return args[Keys.value.rawValue]
        }
    }
}

