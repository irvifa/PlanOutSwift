//
//  BernoulliTrial.swift
//  PlanOutSwift


extension PlanOutOperation {
    /* Random experiment with two possible outcomes: "success" or "failure".
     The "success" probability is configurable through the "p" value – which is short for "probability".
     - Given `p=0.5`, this produces a randomization with 50% probability of getting "success" (e.g. coin toss).
     - Given `p=0.166`, the trial is akin to a dice toss, where 6 equals to "success".

     - seealso:
     https://en.wikipedia.org/wiki/Bernoulli_trial
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
