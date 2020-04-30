//
//  Length.swift
//  PlanOutSwift


extension PlanOutOperation {
    /* Calculates the length of a Literal type.
        - For `String` types, it simply returns the length of the string.
        - For `Array` types, it returns the number of element contained within the array.
        - For `Dictionary` types, it returns the number of key/value pairs within the dictionary.
    */
    final class Length: PlanOutOpUnary {
        typealias ResultType = Int // Length cannot be fractional.

        func unaryExecute(_ value: Any?) throws -> Int? {
            guard let thisValue = value else {
                return 0
            }

            switch Literal(thisValue) {
                case .string(let stringValue):
                    return stringValue.count
                case .list(let arrayValue):
                    return arrayValue.count
                case .dictionary(let dictionaryValue):
                    return dictionaryValue.keys.count
                default:
                    throw OperationError.typeMismatch(expected: "String/List/Dictionary", got: String(describing: value))
            }
        }
    }
}
