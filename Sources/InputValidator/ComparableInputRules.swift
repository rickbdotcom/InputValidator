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
            $0 > value ? .success($0) : .failure(error)
        }
    }

    static func lessThan(_ value: Value, error: Error) -> Self {
        .init {
            $0 < value ? .success($0) : .failure(error)
        }
    }

    static func range(_ range: ClosedRange<Value>, error: Error? = nil) -> Self {
        .init {
            if range.contains($0) {
                .success($0)
            } else if let error {
                .failure(error)
            } else if $0 < range.lowerBound {
                .success(range.lowerBound)
            } else {
                .success(range.upperBound)
            }
        }
    }

    static func range(_ range: Range<Value>, error: Error) -> Self {
        .init {
            range.contains($0) ? .success($0) : .failure(error)
        }
    }
}

public extension AnyInputRule where Value: Equatable {

    static func equal(_ value: Value, error: Error) -> Self {
        .init {
            $0 == value ? .success($0) : .failure(error)
        }
    }
}
