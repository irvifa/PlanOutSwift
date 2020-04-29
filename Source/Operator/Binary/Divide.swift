//
//  Divide.swift
//  PlanOutSwift


extension PlanOutOperation {
    // Division operation
    final class Divide: PlanOutOpBinary {
        typealias ResultType = Double

        func binaryExecute(left: Any?, right: Any?) throws -> Double? {
            guard let leftValue = left,
                let rightValue = right,
                case let (Literal.number(leftNumber), Literal.number(rightNumber)) = (Literal(leftValue), Literal(rightValue)) else {
                    throw OperationError.typeMismatch(expected: "Numeric", got: "\(String(describing: left)) and \(String(describing: right))")
            }

            return leftNumber / rightNumber
        }
    }
}
