//
//  Map.swift
//  PlanOutSwift


extension PlanOutOperation {
    // Return a copy of a given dictionary.
    final class Map: PlanOutOpSimple {
        typealias ResultType = [String: Any?]

        func simpleExecute(_ args: [String : Any?], _ context: PlanOutOpContext) throws -> [String: Any?]? {
            var copyArgs = args

            copyArgs.removeValue(forKey: Keys.op.rawValue)
            copyArgs.removeValue(forKey: Keys.salt.rawValue)

            return copyArgs
        }
    }
}
