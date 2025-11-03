//
//  File.swift
//  InputValidation
//
//  Created by Richard Burgess on 10/29/25.
//

import Foundation

public extension AnyInputRule where Value == String {

    static func minimumLength(_ length: Int, error: Error) -> Self {
        .init {
            if $0.count >= length {
                return
            } else {
                throw error
            }
        }
    }

    static func maximumLength(_ length: Int, error: Error? = nil) -> Self {
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

    static func matches(_ string: String, error: Error) -> Self {
        .init {
            if $0 == string {
                return
            } else {
                throw error
            }
        }
    }
}
