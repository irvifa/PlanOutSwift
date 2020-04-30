//
//  BernoulliFilterSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class BernoulliFilterSpec: QuickSpec {
    override func spec() {
        describe("BernoulliFilter random operator") {
            let op = PlanOutOperation.BernoulliFilter()

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

                it("returns empty array if choices does not exist in argument") {
                    let ctx = SimpleMockContext()
                    let pValue = 0.5
                    let args: [String: Any] = [
                        PlanOutOperation.Keys.unit.rawValue: "x",
                        PlanOutOperation.Keys.probability.rawValue: pValue
                    ]

                    var result: Any?

                    expect { result = try op.execute(args, ctx) }.toNot(throwError())
                    expect((result as! [Any])).to(beEmpty())
                }

                it("returns empty array if choices is empty") {
                    let ctx = SimpleMockContext()
                    let choices: [Any] = []
                    let pValue = 0.5
                    let args: [String: Any] = [
                        PlanOutOperation.Keys.unit.rawValue: "x",
                        PlanOutOperation.Keys.choices.rawValue: choices,
                        PlanOutOperation.Keys.probability.rawValue: pValue
                    ]

                    var result: Any?

                    expect { result = try op.execute(args, ctx) }.toNot(throwError())
                    expect((result as! [Any])).to(beEmpty())
                }
            }

            describe("Distribution correctness") {
                // TODO: How to test Bernoulli Filter distribution correctness?
            }
        }
    }
}

