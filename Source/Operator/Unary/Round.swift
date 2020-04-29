//
//  Round.swift
//  PlanOutSwift


extension PlanOutOperation {
    // Rounds a given double value.
    final class Round: PlanOutOpUnary {
        typealias ResultType = Double

        func unaryExecute(_ value: Any?) throws -> Double? {
            guard let someValue = value, case let Literal.number(numericValue) = Literal(someValue) else {
                throw OperationError.typeMismatch(expected: "Numeric", got: String(describing: value))
            }

            return numericValue.rounded()
        }
    }
}
