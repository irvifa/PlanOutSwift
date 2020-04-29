//
//  UnitSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class UnitSpec: QuickSpec {
    override func spec() {
        describe("Unit") {
            it("persists keys passed into the instance") {
                let keys = ["a", "b"]
                let unit = Unit(keys: keys)

                expect(unit.keys) == keys
            }

            it("persists inputs passed into the instance") {
                let inputs = ["foo": 1, "bar": 2]
                let unit = Unit(inputs: inputs)

                expect((unit.inputs as! [String: Int])) == inputs
            }

            it("persists overrides passed into the instance") {
                let overrides = ["foo": 1, "bar": 2]
                let unit = Unit(overrides: overrides)

                expect((unit.overrides as! [String: Int])) == overrides
            }

            describe("Unit value mapping") {
                it("should be sensitive to keys ordering") {
                    let inputs = ["a": "foo", "b": "bar", "c": "baz"]

                    let keys1 = ["a", "b"]
                    let unit1 = Unit(keys: keys1, inputs: inputs)

                    let keys2 = ["b", "a"]
                    let unit2 = Unit(keys: keys2, inputs: inputs)

                    expect(unit1.unitValues) != unit2.unitValues
                    expect(Set(unit1.unitValues)) == Set(unit2.unitValues)
                }

                context("when keys exist") {
                    context("given all keys exist in inputs") {
                        it("stores the value from inputs") {
                            let keys = ["a", "b"]
                            let inputs = ["a": "foo", "b": "bar", "c": "baz"]
                            let unit = Unit(keys: keys, inputs: inputs)

                            expect(unit.unitValues) == ["foo", "bar"]
                        }
                    }

                    context("given some of the values are not string type") {
                        it("stores only string values and ignores other non-string values") {
                            let keys = ["a", "b"]
                            let inputs: [String: Any] = ["a": "foo", "b": 1, "c": "baz"]
                            let unit = Unit(keys: keys, inputs: inputs)

                            expect(unit.unitValues) == ["foo"]
                        }
                    }

                    context("given only some keys exist in inputs") {
                        it("partially stores the value from inputs") {
                            let keys = ["a", "e"]
                            let inputs = ["a": "foo", "b": "bar", "c": "baz"]
                            let unit = Unit(keys: keys, inputs: inputs)

                            expect(unit.unitValues) == ["foo"]
                        }
                    }
                    context("given keys do not exist in inputs") {
                        it("stores nothing") {
                            let keys = ["e", "f"]
                            let inputs = ["a": "foo", "b": "bar", "c": "baz"]
                            let unit = Unit(keys: keys, inputs: inputs)

                            expect(unit.unitValues).to(beEmpty())
                        }
                    }
                }

                context("when keys are empty") {
                    it("stores nothing") {
                        let inputs = ["a": "foo", "b": "bar", "c": "baz"]
                        let unit = Unit(inputs: inputs)

                        expect(unit.unitValues).to(beEmpty())
                    }
                }
            }

            describe("Unit identifier generation") {
                it("should be sensitive to keys ordering") {
                    let inputs = ["a": "foo", "b": "bar", "c": "baz"]

                    let keys1 = ["a", "b"]
                    let unit1 = Unit(keys: keys1, inputs: inputs)

                    let keys2 = ["b", "a"]
                    let unit2 = Unit(keys: keys2, inputs: inputs)

                    expect(unit1.identifier) != unit2.identifier
                }

                it("generates identifer based on values in inputs") {
                    let keys = ["a", "b"]
                    let inputs = ["a": "foo", "b": "bar", "c": "baz"]
                    let unit = Unit(keys: keys, inputs: inputs)

                    expect(unit.identifier) == "foo.bar"
                }

                context("when only overrides exist") {
                    it("produces empty string") {
                        let keys = ["a", "b"]
                        let overrides = ["a": "foo", "b": "bar", "c": "baz"]
                        let unit = Unit(keys: keys, overrides: overrides)

                        expect(unit.identifier).to(beEmpty())
                    }
                }

                context("when both inputs and overrides exist") {
                    it("ignores the overrides and generates identifier based on inputs only") {
                        let keys = ["a", "b"]
                        let inputs = ["a": "foo", "b": "bar", "c": "baz"]
                        let overrides = ["a": "not foo", "b": "not bar"]
                        let unit = Unit(keys: keys, inputs: inputs, overrides: overrides)

                        expect(unit.identifier) == "foo.bar"
                    }
                }
            }
        }
    }
}

