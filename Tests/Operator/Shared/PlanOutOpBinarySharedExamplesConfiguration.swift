//
//  File.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

func binaryArgsBuilder(_ left: Any, _ right: Any) -> [String: Any] {
    return [PlanOutOperation.Keys.left.rawValue: left, PlanOutOperation.Keys.right.rawValue: right]
}

private struct Foo {}

class PlanOutOpBinarySharedExamplesConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples(SharedBehavior.binaryOperator.rawValue) { context in
            let op = context() [SharedBehavior.Keys.op.rawValue] as! PlanOutExecutable

            itBehavesLike(SharedBehavior.simpleOperator.rawValue) { [SharedBehavior.Keys.op.rawValue: op] }

            /*
             Positive cases are not handled here, because each PlanOutOpBinary derivatives have their own type restrictions.
             */

            it("throws error if left and right argument does not exist") {
                let args = ["lefty": "left", "righty": "right"]

                expect { try op.executeOp(args: args, context: Interpreter()) }.to(throwError(errorType: OperationError.self))
            }

            it("throws error if only left argument exists") {
                let args = ["left": "left", "righty": "right"]

                expect { try op.executeOp(args: args, context: Interpreter()) }.to(throwError(errorType: OperationError.self))
            }

            it("throws error if only right argument exists") {
                let args = ["lefty": "left", "right": "right"]

                expect { try op.executeOp(args: args, context: Interpreter()) }.to(throwError(errorType: OperationError.self))
            }

            it("is not a random operator") {
                expect(op.isRandomOperator) == false
            }
        }
    }
}
