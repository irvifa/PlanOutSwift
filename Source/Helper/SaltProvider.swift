//
//  File.swift
//  PlanOutSwift


import Foundation

struct SaltProvider {
    static let defaultSeparator: String = "."

    static func generate(values: [String], separator: String = defaultSeparator) -> String {
        return values.filter { !$0.isEmpty }.joined(separator: separator)
    }
}
