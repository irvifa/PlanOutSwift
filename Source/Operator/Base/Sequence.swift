//
//  Sequence.swift
//  PlanOutSwift

extension PlanOutOperation {
    /// Perform a sequence of operation.
    final class Sequence: PlanOutOp {
        @discardableResult
        func execute(_ args: [String : Any], _ context: PlanOutOpContext) throws -> Any? {
            guard let sequenceData = args[Keys.sequence.rawValue] as? [Any] else {
                throw OperationError.missingArgs(args: Keys.sequence.rawValue, type: self)
            }

            try sequenceData.forEach { sequence in
                try context.evaluate(sequence)
            }

            return nil
        }
    }
}
