//
//  Double+Extension.swift
//  Олимп Club
//
//  Created by Robert Zinyatullin on 15.03.2023.
//

import Foundation

extension Double {
    func parseToDistance() -> String {
        switch self {
        case let x where x < 1000.0:
            return String(format: "%.0f м", self)
        default:
            return String(format: "%.0f км", self / 1000)
        }
    }
}
