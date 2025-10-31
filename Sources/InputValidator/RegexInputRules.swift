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
            do {
                if try regex.wholeMatch(in: value) != nil {
                    return .success(value)
                } else {
                    return .failure(error)
                }
            } catch {
                return .failure(error)
            }
        }
    }
}

