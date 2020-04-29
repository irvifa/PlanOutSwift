//
//  SetSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class SetSpec: QuickSpec {
    override func spec() {
        describe("Set operator") {
            let op = PlanOutOperation.Set()

            describe("Argument validation") {
                it("throws if value key is not found") {
                    let args = [PlanOutOperation.Keys.variable.rawValue: "foo"]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                it("throws if variable key is not found") {
                    let args = [PlanOutOperation.Keys.value.rawValue: "foo"]
                    let ctx = SimpleMockContext()

                    expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                }

                context("when variable key is string type") {
                    it("should not throw") {
                        let variable = "foo"
                        let value = "bar"
                        let args = [PlanOutOperation.Keys.variable.rawValue: variable,
                                    PlanOutOperation.Keys.value.rawValue: value]
                        let ctx = AccessibleMockContext()

                        expect { try op.execute(args, ctx) }.toNot(throwError())
                    }
                }

                context("when variable key is numeric type") {
                    it("throws error") {
                        let variable = 12
                        let value = "bar"
                        let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: variable,
                                                   PlanOutOperation.Keys.value.rawValue: value]
                        let ctx = AccessibleMockContext()

                        expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                    }
                }
                context("when variable key is boolean type") {
                    it("throws error") {
                        let variable = true
                        let value = "bar"
                        let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: variable,
                                                   PlanOutOperation.Keys.value.rawValue: value]
                        let ctx = AccessibleMockContext()

                        expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                    }
                }
                context("when variable key is array type") {
                    it("throws error") {
                        let variable = [1, 2, 3]
                        let value = "bar"
                        let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: variable,
                                                   PlanOutOperation.Keys.value.rawValue: value]
                        let ctx = AccessibleMockContext()

                        expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                    }
                }
                context("when variable key is dictionary type") {
                    it("throws error") {
                        let variable = ["foo": 1, "bar": 2]
                        let value = "bar"
                        let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: variable,
                                                   PlanOutOperation.Keys.value.rawValue: value]
                        let ctx = AccessibleMockContext()

                        expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                    }
                }
                context("when variable key is non literal type") {
                    it("throws error") {
                        struct Foo {}
                        let variable = Foo()
                        let value = "bar"
                        let args: [String: Any] = [PlanOutOperation.Keys.variable.rawValue: variable,
                                                   PlanOutOperation.Keys.value.rawValue: value]
                        let ctx = AccessibleMockContext()

                        expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
                    }
                }
            }

            it("evaluates the value before the value is assigned to context variable") {
                let variable = "foo"
                let value = "bar"
                let args = [PlanOutOperation.Keys.variable.rawValue: variable,
                            PlanOutOperation.Keys.value.rawValue: value]
                let ctx = SimpleMockContext()

                expect { try op.execute(args, ctx) }.toNot(throwError())
                expect(ctx.evaluated.count) == 1
            }

            it("calls context set method to set the variable name with provided value") {
                let variable = "foo"
                let value = "bar"
                let args = [PlanOutOperation.Keys.variable.rawValue: variable,
                            PlanOutOperation.Keys.value.rawValue: value]
                let ctx = AccessibleMockContext()

                expect { try op.execute(args, ctx) }.toNot(throwError())
                expect((ctx.params[variable] as! String)) == value
            }

            it("always returns nil") {
                let variable = "foo"
                let value = "bar"
                let args = [PlanOutOperation.Keys.variable.rawValue: variable,
                            PlanOutOperation.Keys.value.rawValue: value]
                let ctx = AccessibleMockContext()
                var result: Any?

                expect { result = try op.execute(args, ctx) }.toNot(throwError())
                expect(result).to(beNil())
            }
        }
    }
}
