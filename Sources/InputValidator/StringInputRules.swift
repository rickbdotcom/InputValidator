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
            $0.count >= length ? .success($0) : .failure(error)
        }
    }

    static func maximumLength(_ length: Int, error: Error? = nil) -> Self {
        .init {
            if $0.count <= length {
                .success($0)
            } else if let error {
                .failure(error)
            } else {
                .success(String($0.prefix(length)))
            }
        }
    }

    static func matches(_ string: String, error: Error) -> Self {
        .init {
            if $0 == string {
                .success(string)
            } else {
                .failure(error)
            }
        }
    }
}
