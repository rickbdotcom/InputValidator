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
                    $0
                } else {
                    throw ValidationError.password
                }
            },
            AnyInputRule {
                if $0.contains(/[a-z]/) {
                    $0
                } else {
                    throw ValidationError.password
                }
            },
            AnyInputRule {
                if $0.contains(/\d/) {
                    $0
                } else {
                    throw ValidationError.password
                }
            },
            AnyInputRule {
                if $0.contains(/[^a-zA-Z\d]/) {
                    $0
                } else {
                    throw ValidationError.password
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
                if let dateComponents = $0,
                   dateComponents.month != nil && dateComponents.year != nil,
                   let calendar = dateComponents.calendar,
                   let date = calendar.date(from: dateComponents),
                   let expires = calendar.date(byAdding: .init(calendar: calendar, month: 1), to: date) {
                    if expires.compare(.now) == .orderedDescending {
                        $0
                    } else {
                        throw ValidationError.expired
                    }
                } else {
                    throw ValidationError.invalidDate
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
    case expired

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
        case .expired:
            String(localized: .expired)
        }
    }
}
