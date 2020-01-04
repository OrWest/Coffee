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
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .cornerRadius(30)
            
            GeometryReader { proxy in
                HStack(alignment: .bottom) {
                    ForEach(self.data.coffeeDrinks, id: \.id) { collumn in
                        CoffeeDrinkVerticalCapsule(
                            height: proxy.size.height,
                            percent: collumn.percent,
                            image: collumn.image
                        )
                        .frame(minWidth: 30, idealWidth: 30, maxWidth: 150)
                    }
                }
            }
        }
        
    }
}

struct CoffeeDrinkStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeDrinkStatisticsView()
            .environmentObject(StatisticsData(coffeeDrinks: [
                (id: 1, 1.0, Image("coffee")),
                (id: 2, 0.8, Image("coffee")),
                (id: 3, 0.5, Image("coffee")),
                (id: 4, 0.4, Image("coffee")),
                (id: 5, 0.1, Image("coffee"))
            ]))
            .previewLayout(.fixed(width: 520, height: 300))
    }
}
