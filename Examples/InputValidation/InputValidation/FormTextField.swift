//
//  FormTextField.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/30/25.
//

import Foundation
import SwiftUI
import InputValidator

struct FormTextField<Field: Hashable, Rule: InputRule<String>, EntryField: View>: View {
    let title: LocalizedStringResource
    let field: Field
    let validation: Validate<Rule>
    let focused: FocusState<Field?>
    let textField: EntryField

    init(
        title: LocalizedStringResource,
        field: Field,
        validation: Validate<Rule>,
        focused: FocusState<Field?>,
        @ViewBuilder textField: () -> EntryField
    ) {
        self.title = title
        self.field = field
        self.validation = validation
        self.focused = focused
        self.textField = textField()
    }

    init(
        title: LocalizedStringResource,
        field: Field,
        validation: Validate<Rule>,
        focused: FocusState<Field?>
    ) where EntryField == TextField<Text> {
        self.init(
            title: title,
            field: field,
            validation: validation,
            focused: focused,
        ) {
            TextField(String(localized: title), text: validation.projectedValue)
        }
    }

    init(
        title: LocalizedStringResource,
        secureField: Field,
        validation: Validate<Rule>,
        focused: FocusState<Field?>
    ) where EntryField == SecureField<Text> {
        self.init(
            title: title,
            field: secureField,
            validation: validation,
            focused: focused,
        ) {
            SecureField(String(localized: title), text: validation.projectedValue)
        }
    }

    var body: some View {
        textField
            .focused(focused.projectedValue, equals: field)
            .error(validation.error)
            .onChange(of: focused.wrappedValue) { previousFocus, currentFocus in
                if previousFocus == field {
                    validation.validate()
                }
                if currentFocus == field {
                    validation.error = nil
                    validation.displayError = false
                } else {
                    validation.displayError = true
                }
            }
            .onChange(of: validation.wrappedValue) {
                validation.validate()
            }
    }
}

private struct ErrorField<Content: View>: View {
    let content: Content
    let error: Error?

    init(error: Error?, @ViewBuilder _ content: () -> Content ) {
        self.error = error
        self.content = content()
    }

    var body: some View {
        VStack {
            content

            if let error {
                Text(error.localizedDescription)
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
            }
        }
    }
}

private extension View {

    func error(_ error: Error?) -> some View {
        ErrorField(error: error) {
            self
        }
    }
}

public extension View {

    func match<LHS: InputRule, Field: Hashable>(
        _ lhsField: Field,
        _ lhs: Validate<LHS>,
        _ rhsField: Field,
        _ rhs: Validate<AnyInputRule<String>>,
        error: Error,
        focused: FocusState<Field?>
    ) -> some View where LHS.Value == String {
        self
            .onChange(of: lhs.wrappedValue) {
                rhs.rule = .equal(lhs.wrappedValue, error: error)
            }
            .onChange(of: focused.wrappedValue) { old, new in
                if old == lhsField && new != rhsField {
                    rhs.validate()
                    rhs.displayError = true
                }
            }
    }
}
