//
//  ContentView.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import SwiftUI
import InputValidator

struct ContentView: View {
    @Validate(.name(.firstName)) var firstName = ""
    @Validate(.name(.lastName)) var lastName = ""
    @Validate(.password) var password = ""
    @Validate(.confirmPassword) var confirmPassword = ""
    @Validate(.expirationDate) var expirationDate = ""

    @FocusState var focused: Field?

    var body: some View {
        Form {
            FormTextField(
                title: .firstName,
                field: .firstName,
                validation: _firstName,
                focused: _focused
            )

            FormTextField(
                title: .lastName,
                field: .lastName,
                validation: _lastName,
                focused: _focused
            )

            FormTextField(
                title: .password,
                secureField: .password,
                validation: _password,
                focused: _focused
            )

            FormTextField(
                title: .confirmPassword,
                secureField: .confirmPassword,
                validation: _confirmPassword,
                focused: _focused
            )
            .match(.password, _password, .confirmPassword, _confirmPassword, error: ValidationError.confirmPassword, focused: _focused)

            FormTextField(
                title: .expirationDate,
                field: .expirationDate,
                validation: _expirationDate,
                focused: _focused
            )
            .keyboardType(.numberPad)
        }
        .padding()
    }

    enum Field: Hashable {
        case firstName
        case lastName
        case password
        case confirmPassword
        case creditCard
        case cvc
        case expirationDate
    }
}
