//
//  PlanOutOpBinary.swift
//  PlanOutSwift


protocol PlanOutOpBinary: PlanOutOpSimple {
    func binaryExecute(left: Any?, right: Any?) throws -> ResultType?
}

extension PlanOutOpBinary {
    func simpleExecute(_ args: [String: Any?], _ context: PlanOutOpContext) throws -> ResultType? {
        guard let possibleLeftValue = args[PlanOutOperation.Keys.left.rawValue],
            let possibleRightValue = args[PlanOutOperation.Keys.right.rawValue] else {
            throw OperationError.missingArgs(args: "\(PlanOutOperation.Keys.left.rawValue),\(PlanOutOperation.Keys.right.rawValue)",
                                             type: String(describing: Self.self))
        }

        return try binaryExecute(left: possibleLeftValue, right: possibleRightValue)
    }
}
