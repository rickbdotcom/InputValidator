//
//  RegexInputValidator.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public extension InputRule where Value == String {

    static func wholeMatch(_ regex: Regex<Substring>, error: Error) -> AnyInputRule<Value> {
        .init { value in
            if try regex.wholeMatch(in: value) != nil {
                return
            } else {
                throw error
            }
        }
    }

    static func filter(_ regex: Regex<Substring>) -> AnyInputRule<Value> {
        .init { value in
            value = String(value.filter {
                (try? regex.wholeMatch(in: String($0))) != nil
            })
        }
    }
}
