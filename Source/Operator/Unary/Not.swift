//
//  Not.swift
//  PlanOutSwift


extension PlanOutOperation {
    /// Returns the opposite of given boolean value.
    final class Not: PlanOutOpUnary {
        typealias ResultType = Bool

        func unaryExecute(_ value: Any?) throws -> Bool? {
            guard let someValue = value else {
                return true
            }
            
            return !Literal(someValue).boolValue
        }
    }
}
