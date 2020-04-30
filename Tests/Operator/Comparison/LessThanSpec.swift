//
//  LessThanSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class LessThanSpec: QuickSpec {
    override func spec() {
        describe("LessThan comparison operator") {
            let op = PlanOutOperation.LessThan()

            itBehavesLike(.comparisonOperator) { [.op: op] }

            context("when comparing numeric types") {
                it("returns true if left value is less than right value") {
                    let left = 1
                    let right = 2
                    var result: Bool?

                    expect { result = try op.execute(binaryArgsBuilder(left, right), Interpreter()) }.toNot(throwError())
                    expect(result!) == true
                }

                it("returns false if left value equals to right value") {
                    let left = 2
                    let right = 2
                    var result: Bool?

                    expect { result = try op.execute(binaryArgsBuilder(left, right), Interpreter()) }.toNot(throwError())
                    expect(result!) == false
                }

                it("returns false if left value is greater than right value") {
                    let left = 3.0
                    let right = 2.0
                    var result: Bool?

                    expect { result = try op.execute(binaryArgsBuilder(left, right), Interpreter()) }.toNot(throwError())
                    expect(result!) == false
                }
            }

            context("when comparing numeric types with different concrete types") {
                it("returns true if left value is less than right value") {
                    let left = 1.0
                    let right = 2
                    var result: Bool?

                    expect { result = try op.execute(binaryArgsBuilder(left, right), Interpreter()) }.toNot(throwError())
                    expect(result!) == true
                }

                it("returns false if left value equals to right value") {
                    let left = 2.0
                    let right = 2
                    var result: Bool?

                    expect { result = try op.execute(binaryArgsBuilder(left, right), Interpreter()) }.toNot(throwError())
                    expect(result!) == false
                }

                it("returns false if left value is greater than right value") {
                    let left = 3.0
                    let right = 2
                    var result: Bool?

                    expect { result = try op.execute(binaryArgsBuilder(left, right), Interpreter()) }.toNot(throwError())
                    expect(result!) == false
                }
            }

            context("when comparing string types") {
                it("returns true if the alphabetical order of left value is less than the right value") {
                    let left = "abc"
                    let right = "def"
                    var result: Bool?

                    expect { result = try op.execute(binaryArgsBuilder(left, right), Interpreter()) }.toNot(throwError())
                    expect(result!) == true
                }

                it("returns false if alphabetical order of left value equals to right value") {
                    let left = "abc"
                    let right = "abc"
                    var result: Bool?

                    expect { result = try op.execute(binaryArgsBuilder(left, right), Interpreter()) }.toNot(throwError())
                    expect(result!) == false
                }

                it("returns false if alphabetical order of left value is greater than right value") {
                    let left = "def"
                    let right = "abc"
                    var result: Bool?

                    expect { result = try op.execute(binaryArgsBuilder(left, right), Interpreter()) }.toNot(throwError())
                    expect(result!) == false
                }
            }
        }
    }
}
