//
//  ExposureLogSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class ExposureLogSpec: QuickSpec {
    override func spec() {
        describe("ExposureLog") {
            let def = ExperimentDefinition("def", "{\"foo\": \"123\"}")
            let exp = Experiment(def, name: "expname", salt: "expsalt")

            let inputs = ["userId": 123]
            let params = ["variant": "blue"]

            let log = ExposureLog(experiment: exp, inputs: inputs, params: params)

            it("assigns exposure as event identifier") {
                expect(log.event) == "exposure"
            }

            it("assigns experiment name as name property") {
                expect(log.name) == exp.name
            }

            it("assigns experiment salt as salt property") {
                expect(log.salt) == exp.salt
            }

            it("assigns experiment definition checksum as checksum property") {
                expect(log.checksum) == def.checksum
            }

            it("stores the inputs") {
                expect((log.inputs as! [String: Int])) == inputs
            }

            it("stores the params") {
                expect((log.params as! [String: String])) == params
            }

            it("can be parsed to JSON") {
                var data: Data? = nil
                expect { data = try JSONEncoder().encode(log) }.toNot(throwError())

                expect(String(data: data!, encoding: .utf8)).toNot((beNil()))
            }
        }
    }
}


