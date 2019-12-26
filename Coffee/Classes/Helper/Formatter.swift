//
//  Formatter.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/24/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation

class Formatter {
    static func formatMg(_ value: Int) -> String {
        return "\(value) mg"
    }

    static func formatMl(_ value: Int) -> String {
        return "\(value) ml"
    }

    static func formatPercent(_ value: Int) -> String {
        return "\(value)%"
    }
}
