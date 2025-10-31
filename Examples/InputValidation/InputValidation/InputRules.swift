//
//  InputRules.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/30/25.
//

import Foundation
import InputValidator

extension InputRule where Self == AnyInputRule<String> {

    static func name(_ fieldName: LocalizedStringResource) -> AnyInputRule<String> {
        .and([
            AnyInputRule.minimumLength(1, error: ValidationError.empty(String(localized: fieldName))),
            AnyInputRule.maximumLength(30, error: ValidationError.max(String(localized: fieldName), 30))
        ])
    }

    static var password: AnyInputRule<String> {
        .and([
            .minimumLength(8, error: ValidationError.password),
            AnyInputRule {
                if $0.contains(/[A-Z]/) {
                    .success($0)
                } else {
                    .failure(ValidationError.password)
                }
            },
            AnyInputRule {
                if $0.contains(/[a-z]/) {
                    .success($0)
                } else {
                    .failure(ValidationError.password)
                }
            },
            AnyInputRule {
                if $0.contains(/\d/) {
                    .success($0)
                } else {
                    .failure(ValidationError.password)
                }
            },
            AnyInputRule {
                if $0.contains(/[^a-zA-Z\d]/) {
                    .success($0)
                } else {
                    .failure(ValidationError.password)
                }
            }
        ])
    }

    static var confirmPassword: AnyInputRule<String> {
        .equal("", error: ValidationError.confirmPassword)
    }

    static var expirationDate: AnyInputRule<String> {
        .and([
            AnyInputRule.monthYear(),
            AnyInputRule.monthYear {
                guard let date = $0 else {
                    return .failure(ValidationError.invalidDate)
                }
            }
        ])
    }
}

enum ValidationError: LocalizedError {
    case empty(String)
    case max(String, Int)
    case password
    case confirmPassword
    case invalidDate

    var errorDescription: String? {
        switch self {
        case let .empty(fieldName):
            String(localized: .emptyStringError(fieldName: fieldName))
        case let .max(fieldName, length):
            String(localized: .maxStringLengthError(fieldName: fieldName, maxLength: length))
        case .password:
            String(localized: .passwordError)
        case .confirmPassword:
            String(localized: .confirmPasswordError)
        case .invalidDate:
            String(localized: .expirationDateRequired)
        }
    }
}
