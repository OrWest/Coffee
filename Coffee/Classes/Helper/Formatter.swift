//
//  Formatter.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/24/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation

class Formatter {
    private static let dateWithoutTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
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
        return dateWithoutTimeFormatter.string(from: date)
    }

    static func formatCMSTime(_ date: Date) -> String {
        return timeFormatter.string(from: date)
    }
}
