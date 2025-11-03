//
//  CompositeInputValidator.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public extension AnyInputRule {

    static func and(_ rules: [any InputRule<Value>]) -> Self {
        .init { value in
            for rule in rules {
                try rule(&value)
            }
        }
    }

    static func or(_ rules: [any InputRule<Value>]) -> Self {
        .init { value in
            var anyError: Error?
            var success = false
            for rule in rules {
                do {
                    try rule(&value)
                    success = true
                } catch {
                    anyError = error
                }
            }
            if success {
               return
            } else if let anyError {
                throw anyError
            } else {
                return
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
            var newValue = $0
            do {
                try self(&newValue)
            } catch {
                return
            }
            throw error
        }
    }
}
