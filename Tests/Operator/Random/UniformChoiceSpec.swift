//
//  UniformChoiceSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class UniformChoiceSpec: QuickSpec {
    override func spec() {
        describe("UniformChoice random operator") {
            let op = PlanOutOperation.UniformChoice()

            itBehavesLike(.randomOperator) { [.op: op] }

            describe("Arguments validation") {
                it("returns nil when choices does not exist in argument") {
                    let ctx = SimpleMockContext()
                    let args: [String: Any] = [
                        PlanOutOperation.Keys.unit.rawValue: "x",
                    ]
                    var result: Any?

                    expect { result = try op.execute(args, ctx) }.toNot(throwError())
                    expect(result).to(beNil())
                }

                it("returns nil when choices is empty") {
                    let ctx = SimpleMockContext()
                    let choices: [Any] = []
                    let args: [String: Any] = [
                        PlanOutOperation.Keys.unit.rawValue: "x",
                        PlanOutOperation.Keys.choices.rawValue: choices
                    ]
                    var result: Any?

                    expect { result = try op.execute(args, ctx) }.toNot(throwError())
                    expect(result).to(beNil())
                }
            }

            describe("Distribution correctness") {
                it("always produce 100% distribution for single choices") {
                    let choices = [1]
                    let args = [PlanOutOperation.Keys.choices.rawValue: choices]

                    distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: [(1, 1)])
                }

                it("produces 50% distribution for two choices") {
                    let choices = ["a", "b"]
                    let args = [PlanOutOperation.Keys.choices.rawValue: choices]
                    let valueMasses: [(Any, Double)] = [("a", 0.5), ("b", 0.5)]

                    distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: valueMasses)
                }

                it("produces uniform distribution for multiple choices") {
                    let choices = [1, 2, 3, 4]
                    let args = [PlanOutOperation.Keys.choices.rawValue: choices]
                    let valueMasses: [(Any, Double)] = [
                        (1, 0.25),
                        (2, 0.25),
                        (3, 0.25),
                        (4, 0.25)
                    ]

                    distributionTester(RandomOperatorBuilder(op: op, args: args), valueMass: valueMasses)
                }
            }
        }
    }
}
