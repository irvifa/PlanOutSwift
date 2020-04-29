//
//  LiteralMatchers.swift
//  PlanOutSwiftTests

import Quick
import Nimble
@testable import PlanOutSwift

func beStringLiteral(with value: String? = nil) -> Predicate<Literal> {
    return Predicate.define("be <string>") { expression, message in
        if let actualValue = try expression.evaluate(),
            case let Literal.string(stringValue) = actualValue {

            guard let value = value else {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(bool: value == stringValue, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

func beNumberLiteral(with value: Any? = nil) -> Predicate<Literal> {
    return Predicate.define("be <number>") { expression, message in
        if let actualValue = try expression.evaluate(),
            case let Literal.number(doubleValue) = actualValue {

            guard let value = value else {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(bool: ((value as! NSNumber) as! Double) == doubleValue, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

func beListLiteral(withLength length: Int? = nil) -> Predicate<Literal> {
    return Predicate.define("be <list>") { expression, message in
        if let actualValue = try expression.evaluate(),
            case let Literal.list(arrayValue) = actualValue {

            guard let length = length else {
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(bool: arrayValue.count == length, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

func beListLiteral<T: Equatable>(withValue value: [T]) -> Predicate<Literal> {
    return Predicate.define("be <list>") { expression, message in
        if let actualValue = try expression.evaluate(),
            case let Literal.list(arrayValue) = actualValue {

            return PredicateResult(bool: value == (arrayValue as! [T]), message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

func beDictionaryLiteral() -> Predicate<Literal> {
    return Predicate.define("be <dictionary>") { expression, message in
        if let actualValue = try expression.evaluate(),
            case Literal.dictionary(_) = actualValue {

            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

func beNonLiteral() -> Predicate<Literal> {
    return Predicate.define("be <nonLiteral>") { expression, message in
        if let actualValue = try expression.evaluate() {
            switch actualValue {
            case .nonLiteral:
                return PredicateResult(status: .matches, message: message)
            default:
                return PredicateResult(status: .fail, message: message)
            }
        }
        return PredicateResult(status: .fail, message: message)
    }
}
