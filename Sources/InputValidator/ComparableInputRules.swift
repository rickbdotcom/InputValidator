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
                return
            } else {
                throw error
            }
        }
    }

    static func lessThan(_ value: Value, error: Error) -> Self {
        .init {
            if $0 < value {
                return
            } else {
                throw error
            }
        }
    }

    static func range(_ range: ClosedRange<Value>, error: Error? = nil) -> Self {
        .init {
            if range.contains($0) {
                return
            } else if let error {
                throw error
            } else if $0 < range.lowerBound {
                $0 = range.lowerBound
            } else {
                $0 = range.upperBound
            }
        }
    }

    static func range(_ range: Range<Value>, error: Error) -> Self {
        .init {
            if range.contains($0) {
                return
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
                return
            } else {
                throw error
            }
        }
    }
}
