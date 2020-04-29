//
//  ExperimentDefinition.swift
//  PlanOutSwift

import Foundation

/* ExperimentDefinition represents an Experiment.
  Multiple experiments with the same definition may exist within a single namespace;
  however, they should have different segment allocations.
*/
struct ExperimentDefinition {
    // Identifier should be unique across all other experiment definitions.
    let id: String

    let script: [String: Any]

    let isDefaultExperiment: Bool

    /* For analytical purposes,
    PlanOut scripts are hashed to keep track whether the experiments have potentially changed.
    Although the documentation mentions that checksum implementation uses MD5,
    their actual implementation in Python uses the first 8 characters from SHA1 representation
    from the PlanOut script.
    The decision to implement the checksum using SHA1 is because of the assumption that
    the actual PlanOut interpreter used in production is the Python version (which uses SHA1 instead of MD5).
    - seealso:
    https://facebook.github.io/planout/docs/logging.html
    */
    let checksum: String

    init(_ id: String, _ script: String, isDefault: Bool = false) {
        self.id = id
        isDefaultExperiment = isDefault

        if let scriptData = script.data(using: .utf8),
            let data = try? JSONSerialization.jsonObject(with: scriptData) as? [String: Any] {
            self.script = data
        } else {
            self.script = [:]
        }

        checksum = String(script.sha1().prefix(8))
    }
}
