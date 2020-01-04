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
                    Text("Avarage caffein per day")
                        .font(.headline)
                        .padding(.top, 10)

                    HStack {
                        Spacer()
                        Image("coffee")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Spacer()
                    }
                    Text("\(Formatter.formatMg(data.averageCaffeinPerDay))")
                        .font(.title)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(white: 0.95))
                    CoffeeDrinkStatisticsView()
                        .environmentObject(data)
                        .frame(height: 200)
                        .padding()
                }
                .padding()
                
                VStack {
                    HStack {
                        Text("Total coffee: \(Formatter.formatMl(data.totalMl))")
                            .font(.headline)
                        Spacer()
                    }
                    HStack {
                        Text("Total caffein: \(Formatter.formatMg(data.totalCoffein))")
                            .font(.headline)
                        Spacer()
                    }
                }
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
            (id: 1, percent: 1.0, count: 10, Image("coffee")),
            (id: 2, percent: 0.8, count: 8, Image("coffee")),
            (id: 3, percent: 0.5, count: 5, Image("coffee")),
            (id: 4, percent: 0.4, count: 4, Image("coffee")),
            (id: 5, percent: 0.1, count: 1, Image("coffee"))
        ]))
        .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
