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

    static func equal(_ value: Value, error: Error) -> Self {
        .init {
            $0 == value ? .success($0) : .failure(error)
        }
    }

    static func range(_ range: ClosedRange<Value>, error: Error) -> Self {
        .init {
            range.contains($0) ? .success($0) : .failure(error)
        }
    }

    static func range(_ range: Range<Value>, error: Error) -> Self {
        .init {
            range.contains($0) ? .success($0) : .failure(error)
        }
    }
}

public extension InputRule {

    func rewrite() -> AnyInputRule {
        .init {
            callAsFunction($0)
        }
    }
}

