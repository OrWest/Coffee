//
//  StatisticsView.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 1/3/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct StatisticsView: View {
    @EnvironmentObject var data: StatisticsData

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Image("coffee")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Spacer()
                    }
                        .padding(.top, 20)
                    Text("\(Formatter.formatMg(data.averageCaffeinPerDay)) per day")
                }

                CoffeeDrinkStatisticsView()
                    .frame(height: 200)
                    .padding()

                Spacer()
            }
            .navigationBarTitle("Statistics")
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
        .environmentObject(StatisticsData(coffeeDrinks: [
            (id: 1, 1.0, Image("coffee")),
            (id: 2, 0.8, Image("coffee")),
            (id: 3, 0.5, Image("coffee")),
            (id: 4, 0.2, Image("coffee")),
            (id: 5, 0.1, Image("coffee"))
        ]))
    }
}
