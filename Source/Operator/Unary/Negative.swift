//
//  Negative.swift
//  PlanOutSwift


extension PlanOutOperation {
    // Convert the given value into negative, or vice versa.
    final class Negative: PlanOutOpUnary {
        typealias ResultType = Double

        func unaryExecute(_ value: Any?) throws -> Double? {
            guard let thisValue = value else {
                throw OperationError.typeMismatch(expected: "Numeric", got: "nil")
            }

            guard case let Literal.number(numericValue) = Literal(thisValue) else {
                throw OperationError.typeMismatch(expected: "Numeric", got: String(describing: thisValue))
            }

            return 0 - numericValue
        }
    }
}
