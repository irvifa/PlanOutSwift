//
//  Unit.swift
//  PlanOutSwift


struct Unit {
    /* Joined string representation of unit values.
    This value will be used as primary hash value for PlanOut random operations.
    */
    let identifier: String

    let keys: [String]

    let inputs: [String: Any]

    let overrides: [String: Any]

    /* Unit values obtained from inputs variable, given unitKeys.
    If the unit key doesn't exist in the input, or if the input is empty,
    then this will return an empty array.
    - Returns: Array of unit strings
    */
    let unitValues: [String]

    init(keys: [String] = [], inputs: [String: Any] = [:], overrides: [String: Any] = [:]) {
        unitValues = keys.compactMap {
            guard let anyValue = inputs[$0],
                case let Literal.string(unitValue) = Literal(anyValue) else {
                return nil
            }
            return unitValue
        }
        identifier = SaltProvider.generate(values: unitValues)

        self.keys = keys
        self.inputs = inputs
        self.overrides = overrides
    }
}
