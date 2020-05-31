//
//  ExpSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class ExpSpec: QuickSpec {
    override func spec() {
        describe("Exp unary operator") {
            let op = PlanOutOperation.Exp()

            itBehavesLike(.unaryOperator) { [.op: op] }

            itBehavesLike(.numericOperator) { [.op: op, .argKeys: [PlanOutOperation.Keys.value.rawValue]] }
            
            it("returns the exp value of 1.0") {
                let value = 1.0
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(2.718281828459045))
            }
            
            it("returns the exp value of -0.5") {
                let value = -0.5
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(0.6065306597126334))
            }
            
            it("returns the exp value of 0") {
                let value = 0.123
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(1.1308844209474893))
            }
            
            it("returns the exp value of 1.88") {
                let value = 1.88
                let args = [PlanOutOperation.Keys.value.rawValue: value]
                var result: Double?

                expect { result = try op.execute(args, Interpreter()) }.toNot(throwError())
                expect(result!).to(equal(6.553504862191148))
            }
        }
    }
}
