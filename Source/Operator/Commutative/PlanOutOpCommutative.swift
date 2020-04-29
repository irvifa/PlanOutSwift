//
//  PlanOutOpCommutative.swift
//  PlanOutSwift


protocol PlanOutOpCommutative: PlanOutOpSimple where ResultType == Double {
    func commutativeExecute(_ values: [Double]) throws -> Double?
}

extension PlanOutOpCommutative {
    func simpleExecute(_ args: [String : Any?], _ context: PlanOutOpContext) throws -> Double? {
        guard let values = args[PlanOutOperation.Keys.values.rawValue] as? [Any] else {
            throw OperationError.missingArgs(args: PlanOutOperation.Keys.values.rawValue, type: self)
        }

        let doubleValues: [Double] = try values.map { value in
            guard case let Literal.number(doubleValue) = Literal(value) else {
                throw OperationError.typeMismatch(expected: "Numeric literal", got: String(describing: value))
            }
            return doubleValue
        }

        return try commutativeExecute(doubleValues)
    }
}


extension PlanOutOperation {
    final class Product: PlanOutOpCommutative {
        func commutativeExecute(_ values: [Double]) throws -> Double? {
            return values.reduce(1, *)
        }
    }

    final class Sum: PlanOutOpCommutative {
        func commutativeExecute(_ values: [Double]) throws -> Double? {
            return values.reduce(0, +)
        }
    }

    final class Min: PlanOutOpCommutative {
        func commutativeExecute(_ values: [Double]) throws -> Double? {
            return values.min()
        }
    }

    final class Max: PlanOutOpCommutative {
        func commutativeExecute(_ values: [Double]) throws -> Double? {
            return values.max()
        }
    }
}
