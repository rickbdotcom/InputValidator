//
//  File.swift
//  InputValidator
//
//  Created by Richard Burgess on 11/3/25.
//

import Foundation
import InputValidator
import CreditCardFormatter
import SwiftUI

struct CreditCardFormatRule: InputRule {
    let error: Error
    let creditCardFormatter: CreditCardFormatter

    init(
        creditCardFormatter: CreditCardFormatter = .init(),
        error: Error
    ) {
        self.creditCardFormatter = creditCardFormatter
        self.error = error
    }
    
    func callAsFunction(_ value: inout String) throws {
        value = creditCardFormatter.formattedString(from: value)
        if creditCardFormatter.isValid(value) == false {
            throw error
        }
    }
}

struct CreditCardImage: View {
    let number: String
    let creditCardFormatter: CreditCardFormatter

    init(number: String, creditCardFormatter: CreditCardFormatter = .init()) {
        self.number = number
        self.creditCardFormatter = creditCardFormatter
    }
    var body: some View {
        Image("CreditCard/\(creditCardFormatter.brand(from: number))")
            .resizable()
            .scaledToFit()
            .frame(height: 32)
    }
}

extension View {

    func creditCard(_ number: String) -> some View {
        HStack {
            CreditCardImage(number: number)
            self
        }
    }
}
