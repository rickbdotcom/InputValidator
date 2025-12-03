//
//  File.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public extension InputRule where Value == String {

    static func minimumLength(_ length: Int, error: Error) -> AnyInputRule<Value> {
        .init {
            if $0.count >= length {
                return
            } else {
                throw error
            }
        }
    }

    static func maximumLength(_ length: Int, error: Error? = nil) -> AnyInputRule<Value> {
        .init {
            if $0.count <= length {
                return
            } else if let error {
                throw error
            } else {
                $0 = String($0.prefix(length))
            }
        }
    }

    static func matches(_ string: String, error: Error) -> AnyInputRule<Value> {
        .init {
            if $0 == string {
                return
            } else {
                throw error
            }
        }
    }

    static func filter(_ filter: @escaping (Character) -> Bool) -> AnyInputRule<Value> {
        .init { value in
            value = String(value.filter(filter))
        }
    }

    // smart punctuation is the worst
    static func removeSmartPunctuation() -> AnyInputRule<Value> {
        .init { value in
            value = value
                .replacingOccurrences(of: "\u{2026}", with: "...")
                .replacingOccurrences(of: "\u{2014}", with: "--")
                .replacingOccurrences(of: "\u{2018}", with: "'")
                .replacingOccurrences(of: "\u{2019}", with: "'")
        }
    }
}
