//
//  Equals.swift
//  PlanOutSwift


extension PlanOutOperation {
    // Check equality between two literal types.
    final class Equals: PlanOutOpBinary {
        typealias ResultType = Bool

        func binaryExecute(left: Any?, right: Any?) throws -> Bool? {
            if let leftValue = left, let rightValue = right {
                return Literal(leftValue) == Literal(rightValue)
            }

            return (left == nil && right == nil)
        }
    }
}
