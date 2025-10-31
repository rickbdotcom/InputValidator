//
//  RegexInputValidator.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public extension AnyInputRule where Value == String {

    static func wholeMatch(_ regex: Regex<String>, error: Error) -> Self {
        .init { value in
            if try regex.wholeMatch(in: value) != nil {
                return value
            } else {
                throw error
            }
        }
    }
}

