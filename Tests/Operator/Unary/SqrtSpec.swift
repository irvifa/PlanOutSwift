//
//  SqrtSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class SqrtSpec: QuickSpec {
    override func spec() {
        describe("Sqrt unary operator") {
            let op = PlanOutOperation.Sqrt()

            itBehavesLike(.unaryOperator) { [.op: op] }

            itBehavesLike(.numericOperator) { [.op: op, .argKeys: [PlanOutOperation.Keys.value.rawValue]] }
            
            it("returns the sqrt value of 1") {
                let value = 1.0
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(1.0))
            }
            
            it("returns the sqrt value of 0.123") {
                let value = 0.123
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(0.3507135583350036))
            }
            
            it("returns the exp value of 1.88") {
                let value = 1.88
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(1.3711309200802089))
            }
            
            it("returns the exp value of -0.5 throw error") {
                let value = -0.5
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.to(throwError())
            }
        }
    }
}
