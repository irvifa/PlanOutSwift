//
//  DefaultSegmentAllocator.swift
//  PlanOutSwift


struct DefaultSegmentAllocator {
    typealias SamplerFunction = (_ choices: [Any], _ draws: Int, _ unit: String) throws -> [Any]?
    typealias RandomizerFunction = (_ minValue: Int, _ maxValue: Int, _ unit: String) throws -> Int?

    let totalSegments: Int

    private var allocationMap: [String: Set<Int>] = [:]

    private lazy var availableSegmentPool: Set<Int> = {
        return Set((0..<totalSegments).map { $0 })
    }()

    private let sampler: SamplerFunction

    private let randomizer: RandomizerFunction
}

extension DefaultSegmentAllocator: SegmentAllocator {
    init(totalSegments: Int) {
        self.init(totalSegments: totalSegments,
                  sampler: PlanOutOperation.Sample.quickEval,
                  randomizer: PlanOutOperation.RandomInteger.quickEval)
    }

    init(totalSegments: Int,
         sampler: @escaping SamplerFunction = PlanOutOperation.Sample.quickEval,
         randomizer: @escaping RandomizerFunction = PlanOutOperation.RandomInteger.quickEval) {
        self.totalSegments = totalSegments
        self.sampler = sampler
        self.randomizer = randomizer
    }

    @discardableResult
    mutating func allocate(_ name: String, _ segmentCount: Int) throws -> [Int] {
        guard let segments = try sampler(Array(availableSegmentPool).sorted(), segmentCount, name) as? [Int] else {
            throw SegmentAllocationError.samplingError
        }

        return try allocate(name, segments: segments)
    }

    @discardableResult
    mutating func allocate(_ name: String, segments: [Int]) throws -> [Int] {
        if segments.count < 1 {
            throw SegmentAllocationError.invalid(segments.count)
        } else if segments.count > availableSegmentPool.count {
            throw SegmentAllocationError.outOfSegments(requested: segments.count, available: availableSegmentPool.count)
        } else if allocationMap[name] != nil {
            throw SegmentAllocationError.duplicateIdentifier(name)
        } else if !availableSegmentPool.isSuperset(of: segments) {
            throw SegmentAllocationError.requestedSegmentsNotAvailable
        }

        allocationMap[name] = Set(segments)

        availableSegmentPool.subtract(segments)

        return segments
    }

    mutating func deallocate(_ name: String) throws {
        guard let allocatedSegments: Set<Int> = allocationMap[name] else {
            return
        }

        availableSegmentPool.formUnion(allocatedSegments)

        allocationMap.removeValue(forKey: name)
    }

    func identifier(forUnit unit: String) throws -> String? {
        guard let segment = try randomizer(0, totalSegments-1, unit) else {
            return nil
        }

        return identifier(forSegment: segment)
    }

    private func identifier(forSegment segment: Int) -> String? {
        return allocationMap.first { $1.contains(segment) }?.key
    }
}
