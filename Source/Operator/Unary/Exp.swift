//
//  Exp.swift
//  PlanOutSwift

extension PlanOutOperation {
    // Round a given double value.
    final class Exp: PlanOutOpUnary {
        typealias ResultType = Double

        func unaryExecute(_ value: Any?) throws -> Double? {
            guard let thisValue = value, case let Literal.number(numericValue) = Literal(thisValue) else {
                throw OperationError.typeMismatch(expected: "Numeric", got: String(describing: value))
            }

            return Foundation.exp(numericValue)
        }
    }
}
