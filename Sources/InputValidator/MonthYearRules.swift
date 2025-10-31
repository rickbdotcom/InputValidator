//
//  File.swift
//  InputValidator
//
//  Created by Richard Burgess on 10/30/25.
//

import Foundation

public struct MonthYearRewriteRule: InputRule {

    public init() {
    }

    public func callAsFunction(_ intialValue: String) -> Result<String, Error> {
        let digits = Array(intialValue).compactMap {
            Int(String($0))
        }
        var mmyy = ""
        for (offset, digit) in digits.enumerated() {
            let string = String(digit)
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

public struct MonthYearRule: InputRule {
    let error: Error
    let compare: (DateComponents?) -> Result<String, Error>

    public init(error: Error, compare: @escaping (DateComponents?) -> Result<String, Error>) {
        self.error = error
        self.compare = compare
    }

    public func callAsFunction(_ value: String) -> Result<String, Error> {
        compare(value.monthYear)
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
