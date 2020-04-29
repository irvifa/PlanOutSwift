//
//  SequenceSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class SequenceSpec: QuickSpec {
    override func spec() {
        describe("Sequence operator") {
            let op = PlanOutOperation.Sequence()

            describe("Argument validation") {
                it("throws if the sequence argument is not found") {
                    let args = ["foo": "bar"]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("should not throw if the sequence value is array type") {
                    let seq: [Any] = [1, 2, 3]
                    let args: [String: Any] = [PlanOutOperation.Keys.sequence.rawValue: seq]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.toNot(throwError())
                }

                it("throws if the sequence argument is string type") {
                    let seq = "foo"
                    let args: [String: Any] = [PlanOutOperation.Keys.sequence.rawValue: seq]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("throws if the sequence argument is numeric type") {
                    let seq = 12.5
                    let args: [String: Any] = [PlanOutOperation.Keys.sequence.rawValue: seq]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("throws if the sequence argument is boolean type") {
                    let seq = false
                    let args: [String: Any] = [PlanOutOperation.Keys.sequence.rawValue: seq]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("throws if the sequence argument is dictionary type") {
                    let seq = ["foo": 2]
                    let args: [String: Any] = [PlanOutOperation.Keys.sequence.rawValue: seq]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("throws if the sequence argument is non literal type") {
                    struct Foo {}
                    let seq = Foo()
                    let args: [String: Any] = [PlanOutOperation.Keys.sequence.rawValue: seq]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }
            }

            it("evaluates all values within the sequence argument") {
                let seq: [Any] = [1 , 2, 3, "foo", "bar", [1, 2, 3]]
                let args: [String: Any] = [PlanOutOperation.Keys.sequence.rawValue: seq]
                let ctx = SimpleMockContext()

                expect { try op.execute(args, ctx) }.toNot(throwError())
                expect(ctx.evaluated.count) == seq.count
            }

            it("always returns nil") {
                let seq = [1, 2, 3]
                let args = ["seq": seq]
                let ctx = SimpleMockContext()
                var result: Any?

                expect { result = try op.execute(args, ctx) }.toNot(throwError())
                expect(result).to(beNil())
            }
        }
    }
}
