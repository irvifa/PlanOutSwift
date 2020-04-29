//
//  Negative.swift
//  PlanOutSwift


extension PlanOutOperation {
    /// Turns the given value into negative, or vice versa.
    final class Negative: PlanOutOpUnary {
        typealias ResultType = Double

        func unaryExecute(_ value: Any?) throws -> Double? {
            guard let someValue = value else {
                throw OperationError.typeMismatch(expected: "Numeric", got: "nil")
            }

            guard case let Literal.number(numericValue) = Literal(someValue) else {
                throw OperationError.typeMismatch(expected: "Numeric", got: String(describing: someValue))
            }

            return 0 - numericValue
        }
    }
}
