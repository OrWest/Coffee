//
//  Formatter.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/24/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation

class Formatter {
    private static let cmsSectionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static func formatMg(_ value: Int) -> String {
        return "\(value) mg"
    }

    static func formatMl(_ value: Int) -> String {
        return "\(value) ml"
    }

    static func formatPercent(_ value: Int) -> String {
        return "\(value)%"
    }

    static func formatCMSSectionDate(_ date: Date) -> String {
        return cmsSectionDateFormatter.string(from: date)
    }
}
