//
//  ModSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class ModSpec: QuickSpec {
    override func spec() {
        describe("Mod binary operator") {
            let op = PlanOutOperation.Mod()

            itBehavesLike(.binaryOperator) { [.op: op] }
            
            itBehavesLike(.numericOperator) { [.op: op,
                                               .argKeys: [PlanOutOperation.Keys.left.rawValue,
                                                          PlanOutOperation.Keys.right.rawValue]] }

            it("returns the remainder value from the argument") {
                let left = 4
                let right = 3
                let args = binaryArgsBuilder(left, right)
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(1.0))
            }

            it("throws when values are nil") {
                let left: Any? = nil
                let right: Any? = nil
                let args = binaryArgsBuilder(left as Any, right as Any)

                expect { try op.execute(args, Interpreter()) }.to(throwError(errorType: OperationError.self))
            }
        }
    }
}
