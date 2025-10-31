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
                value = try rule(value)
            }
            return value
        }
    }

    static func or(_ rules: [any InputRule<Value>]) -> Self {
        .init { initialValue in
            var value = initialValue
            var anyError: Error?
            var success = false
            for rule in rules {
                do {
                    value = try rule(value)
                    success = true
                } catch {
                    anyError = error
                }
            }
            if success {
               return value
            } else if let anyError {
                throw anyError
            } else {
                return value
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
        .init {
            let newValue = try? self($0)
            if newValue == nil {
                return $0
            } else {
                throw error
            }
        }
    }
}
