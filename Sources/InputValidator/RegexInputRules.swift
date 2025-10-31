//
//  RegexInputValidator.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public struct RegexInputRule: InputRule {
    let regex: Regex<String>
    let error: Error

    public init(regex: Regex<String>, error: Error) {
        self.regex = regex
        self.error = error
    }
    
    public func callAsFunction(_ value: String) -> Result<String, Error> {
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

public extension InputRule where Value == String {

    static func regex(_ regex: Regex<String>, error: Error) -> RegexInputRule {
        .init(regex: regex, error: error)
    }
}

