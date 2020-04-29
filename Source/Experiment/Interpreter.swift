//
//  Interpreter.swift
//  PlanOutSwift

import Foundation

final class Interpreter {

    var experimentSalt: String

    var inputs: [String: Any]

    var overrides: [String: Any]

    let serialization: [String: Any]

    private var data: [String: Any]

    private var state: EvaluationState = .unevaluated

    private(set) var shouldLogExposure: Bool = true

    init(serialization: [String: Any] = [:], salt: String = "", unit: Unit = Unit()) {
        self.serialization = serialization
        experimentSalt = salt

        // merge inputs variable with unit's identifier for later use by random operators.
        self.inputs = unit.inputs.merging([PlanOutOperation.Keys.unit.rawValue: unit.identifier]) { current, _ in current }
        self.overrides = unit.overrides

        // by default store overridden values as parameters, if any.
        data = overrides
    }

    /* Evaluates the experiment script.
    This operation mutates the `data` variable for every assignment
    operators made through PlanOutOperation.Set.
    - Note:
    - The interpreter will only evaluate the script once (per interpreter instance). This is checked through the `evaluated` boolean flag.
    - The script can arbitrarily throw OperationError.stop which is intentional and should be passed through. The stop signal contains
    a boolean value that defines whether the current experiment evaluation should be logged or not.

    This logging decision will later be processed by the Experiment class when the exposure is logged.
    - Throws: OperationError
    */
    func evaluateExperiment() throws {
        guard state == .unevaluated else { return }
        state = .evaluating

        do {
            try evaluate(serialization)
        } catch OperationError.stop(let shouldLogExposure) {
            self.shouldLogExposure = shouldLogExposure
        } catch let error {
            state = .error
            throw error
        }

        state = .evaluated
    }
}

/* List of reserved names that are separate from the data variable.
The raw value definitions follow PlanOut interpreter's implementation in Python,
as these are probably used (and hardcoded) in the PlanOut compiler as standardized names
to get/set these reserved values.
*/
extension Interpreter {
    private enum ReservedNames: String {
        case data
        case overrides = "_overrides"
        case experimentSalt = "experiment_salt"
    }

    private enum EvaluationState {
        case unevaluated

        case evaluating

        case evaluated

        case error
    }
}

extension Interpreter: PlanOutOpContext {
    @discardableResult
    func evaluate(_ value: Any) throws -> Any? {
        switch PlanOutExpression(value: value) {
        case .operation(let operation, let args):
            return try operation.executeOp(args: args, context: self)
        case .list(let values):
            return try values.compactMap { try self.evaluate($0) }
        case .literal(let value):
            return value
        }
    }

    func get(_ name: String) throws -> Any? {
        /* Experiment script must be evaluated first before any get queries are performed.
        All available get methods will end up delegating to this method,
        so it's safe to put the evaluateExperiment() call here.
        */
        try evaluateExperiment()

        if let reservedName = ReservedNames(rawValue: name) {
            switch reservedName {
            case .data:
                return data
            case .overrides:
                return overrides
            case .experimentSalt:
                return experimentSalt
            }
        }

        return data[name] ?? inputs[name]
    }

    func get<T>(_ name: String, defaultValue: T) throws -> T {
        let value = try get(name)

        if let numericValue = value as? NSNumber {
            return numericValue as? T ?? defaultValue
        }

        return (value as? T) ?? defaultValue
    }

    func getParams() throws -> [String: Any] {
        return try self.get(ReservedNames.data.rawValue, defaultValue: [:])
    }

    func set(_ name: String, value: Any) throws {
        if let reserved = ReservedNames(rawValue: name) {
            switch reserved {
            case .data:
                guard let dictionaryValue = value as? [String: Any] else { return }
                self.data = dictionaryValue

            case .overrides:
                guard let dictionaryValue = value as? [String: Any] else { return }
                self.overrides = dictionaryValue

            case .experimentSalt:
                guard let stringValue = value as? String else { return }
                self.experimentSalt = stringValue
            }
        }

        guard overrides[name] == nil else {
            return
        }

        if let tuple = value as? (op: PlanOutExecutable, args: [String: Any]), tuple.op.isRandomOperator {
            let saltedArgs = tuple.args.merging([PlanOutOperation.Keys.salt.rawValue: name]) { current, _ in current }
            data[name] = try tuple.op.executeOp(args: saltedArgs, context: self)
        } else {
            data[name] = value
        }
    }
}
