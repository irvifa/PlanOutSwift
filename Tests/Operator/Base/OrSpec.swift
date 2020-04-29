//
//  OrSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class OrSpec: QuickSpec {
    override func spec() {
        describe("And operator") {
            let op = PlanOutOperation.Or()

            it("throws if values key does not exist in args") {
                let args = ["foo": "bar"]
                let ctx = SimpleMockContext()

                expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
            }

            it("evaluate arguments until the first true value is found") {
                let values: [Any] = ["foo", "bar", "baz", 1, 2, 3]
                let args: [String: Any] = ["values": values]
                let ctx = SimpleMockContext()

                expect{ try op.execute(args, ctx) }.toNot(throwError())
                expect(ctx.evaluated.count) == 1
            }

            /*
             Note:
             Cast to boolean value is thoroughly covered in LiteralSpec.
             */
            describe("OR logic gate") {
                it("returns false if all evaluated results are false") {
                    let values: [Any] = [false, false, 0, "", []]
                    let args: [String: Any] = ["values": values]
                    let ctx = SimpleMockContext()
                    var result: Bool?

                    expect{ result = try op.execute(args, ctx) }.toNot(throwError())
                    expect(result!) == false
                }

                it("returns true if at least one evaluated result is true") {
                    let values: [Any] = [true, false, 0, "foo", []]
                    let args: [String: Any] = ["values": values]
                    let ctx = SimpleMockContext()
                    var result: Bool?

                    expect { result = try op.execute(args, ctx) }.toNot(throwError())
                    expect(result!) == true
                }
            }
        }
    }
}
