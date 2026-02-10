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

    public var errorToDisplay: Error? {
        (error != nil && displayError) ? error : nil
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
    
    public var isValid: Bool {
        var newValue = wrappedValue
        do {
            try rule(&newValue)
            return true
        } catch {
            return false
        }
    }

    func validate(_ value: Rule.Value) {
        var newValue = value
        do {
            try rule(&newValue)
            boxedValue.value = newValue
            boxedValue.error = nil
        } catch {
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

public extension View {
    func disabled<each Rule: InputRule>(_ validations: repeat Validate<each Rule>) -> some View {
        var disabled = false
        for validation in repeat each validations {
            if validation.isValid == false {
                disabled = true
                break
            }
        }
        return self
            .disabled(disabled)
    }
}
