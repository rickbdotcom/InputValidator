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
    @Validate(.creditCard) var creditCard = ""
    @Validate(.expirationDate) var expirationDate = ""

    @FocusState var focused: Field?

    var body: some View {
        Form {
            TextField(String(localized: .firstName), text: $firstName)
                .validate(
                    field: .firstName,
                    validation: _firstName,
                    focused: $focused
                )

            TextField(String(localized: .lastName), text: $lastName)
                .validate(
                    field: .lastName,
                    validation: _lastName,
                    focused: $focused
                )

            SecureField(String(localized: .password), text: $password)
                .validate(
                    field: .password,
                    validation: _password,
                    focused: $focused
                )

            SecureField(String(localized: .confirmPassword), text: $confirmPassword)
                .validate(
                    field: .confirmPassword,
                    validation: _confirmPassword,
                    focused: $focused
                )
                .match(
                    .password,
                    _password,
                    .confirmPassword,
                    _confirmPassword,
                    error: ValidationError.confirmPassword,
                    focused: _focused
                )

            TextField(String(localized: .creditCard), text: $creditCard)
                .creditCard(creditCard)
                .validate(
                    field: .creditCard,
                    validation: _creditCard,
                    focused: $focused
                )
                .keyboardType(.numberPad)

            TextField(String(localized: .expirationDate), text: $expirationDate)
                .validate(
                    field: .expirationDate,
                    validation: _expirationDate,
                    focused: $focused
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
