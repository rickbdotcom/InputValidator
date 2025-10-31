//
//  File.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public protocol InputRule<Value> {
    associatedtype Value

    func callAsFunction(_ value: Value) throws -> Value
}

public struct AnyInputRule<Value>: InputRule {
    let validate: (Value) throws -> Value

    public init(_ validate: @escaping (Value) throws -> Value) {
        self.validate = validate
    }

    public func callAsFunction(_ value: Value) throws -> Value {
        try validate(value)
    }
}

public extension InputRule {

    func any() -> AnyInputRule<Value> {
        .init {
            try self($0)
        }
    }
}
