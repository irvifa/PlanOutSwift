//
//  BernoulliFilter.swift
//  PlanOutSwift


extension PlanOutOperation {
    /* Random experiment that filters through a given set of elements
    via randomization with weighted probability.
    The "success" probability (whether the array element should be included or not)
    is controlled through the "p" value, which must be between 0.0 - 1.0.
    The logic is very much like Bernoulli Trial – but for this operation,
    Bernoulli Trial is applied to each array elements and filtered out if it fails the trial.
    */
    final class BernoulliFilter: PlanOutOpRandom<[Any]> {
        override func randomExecute() throws -> [Any]? {
            guard let pValue = args[Keys.probability.rawValue],
                case let Literal.number(probability) = Literal(pValue) else {
                    throw OperationError.missingArgs(args: Keys.probability.rawValue, type: self)
            }

            // ensure that the probability value falls between 0.0 - 1.0
            guard case (0...1.0) = probability else {
                throw OperationError.invalidArgs(expected: "p should be between 0 - 1", got: "\(probability)")
            }

            // based on the implementation in Python and planout4j, having nil or empty choices returns empty array instead of throwing and error.
            guard let choices = args[Keys.choices.rawValue] as? [Any], !choices.isEmpty else {
                return []
            }

            // filter the list of arrays based on bernoulli trial on each elements.
            return try choices.filter { try getUniform(appendedUnit: $0) <= probability }
        }
    }
}
