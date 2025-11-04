//
//  FormTextField.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/30/25.
//

import Foundation
import SwiftUI
import InputValidator

extension View {

    func validate<Field: Hashable, Rule: InputRule>(
        field: Field,
        validation: Validate<Rule>,
        focused: FocusState<Field?>.Binding
    ) -> some View {
        self
            .focused(focused, equals: field)
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

private extension View {

    func error(_ error: Error?) -> some View {
        VStack {
            self

            if let error {
                Text(error.localizedDescription)
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
            }
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
