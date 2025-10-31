//
//  File.swift
//  InputValidator
//
//  Created by Richard Burgess on 10/30/25.
//

import Foundation

public extension AnyInputRule where Value == String {

    static func monthYear() -> Self {
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
            return mmyy
        }
    }

    static func monthYear(compare: @escaping (DateComponents?) throws -> DateComponents?) -> Self {
        .init {
            try compare($0.monthYear)?.mmyy ?? ""
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
