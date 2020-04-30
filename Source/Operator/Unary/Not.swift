//
//  Not.swift
//  PlanOutSwift


extension PlanOutOperation {
    // Return the opposite of given boolean value.
    final class Not: PlanOutOpUnary {
        typealias ResultType = Bool

        func unaryExecute(_ value: Any?) throws -> Bool? {
            guard let thisValue = value else {
                return true
            }
            
            return !Literal(thisValue).boolValue
        }
    }
}
