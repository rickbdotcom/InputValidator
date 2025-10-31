//
//  File.swift
//  InputValidator
//
//  Created by Richard Burgess on 10/30/25.
//

import Foundation

public extension AnyInputRule where Value == String {

    static func monthYear(_ value: Value) -> Self {
        .init { initialValue in
            let digits = Array(initialValue).compactMap {
                Int(String($0))
            }
            var mmyy = ""
            for (offset, digit) in digits.enumerated() {
                let string = "\(digit)"
                switch offset {
                case 0:
                    if digit == 0 || digit == 1 {
                        mmyy += string
                    } else {
                        break
                    }
                case 1:
                    guard let month = Int(mmyy + string) else {
                        break
                    }
                    if month > 0 && month <= 12 {
                        mmyy += string
                    }
                case 2:
                    mmyy += "/" + string
                case 3:
                    mmyy += string
                default:
                    break
                }
            }
            return .success(mmyy)
        }
    }

    static func monthYear(_ value: Value, error: Error, compare: @escaping (DateComponents?) -> Result<DateComponents?, Error>) -> Self {
        .init {
            switch compare($0.monthYear) {
            case let .success(date):
                .success(date?.mmyy ?? "")
            case let .failure(error):
                .failure(error)
            }
        }
    }
}

private extension DateComponents {

    var mmyy: String {
        if let month {
            if let year {
                "\(month)/\(year)"
            } else {
                "\(month)"
            }
        } else {
            ""
        }
    }
}

private extension String {

    var monthYear: DateComponents? {
        let comps = components(separatedBy: "/")
        guard comps.count == 2,
              let month = Int(comps[0]),
              month > 0, month <= 12,
              comps[1].count == 2,
              let year = Int(comps[1]) else {
            return nil
        }
        return DateComponents(calendar: .init(identifier: .gregorian), year: year + 2000, month: month)
    }
}
