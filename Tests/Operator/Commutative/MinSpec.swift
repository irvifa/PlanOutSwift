//
//  MinSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class MinSpec: QuickSpec {
    override func spec() {
        describe("Min commutative operator") {
            let op = PlanOutOperation.Min()

            itBehavesLike(.commutativeOperator) { [.op: op] }

            it("returns the min value of values from the arguments") {
                let values = [1, -2.0, 3.0]
                var result: Double?

                expect { result = try op.execute(commutativeArgsBuilder(values), Interpreter()) }.toNot(throwError())

                expect(result!).to(equal(-2.0))
            }
        }
    }
}
