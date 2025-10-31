//
//  File.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public protocol InputRule<Value> {
    associatedtype Value

    func callAsFunction(_ value: Value) -> Result<Value, Error>
}

public struct AnyInputRule<Value>: InputRule {
    let validate: (Value) -> Result<Value, Error>

    public init(_ validate: @escaping (Value) -> Result<Value, Error>) {
        self.validate = validate
    }

    public func callAsFunction(_ value: Value) -> Result<Value, Error> {
        validate(value)
    }
}

public extension InputRule {

    func any() -> AnyInputRule<Value> {
        .init {
            callAsFunction($0)
        }
    }
}
