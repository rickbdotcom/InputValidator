//
//  File.swift
//  InputValidator
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation
import SwiftUI

@MainActor
@propertyWrapper public struct Validate<Rule: InputRule>: DynamicProperty {

    public init(wrappedValue: Rule.Value, _ rule: Rule) {
        self._boxedValue = StateObject(wrappedValue: BoxedValue(value: wrappedValue, rule: rule))
    }

    public var wrappedValue: Rule.Value {
        get {
            boxedValue.value
        }

        nonmutating set {
            boxedValue.value = newValue
        }
    }

    public var projectedValue: Binding<Rule.Value> {
        .init(get: {
            wrappedValue
        }, set: {
            wrappedValue = $0
        })
    }

    public var error: Error? {
        get {
            boxedValue.displayError ? boxedValue.error : nil
        }
        nonmutating set {
            boxedValue.error = newValue
        }
    }

    public var displayError: Bool {
        get {
            boxedValue.displayError
        }
        nonmutating set {
            boxedValue.displayError = newValue
        }
    }

    public var rule: Rule {
        get {
            boxedValue.rule
        }
        nonmutating set {
            boxedValue.rule = newValue
        }
    }

    public func validate() {
        validate(wrappedValue)
    }

    func validate(_ newValue: Rule.Value) {
        switch rule(newValue) {
        case let .success(value):
            boxedValue.value = value
            boxedValue.error = nil
        case let .failure(error):
            boxedValue.value = newValue
            boxedValue.error = error
        }
    }

    @StateObject private var boxedValue: BoxedValue

    class BoxedValue: ObservableObject {
        @Published var value: Rule.Value
        @Published var error: Error?
        @Published var displayError: Bool = false
        @Published var rule: Rule

        init(value: Rule.Value, rule: Rule) {
            self.value = value
            self.rule = rule
        }
    }
}
