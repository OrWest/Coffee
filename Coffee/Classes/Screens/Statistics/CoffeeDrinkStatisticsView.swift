//
//  CoffeeDrinkStatisticsView.swift
//  Coffee
//
//  Created by Alex Motor on 1/3/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import SwiftUI

struct CoffeeDrinkStatisticsView: View {
    @EnvironmentObject var data: StatisticsData
    
    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .bottom) {
                ForEach(self.data.coffeeDrinks, id: \.id) { column in
                    CoffeeDrinkVerticalCapsule(
                        height: proxy.size.height,
                        value: (column.percent, column.count),
                        image: column.image
                    )
                    .frame(minWidth: 30, idealWidth: 30, maxWidth: 400)
                }
            }
        }
    }
}

struct CoffeeDrinkStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeDrinkStatisticsView()
            .environmentObject(StatisticsData(coffeeDrinks: [
                (id: 1, percent: 1.0, count: 10, Image("coffee")),
                (id: 2, percent: 0.8, count: 8, Image("coffee")),
                (id: 3, percent: 0.5, count: 5, Image("coffee")),
                (id: 4, percent: 0.4, count: 4, Image("coffee")),
                (id: 5, percent: 0.1, count: 1, Image("coffee"))
            ]))
            .previewLayout(.fixed(width: 520, height: 300))
    }
}
