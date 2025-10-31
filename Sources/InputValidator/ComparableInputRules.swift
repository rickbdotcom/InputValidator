//
//  NumericInputValidator.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public extension AnyInputRule where Value: Comparable {

    static func greaterThan(_ value: Value, error: Error) -> Self {
        .init {
            if $0 > value {
                $0
            } else {
                throw error
            }
        }
    }

    static func lessThan(_ value: Value, error: Error) -> Self {
        .init {
            if $0 < value {
                $0
            } else {
                throw error
            }
        }
    }

    static func range(_ range: ClosedRange<Value>, error: Error? = nil) -> Self {
        .init {
            if range.contains($0) {
                $0
            } else if let error {
                throw error
            } else if $0 < range.lowerBound {
                range.lowerBound
            } else {
                range.upperBound
            }
        }
    }

    static func range(_ range: Range<Value>, error: Error) -> Self {
        .init {
            if range.contains($0) {
                $0
            } else {
                throw error
            }
        }
    }
}

public extension AnyInputRule where Value: Equatable {

    static func equal(_ value: Value, error: Error) -> Self {
        .init {
            if $0 == value {
                $0
            } else {
                throw error
            }
        }
    }
}
