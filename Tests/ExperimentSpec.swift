//
//  ExperimentSpec.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

final class ExperimentSpec: QuickSpec {
    override func spec() {
        describe("Experiment") {
            describe("Initialization") {
                let def = ExperimentDefinition("def", "{\"foo\": 1}")
                let exp = Experiment(def, name: "experiment_1", salt: "salt")

                it("stores the experiment definition") {
                    expect(exp.definition.checksum) == def.checksum
                }
                it("stores the assigned experiment name") {
                    expect(exp.name) == "experiment_1"
                }
                it("stores the assigned experiment salt") {
                    expect(exp.salt) == "salt"
                }
            }

            describe("Assignment") {
                context("when interpreter is not evaluated yet") {
                    it("evaluates the experiment based on provided unit") {
                        let def = ExperimentDefinition("def", "{\"op\": \"set\", \"var\": \"foo\", \"value\": 1}")
                        let exp = Experiment(def, name: "experiment_1", salt: "salt")
                        let unit = Unit(keys: ["i"], inputs: ["i": "20"])
                        let logger = InMemoryLogger()

                        expect { try exp.assign(unit, logger: logger) }.toNot(throwError())

                        var result: Any?
                        expect { result = try exp.get("foo") }.toNot(throwError())
                        expect((result! as! Double)) == 1.0
                    }
                }

                context("when interpreter already exists") {
                    let def = ExperimentDefinition("def", "{\"op\": \"set\", \"var\": \"foo\", \"value\": 1}")
                    let exp = Experiment(def, name: "experiment_1", salt: "salt")
                    let unit = Unit(keys: ["i"], inputs: ["i": "20"])
                    let logger = InMemoryLogger()

                    try! exp.assign(unit, logger: logger)

                    it("should not evaluate the experiment again") {
                        expect { try exp.assign(unit, logger: logger) }.toNot(throwError())
                    }

                    it("should not trigger any exposure logs") {
                        // only the first log is counted.
                        expect(logger.logs.count) == 1
                    }
                }
            }

            describe("Assignment result access") {
                context("when interpreter is not evaluated yet") {
                    let def = ExperimentDefinition("def", "{\"op\": \"set\", \"var\": \"foo\", \"value\": 1}")
                    let exp = Experiment(def, name: "experiment_1", salt: "salt")

                    context("when get method is called") {
                        it("should not throw error") {
                            expect { try exp.get("foo") }.toNot(throwError())
                        }

                        it("should return nil") {
                            var result: Any?
                            try! result = exp.get("foo")
                            expect(result).to(beNil())
                        }
                    }

                    context("when get method with default value is called") {
                        it("should not throw error") {
                            expect { try exp.get("foo", defaultValue: 10) }.toNot(throwError())
                        }

                        it("always returns default value") {
                            var result: Any?
                            result = try! exp.get("foo", defaultValue: 10)
                            expect((result! as! Int)) == 10
                        }
                    }

                    context("when getParams is called") {
                        it("should not throw error") {
                            expect { try exp.getParams() }.toNot(throwError())
                        }
                        
                        it("should return empty dictionary") {
                            var result: [String: Any]?
                            result = try! exp.getParams()
                            expect(result).to(beEmpty())
                        }
                    }
                }

                context("when interpreter already exists") {
                    let def = ExperimentDefinition("def", "{\"op\": \"set\", \"var\": \"foo\", \"value\": 1}")
                    let exp = Experiment(def, name: "experiment_1", salt: "salt")
                    let unit = Unit(keys: ["i"], inputs: ["i": "20"])
                    let logger = InMemoryLogger()

                    try! exp.assign(unit, logger: logger)

                    context("given get method is called") {
                        it("returns the assignment value from interpreter") {
                            var result: Any?
                            expect { result = try exp.get("foo") }.toNot(throwError())

                            expect((result! as! Int)) == 1
                        }
                    }
                    context("given get method with default value is called") {
                        it("returns the assignment value from interpreter") {
                            var result: Any?
                            expect { result = try exp.get("foo", defaultValue: 2) }.toNot(throwError())
                            expect((result! as! Int)) == 1
                        }

                        it("returns value from inputs") {
                            var result: Any?
                            expect { result = try exp.get("i", defaultValue: "x") }.toNot(throwError())
                            expect((result! as! String)) == "20"
                        }

                        it("returns default value if requested key does not exist in params") {
                            var result: Int = -1
                            expect { result = try exp.get("bar", defaultValue: 2) }.toNot(throwError())

                            result = try! exp.get("bar", defaultValue: 2)

                            expect(result) == 2
                        }
                    }
                    context("given getParams is called") {
                        it("returns the assignment value from interpreter") {
                            var result: [String: Any]?
                            expect { result = try exp.getParams() }.toNot(throwError())
                            expect((result! as! [String: Int])) == ["foo": 1]
                        }
                    }
                }
            }

            describe("Logging") {
                context("when interpreter shouldLogExposure is false") {
                    it("should not log exposure") {
                        let def = ExperimentDefinition("def", "{\"op\": \"return\", \"value\": false}")
                        let exp = Experiment(def, name: "experiment_1", salt: "salt")
                        let unit = Unit(keys: ["i"], inputs: ["i": "20"])
                        let logger = InMemoryLogger()

                        try! exp.assign(unit, logger: logger)

                        expect(logger.logs.count) == 0
                    }
                }
                context("when interpreter shouldLogExposure is true") {
                    it("should log exposure") {
                        let def = ExperimentDefinition("def", "{\"op\": \"return\", \"value\": true}")
                        let exp = Experiment(def, name: "experiment_1", salt: "salt")
                        let unit = Unit(keys: ["i"], inputs: ["i": "20"])
                        let logger = InMemoryLogger()

                        try! exp.assign(unit, logger: logger)

                        expect(logger.logs.count) == 1
                    }
                }
                context("when the exposure has been previously logged") {
                    it("should not log exposure") {
                        let def = ExperimentDefinition("def", "{\"op\": \"return\", \"value\": true}")
                        let exp = Experiment(def, name: "experiment_1", salt: "salt")
                        let unit = Unit(keys: ["i"], inputs: ["i": "20"])
                        let logger = InMemoryLogger()

                        try! exp.assign(unit, logger: logger)
                        try! exp.assign(unit, logger: logger) // assign twice to attempt second logging

                        expect(logger.logs.count) == 1
                    }
                }
            }
        }
    }
}
