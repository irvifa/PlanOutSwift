//
//  RandomOpAssertions.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

typealias ValueMass = (val: Any, mass: Double)
typealias ValueDensity = (val: Any, density: Double)

struct RandomOperatorBuilder {
    let op: PlanOutExecutable
    let args: [String: Any]
    let salt: String

    init(op: PlanOutExecutable, args: [String: Any], salt: String = "any_salt") {
        self.op = op
        self.args = args
        self.salt = salt
    }

    func execute(unit: String) -> Any? {
        let unitObj = Unit(keys: ["x"], inputs: ["x": unit])
        let context = Interpreter(serialization: [:], salt: salt, unit: unitObj)
        let opArgs = args.merging(["unit": unitObj.identifier]) { current, _ in current }

        try! context.set("x", value: (op, opArgs))
        return try! context.get("x")!
    }
}

// convert value_mass map to a density
func valueMassToDensity(values: [ValueMass]) -> [ValueDensity] {
    let sum: Double = values.map { $0.mass }.reduce(0.0, +)

    // map array of value mass to array of value density.
    return values.map { (val: $0.val, density: $0.mass/sum) }
}

// Make sure an experiment object generates the desired frequencies
func distributionTester(_ builder: RandomOperatorBuilder,
                        valueMass: [ValueMass],
                        numRuns: Int = 1000,
                        file: FileString = #file,
                        line: UInt = #line) {
    // run N trials of op with input i
    var evaluated: [Any] = []
    for i in 0..<numRuns {
        evaluated.append( builder.execute(unit: String(i))! )
    }

    var expectedDensities: [String: Double] = [:]
    valueMassToDensity(values: valueMass).forEach { value, density in
        expectedDensities[String(describing: value)] = density
    }

    // handle sample test specially, each trial outcome is a list
    var evaluatedList: [[Any]] = []
    if let _ = builder.op as? PlanOutOperation.Sample,
        let list = evaluated as? [[Any]] {
        // convert list of size N of samples to 'draws' lists of size N (aka "zip")
        // they all should have the same distribution density
        list.forEach { values in
            var i = 0
            values.forEach { value in
                if i == evaluatedList.count {
                    evaluatedList.append([])
                }

                evaluatedList[i].append(value)
                i += 1
            }
        }
    } else {
        evaluatedList = [evaluated]
    }

    // test outcome frequencies against expected density.
    evaluatedList.forEach { assertProbs(values: $0, densities: expectedDensities, numRuns: numRuns, file: file, line: line) }
}

// Assert a list of values has the same density as value_density
func assertProbs(values: [Any], densities: [String: Any], numRuns: Int = 1000, file: FileString = #file, line: UInt = #line) {
    // count occurrences of each trial result
    var hist: [String: Int] = [:]
    values.map { String(describing: $0) }.forEach { hist[$0] = (hist[$0] ?? 0) + 1 }

    // do binomial test of proportions for each item
    hist.forEach { key, value in
        assertProp(observedP: Double(value)/Double(numRuns),
                   expectedP: densities[key] as! Double,
                   numRuns: numRuns,
                   file: file,
                   line: line)
    }
}

// Performs a test of proportions
func assertProp(observedP: Double, expectedP: Double, numRuns: Int = 1000, file: FileString, line: UInt) {
    // z_{\alpha/2} for \alpha=0.001, e.g., 99.9% CI: qnorm(1-(0.001/2))
    let Z: Double = 3.29

    // normal approximation of binomial CI.
    // this should be OK for large N and values of p not too close to 0 or 1.
    let se = Z * sqrt(expectedP * (1 - observedP) / Double(numRuns))
    expect(abs(observedP - expectedP) <= se, file: file, line: line) == true
}
