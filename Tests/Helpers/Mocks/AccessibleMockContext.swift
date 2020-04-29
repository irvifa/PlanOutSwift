//
//  AccessibleMockContext.swift
//  PlanOutSwiftTests

@testable import PlanOutSwift

final class AccessibleMockContext: PlanOutOpContext {
    var params: [String: Any] = [:]
    var experimentSalt: String = "AccessibleMockContext"

    func evaluate(_ value: Any) throws -> Any? {
        return value
    }

    func set(_ name: String, value: Any) {
        params[name] = value
    }

    func get(_ name: String) throws -> Any? {
        return params[name]
    }

    func get<T>(_ name: String, defaultValue: T) throws -> T {
        return (try self.get(name) as? T) ?? defaultValue
    }

    func getParams() throws -> [String : Any] {
        return params
    }
}
