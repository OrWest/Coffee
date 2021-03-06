//
//  StatisticsData.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 1/3/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import SwiftUI
import Combine

class StatisticsData: ObservableObject {
    @Published var averageCaffeinPerDay = 0
    @Published var totalMl = 0
    @Published var totalCoffein = 0
    @Published var coffeeDrinks: [(id: Int, percent: CGFloat, count: Int, image: Image)]
    
    init(coffeeDrinks: [(id: Int, percent: CGFloat, count: Int, image: Image)] = []) {
        self.coffeeDrinks = coffeeDrinks
    }
}
