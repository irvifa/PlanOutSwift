//
//  BernoulliTrialSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class BernoulliTrialSpec: QuickSpec {
    override func spec() {
        describe("BernoulliTrial random operator") {
            let op = PlanOutOperation.BernoulliTrial()

            itBehavesLike(.randomOperator) { [.op: op] }

            describe("Arguments validation") {
                it("throws if p value does not exist in arguments") {
                    let ctx = SimpleMockContext()
                    let args: [String: Any] = [
                        PlanOutOperation.Keys.unit.rawValue: "x",
                    ]

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("throws if p value is negative") {
                    let ctx = SimpleMockContext()
                    let pValue = -0.2
                    let args: [String: Any] = [
                        PlanOutOperation.Keys.unit.rawValue: "x",
                        PlanOutOperation.Keys.probability.rawValue: pValue
                    ]

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("throws if p value larger than 1.0") {
                    let ctx = SimpleMockContext()
                    let pValue = 1.2
                    let args: [String: Any] = [
                        PlanOutOperation.Keys.unit.rawValue: "x",
                        PlanOutOperation.Keys.probability.rawValue: pValue
                    ]

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }
            }

            describe("Distribution correctness") {
                context("when given zero p value") {
                    it("should always produce false") {
                        let p = 0.0
                        let args = [PlanOutOperation.Keys.probability.rawValue: p]
                        let valueMasses: [(Any, Double)] = [(false, 1.0), (true, 0.0)]

                        distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: valueMasses)
                    }
                }

                context("when given 0.1 p value") {
                    it("should produce true with 10% probability") {
                        let p = 0.1
                        let args = [PlanOutOperation.Keys.probability.rawValue: p]
                        let valueMasses: [(Any, Double)] = [(false, 0.9), (true, 0.1)]

                        distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: valueMasses)
                    }
                }

                context("when given 1.0 p value") {
                    it("should always produce true") {
                        let p = 1.0
                        let args = [PlanOutOperation.Keys.probability.rawValue: p]
                        let valueMasses: [(Any, Double)] = [(false, 0.0), (true, 1.0)]

                        distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: valueMasses)
                    }
                }

                context("when given 0.5 p value") {
                    it("should produce true with 50% probability") {
                        let p = 0.5
                        let args = [PlanOutOperation.Keys.probability.rawValue: p]
                        let valueMasses: [(Any, Double)] = [(false, 0.5), (true, 0.5)]

                        distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: valueMasses)
                    }
                }
            }
        }
    }
}
