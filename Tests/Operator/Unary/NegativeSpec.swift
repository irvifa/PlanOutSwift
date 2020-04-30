//
//  NegativeSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class NegativeSpec: QuickSpec {
    override func spec() {
        describe("Negative unary operator") {
            let op = PlanOutOperation.Negative()

            itBehavesLike(.unaryOperator) { [.op: op] }
            
            itBehavesLike(.numericOperator) { [.op: op, .argKeys: [PlanOutOperation.Keys.value.rawValue]] }

            it("turns positive value to negative") {
                let value = 1
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(-1.0))
            }

            it("turns negative value to positive") {
                let value = -300.0
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(300.0))
            }

            it("throws when given nil values") {
                let value: Any? = nil
                let args: [String: Any] = [PlanOutOperation.Keys.value.rawValue: value as Any]

                expect { try op.execute(args, Interpreter()) }.to(throwError(errorType: OperationError.self))
            }
        }
    }
}
