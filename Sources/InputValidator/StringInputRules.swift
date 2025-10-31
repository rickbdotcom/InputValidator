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

    static func maximumLength(_ length: Int, error: Error) -> Self {
        .init {
            $0.count <= length ? .success($0) : .failure(error)
        }
    }

/*    static func limit(_ maxLength: Int) -> Self {
        .init {
            if $0.count <= maxLength {
            }
        }
    }*/

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
