//
//  AndSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class AndSpec: QuickSpec {
    override func spec() {
        describe("And operator") {
            let op = PlanOutOperation.And()

            it("throws if values key does not exist in args") {
                let args = ["foo": "bar"]
                let ctx = SimpleMockContext()

                expect { try op.execute(args, ctx) }.to(throwError(errorType: OperationError.self))
            }

            it("evaluates all entries within values key") {
                let values: [Any] = ["foo", "bar", "baz", 1, 2, 3]
                let args: [String: Any] = ["values": values]
                let ctx = SimpleMockContext()

                expect{ try op.execute(args, ctx) }.toNot(throwError())
                expect(ctx.evaluated.count) == values.count
            }

            /*
             Note:
             Cast to boolean value is thoroughly covered in LiteralSpec.
             */
            describe("AND logic gate") {
                it("returns true if all evaluated results have true boolean value") {
                    let values: [Any] = [true, true, 1, "foo", [1, 2, 3]]
                    let args: [String: Any] = ["values": values]
                    let ctx = SimpleMockContext()
                    var result: Bool?

                    expect{ result = try op.execute(args, ctx) }.toNot(throwError())
                    expect(result!) == true
                }

                it("returns false if at least one evaluated result has false boolean value") {
                    let values: [Any] = [true, false, 1, "", [1, 2, 3]]
                    let args: [String: Any] = ["values": values]
                    let ctx = SimpleMockContext()
                    var result: Bool?

                    expect { result = try op.execute(args, ctx) }.toNot(throwError())
                    expect(result!) == false
                }

                it("returns false if at least one evaluated result is nil") {
                    let values: [Any] = ["a", "b", "c"]
                    let args: [String: Any] = [PlanOutOperation.Keys.values.rawValue: values]
                    let ctx = NilMockContext()
                    var result: Bool?

                    expect { result = try op.execute(args, ctx) }.toNot(throwError())
                    expect(result!) == false
                }
            }
        }
    }
}

private struct NilMockContext: PlanOutOpContext {
    var experimentSalt: String = ""

    func evaluate(_ value: Any) throws -> Any? {
        // always return nil when encountering "b" string.
        if let stringValue = value as? String, stringValue == "b" {
            return nil
        }
        return value
    }

    func set(_ name: String, value: Any) throws {}
    func get(_ name: String) throws -> Any? { return nil }
    func get<T>(_ name: String, defaultValue: T) throws -> T { return defaultValue }
    func getParams() throws -> [String : Any] { return [:] }
}
