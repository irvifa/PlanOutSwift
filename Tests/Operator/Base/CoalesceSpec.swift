//
//  CoalesceSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class CoalesceSpec: QuickSpec {
    override func spec() {
        describe("Coalesce operator") {
            let op = PlanOutOperation.Coalesce()

            it("throws if values key does not exist") {
                let args = ["a": 1]
                let context = MockStringContext()

                expect { try op.execute(args, context) }.to(throwError(errorType: OperationError.self))
            }

            it("returns the first nonnull evaluated result from array of values") {
                let values: [Any] = [1, 2, "foo", 3]
                let args: [String: Any] = ["values": values]
                let context = MockStringContext()
                var result: Any?

                expect { result = try op.execute(args, context) }.toNot(throwError())
                expect((result as! String)) == "foo"
            }

            it("returns null if all of the evaluated results are null") {
                let values: [Any] = [1, 2, 4, 3]
                let args: [String: Any] = ["values": values]
                let context = MockStringContext()
                var result: Any?

                expect { result = try op.execute(args, context) }.toNot(throwError())
                expect(result).to(beNil())
            }
        }
    }
}

private struct MockStringContext: PlanOutOpContext {
    var experimentSalt: String = ""

    // returns null if the value is not string
    func evaluate(_ value: Any) throws -> Any? {
        guard let value = value as? String else {
            return nil
        }

        return value
    }

    func set(_ name: String, value: Any) {
        // no op
    }

    func get(_ name: String) throws -> Any? {
        return nil
    }

    func get<T>(_ name: String, defaultValue: T) throws -> T {
        return defaultValue
    }

    func getParams() throws -> [String : Any] {
        return [:]
    }


}
