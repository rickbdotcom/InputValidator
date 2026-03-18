//
//  File.swift
//  InputValidator
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation
import SwiftUI

@MainActor
public protocol InputValidator {
    var error: Error? { get nonmutating set}
    var displayError: Bool { get nonmutating set}
    var isValid: Bool { get }
    
    func validate()
}

public extension InputValidator {
    var errorToDisplay: Error? {
        (error != nil && displayError) ? error : nil
    }
}

@MainActor
@propertyWrapper public struct Validate<Value>: InputValidator, DynamicProperty {

    public typealias Rule = (inout Value) throws -> Void

    public init<T: InputRule>(wrappedValue: Value, _ rule: T) where T.Value == Value {
        self._boxedValue = StateObject(wrappedValue: BoxedValue(value: wrappedValue, rule: rule.callAsFunction))
    }

    public var wrappedValue: Value {
        get {
            boxedValue.value
        }

        nonmutating set {
            boxedValue.value = newValue
        }
    }

    public var projectedValue: Binding<Value> {
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

    public nonmutating func set<T: InputRule>(rule: T) where T.Value == Value {
        self.rule = {
            try rule(&$0)
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

    func validate(_ value: Value) {
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
        @Published var value: Value
        @Published var error: Error?
        @Published var displayError: Bool = false
        @Published var rule: Rule

        init(value: Value, rule: @escaping Rule) {
            self.value = value
            self.rule = rule
        }
    }
}

public extension View {
    func disabled<each Value>(_ validations: repeat Validate<each Value>) -> some View {
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

public func ForEachValidation<each Value>(_ validations: repeat Validate<each Value>, perform: (InputValidator) -> Void) {
    for validation in repeat each validations {
        perform(validation)
    }
}
