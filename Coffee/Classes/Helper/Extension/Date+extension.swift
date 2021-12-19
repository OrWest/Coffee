//
//  Date+extension.swift
//  Coffee
//
//  Created by Alex Motor on 1/6/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import Foundation

extension Date {
    func startOfDay() -> Date {
        var components = Calendar.current.dateComponents([
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ], from: self)
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return Calendar.current.date(from: components)!
    }
}
