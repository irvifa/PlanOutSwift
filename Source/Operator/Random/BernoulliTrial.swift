//
//  BernoulliTrial.swift
//  PlanOutSwift


extension PlanOutOperation {
    final class BernoulliTrial: PlanOutOpRandom<Bool> {
        override func randomExecute() throws -> Bool? {
            guard let pValue = args[Keys.probability.rawValue],
                case let Literal.number(probability) = Literal(pValue) else {
                    throw OperationError.missingArgs(args: Keys.probability.rawValue, type: self)
            }

            // ensure that the probability value falls between 0.0 - 1.0
            guard case (0...1.0) = probability else {
                throw OperationError.invalidArgs(expected: "p should be between 0 - 1", got: "\(probability)")
            }

            // checks whether the deterministic-randomly generated value between 0.0 - 1.0 is under or equal to p value.
            return try getUniform() <= probability
        }
    }
}
