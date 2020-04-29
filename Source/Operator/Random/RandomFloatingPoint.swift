//
//  RandomFloatingPoint.swift
//  PlanOutSwift


extension PlanOutOperation {
    final class RandomFloatingPoint: PlanOutOpRandom<Double> {
        override func randomExecute() throws -> Double? {
            guard let minValue = args[Keys.min.rawValue] as? Double,
                let maxValue = args[Keys.max.rawValue] as? Double else {
                    throw OperationError.missingArgs(args: "\(Keys.min.rawValue),\(Keys.max.rawValue)", type: self)
            }

            guard minValue <= maxValue else {
                throw OperationError.invalidArgs(expected: "minValue <= maxValue", got: "min: \(minValue), max: \(maxValue)")
            }

            return try getUniform(minValue: minValue, maxValue: maxValue)
        }
    }
}
