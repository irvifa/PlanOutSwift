//
//  SegmentAllocator.swift
//  PlanOutSwift

import Foundation

protocol SegmentAllocator {
    /// The maximum segment size for this instance. Immutable.
    var totalSegments: Int { get }

    init(totalSegments: Int)

    @discardableResult
    mutating func allocate(_ name: String, _ segmentCount: Int) throws -> [Int]

    @discardableResult
    mutating func allocate(_ name: String, segments: [Int]) throws -> [Int]

    mutating func deallocate(_ name: String) throws

    func identifier(forUnit unit: String) throws -> String?
}
