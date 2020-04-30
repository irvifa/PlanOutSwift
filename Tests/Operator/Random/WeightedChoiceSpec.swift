//
//  WeightedChoiceSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class WeightedChoiceSpec: QuickSpec {
    override func spec() {
        describe("WeightedChoice random operator") {
            let op = PlanOutOperation.WeightedChoice()

            itBehavesLike(.randomOperator) { [.op: op] }

            describe("Argument validation") {
                context("when choices does not exist") {
                    it("returns nil") {
                        let ctx = SimpleMockContext()
                        let weights = [1, 1, 1, 1]
                        let args: [String: Any] = [
                            PlanOutOperation.Keys.unit.rawValue: "x",
                            PlanOutOperation.Keys.weights.rawValue: weights
                        ]
                        var result: Any?

                        expect { result = try op.execute(args, ctx) }.toNot(throwError())
                        expect(result).to(beNil())
                    }
                }

                context("when weights does not exist") {
                    it("returns nil") {
                        let ctx = SimpleMockContext()
                        let choices = [1, 2, 3]
                        let args: [String: Any] = [
                            PlanOutOperation.Keys.unit.rawValue: "x",
                            PlanOutOperation.Keys.choices.rawValue: choices
                        ]
                        var result: Any?

                        expect { result = try op.execute(args, ctx) }.toNot(throwError())
                        expect(result).to(beNil())
                    }
                }

                context("when choices are empty") {
                    it("returns nil") {
                        let ctx = SimpleMockContext()
                        let choices: [Any] = []
                        let weights = [1, 1, 1, 1]
                        let args: [String: Any] = [
                            PlanOutOperation.Keys.unit.rawValue: "x",
                            PlanOutOperation.Keys.choices.rawValue: choices,
                            PlanOutOperation.Keys.weights.rawValue: weights
                        ]
                        var result: Any?

                        expect { result = try op.execute(args, ctx) }.toNot(throwError())
                        expect(result).to(beNil())
                    }
                }

                context("when number of choices is different with number of weights") {
                    it("throws error") {
                        let ctx = SimpleMockContext()
                        let choices = [1, 2, 3]
                        let weights = [1, 1, 1, 1]
                        let args: [String: Any] = [
                            PlanOutOperation.Keys.unit.rawValue: "x",
                            PlanOutOperation.Keys.choices.rawValue: choices,
                            PlanOutOperation.Keys.weights.rawValue: weights
                        ]

                        expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                    }
                }
            }

            describe("Distribution correctness") {
                context("when given only one choice") {
                    it("should always returns the only available choice") {
                        let weightedChoices: [(Any, Double)] = [("a", 1)]

                        let choices = weightedChoices.map { $0.0 }
                        let weights = weightedChoices.map { $0.1 }
                        let args = [
                            PlanOutOperation.Keys.choices.rawValue: choices,
                            PlanOutOperation.Keys.weights.rawValue: weights
                        ]

                        distributionTester(RandomOperatorBuilder(op: op, args: args),
                                           valueMass: weightedChoices)
                    }
                }

                context("when there are two choices with different weights") {
                    it("produces value according to the assigned weights") {
                        let weightedChoices: [(Any, Double)] = [
                            ("a", 1),
                            ("b", 2)
                        ]

                        let choices = weightedChoices.map { $0.0 }
                        let weights = weightedChoices.map { $0.1 }
                        let args = [
                            PlanOutOperation.Keys.choices.rawValue: choices,
                            PlanOutOperation.Keys.weights.rawValue: weights
                        ]

                        distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: weightedChoices)
                    }
                }

                context("when a choice with zero weight exists") {
                    it("should never produce a choices with zero weights") {
                        let weightedChoices: [(Any, Double)] = [
                            ("a", 0),
                            ("b", 2),
                            ("c", 0)
                        ]

                        let choices = weightedChoices.map { $0.0 }
                        let weights = weightedChoices.map { $0.1 }
                        let args = [
                            PlanOutOperation.Keys.choices.rawValue: choices,
                            PlanOutOperation.Keys.weights.rawValue: weights
                        ]

                        distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: weightedChoices)
                    }
                }

                context("when the same choice appears more than once in the list") {
                    it("should produce duplicated values using the sum of the weights") {
                        let weightedChoices: [(Any, Double)] = [
                            ("a", 1),
                            ("b", 2),
                            ("c", 0),
                            ("a", 2)
                        ]

                        let valueMasses: [(Any, Double)] = [("a", 3), ("b", 2), ("c", 0)]

                        let choices = weightedChoices.map { $0.0 }
                        let weights = weightedChoices.map { $0.1 }
                        let args = [
                            PlanOutOperation.Keys.choices.rawValue: choices,
                            PlanOutOperation.Keys.weights.rawValue: weights
                        ]

                        distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: valueMasses)
                    }
                }
            }
        }
    }
}

