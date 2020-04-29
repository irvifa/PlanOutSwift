//
//  ExperimentDefinitionSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class ExperimentDefinitionSpec: QuickSpec {
    override func spec() {
        describe("ExperimentDefinition") {

            it("is not a default experiment by default unless otherwise specified") {
                let def = ExperimentDefinition("foo", "{}")

                expect(def.isDefaultExperiment) == false
            }

            it("has an identifier") {
                let def = ExperimentDefinition("foo", "{}")

                expect(def.id) == "foo"
            }

            describe("Script parsing") {
                context("given valid script") {
                    it("stores the PlanOut script") {
                        let def = ExperimentDefinition("foo", "{\"foo\": \"123\"}")

                        expect(def.script).toNot(beNil())
                        expect((def.script["foo"]! as! String)) == "123"
                    }
                }

                context("given invalid script") {
                    it("stores empty dictionary") {
                        let def = ExperimentDefinition("foo", "invalid script")

                        expect(def.script).toNot(beNil())
                        expect(def.script).to(beEmpty())
                    }
                }
            }
            describe("Checksum generation") {
                it("produces the same checksum given same script") {
                    let def1 = ExperimentDefinition("foo", "{\"foo\": \"123\"}")
                    let def2 = ExperimentDefinition("foo", "{\"foo\": \"123\"}")

                    expect(def1.checksum) == def2.checksum
                }

                it("produces different checksum given different script") {
                    let def1 = ExperimentDefinition("foo", "{\"foo\": \"123\"}")
                    let def2 = ExperimentDefinition("foo", "{\"foo\": \"150\"}")

                    expect(def1.checksum) != def2.checksum
                }
            }
        }
    }
}
