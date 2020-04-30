//
//  InMemoryLogger.swift
//  PlanOutSwift


// Simple logger implementation that stores exposure logs to memory.
public final class InMemoryLogger: PlanOutLogger {
    // Simple in-memory storage for exposure logs.
    private(set) var logs: [ExposureLog] = []

    public func logExposure(_ log: ExposureLog) {
        logs.append(log)
    }
}
