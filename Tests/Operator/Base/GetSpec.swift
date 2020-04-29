//
//  GetSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class GetSpec: QuickSpec {
    override func spec() {
        describe("Get operator") {
            let op = PlanOutOperation.Get()

            describe("Argument validation") {
                it("throws if the variable argument is not found") {
                    let args = ["foo": "bar"]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("should not throw if the variable value is string type") {
                    let name = "foo"
                    let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: name]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.toNot(throwError())
                }

                it("throws error if the variable argument is array type") {
                    let name = [1, 2, 3]
                    let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: name]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("returns nil if the variable argument is numeric type") {
                    let name = 12.5
                    let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: name]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("returns nil if the variable argument is boolean type") {
                    let name = false
                    let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: name]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("returns nil if the variable argument is dictionary type") {
                    let name = ["foo": 2]
                    let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: name]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("returns nil if the variable argument is non literal type") {
                    struct Foo {}
                    let name = Foo()
                    let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: name]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }
            }

            it("should return values contained in the context variable") {
                let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: "foo"]
                let ctx = AccessibleMockContext()
                ctx.params["foo"] = "bar"
                var result: Any?

                expect { result = try op.execute(args, ctx) }.toNot(throwError())
                expect((result! as! String)) == "bar"
            }
        }
    }
}
