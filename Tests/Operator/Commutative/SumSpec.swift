//
//  SumSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class SumSpec: QuickSpec {
    override func spec() {
        describe("Sum commutative operator") {
            let op = PlanOutOperation.Sum()

            itBehavesLike(.commutativeOperator) { [.op: op] }

            it("returns the sum of the values from arguments") {
                let values = [1, 2.0, 3.0]
                var result: Double?

                expect { result = try op.execute(commutativeArgsBuilder(values), Interpreter()) }.toNot(throwError())

                expect(result!).to(equal(6.0))
            }
        }
    }
}
