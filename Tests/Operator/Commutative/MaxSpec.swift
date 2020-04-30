//
//  MaxSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class MaxSpec: QuickSpec {
    override func spec() {
        describe("Max commutative operator") {
            let op = PlanOutOperation.Max()

            itBehavesLike(.commutativeOperator) { [.op: op] }

            it("returns the max value of values from the arguments") {
                let values = [1, -2.0, 3.0]
                var result: Double?

                expect { result = try op.execute(commutativeArgsBuilder(values), Interpreter()) }.toNot(throwError())

                expect(result!).to(equal(3.0))
            }
        }
    }
}
