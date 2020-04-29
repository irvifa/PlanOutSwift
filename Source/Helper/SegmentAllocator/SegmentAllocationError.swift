//
//  SegmentAllocationError.swift
//  PlanOutSwift
//

enum SegmentAllocationError: Error {
    case invalid(Int)
    case duplicateIdentifier(String)
    case outOfSegments(requested: Int, available: Int)
    case samplingError
    case requestedSegmentsNotAvailable
    case invalidDeallocation
}

extension SegmentAllocationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalid(let invalidCount):
            return "Invalid segment count: \(invalidCount)"
        case .outOfSegments(let requested, let available):
            return "\(requested) segments requested, only \(available) available."
        case .duplicateIdentifier(let identifier):
            return "Identifier \(identifier) has been previously allocated."
        case .samplingError:
            return "Unexpected sample result"
        case .requestedSegmentsNotAvailable:
            return "Requested segments are not available for allocation or doesn't exist"
        case .invalidDeallocation:
            return "Segments to deallocate exists in the available segment pool"
        }
    }
}
