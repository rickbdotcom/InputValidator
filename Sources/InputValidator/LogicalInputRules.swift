//
//  CompositeInputValidator.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public extension AnyInputRule {

    static func and(_ rules: [any InputRule<Value>]) -> Self {
        .init { initialValue in
            var value = initialValue
            for rule in rules {
                if case let .failure(error) = rule(value) {
                    return .failure(error)
                } else if case let .success(newValue) = rule(value) {
                    value = newValue
                }
            }
            return .success(value)
        }
    }

    static func or(_ rules: [any InputRule<Value>]) -> Self {
        .init { initialValue in
            var value = initialValue
            var error: Error?
            var success = false
            for rule in rules {
                if case let .failure(newError) = rule(value) {
                    error = newError
                } else if case let .success(newValue) = rule(value) {
                    success = true
                    value = newValue
                }
            }
            if success {
                return .success(value)
            } else if let error {
                return .failure(error)
            } else {
                return .success(value)
            }
        }
    }

    func and<Rule: InputRule<Value>>(_ rule: Rule) -> Self {
        Self.and([self, rule])
    }

    func or<Rule: InputRule<Value>>(_ rule: Rule) -> some InputRule<Value> {
        Self.or([self, rule])
    }

    func not(error: Error) -> Self {
        .init { value in
            switch self(value) {
            case .success:
                .failure(error)
            case .failure:
                .success(value)
            }
        }
    }
}
