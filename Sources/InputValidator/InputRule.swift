//
//  File.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public protocol InputRule<Value> {
    associatedtype Value: Equatable

    func callAsFunction(_ value: inout Value) throws
}

public struct AnyInputRule<Value: Equatable>: InputRule {
    let validate: (inout Value) throws -> Void

    public init(_ validate: @escaping (inout Value) throws -> Void) {
        self.validate = validate
    }

    public func callAsFunction(_ value: inout Value) throws {
        try validate(&value)
    }
}

public extension InputRule {

    func any() -> AnyInputRule<Value> {
        .init {
            try self(&$0)
        }
    }

    static var none: AnyInputRule<Value> {
        .init { _ in
        }
    }
}
