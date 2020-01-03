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
                            .frame(width: 50, height: 50)
                        Spacer()
                    }
                    Text("\(Formatter.formatMg(data.averageCaffeinPerDay)) per day")
                }

                HStack {
                    BarChartView(
                        data: [8,23,54,32,12,37,7,23,43],
                        title: "Title",
                        form: ChartForm.small,
                        dropShadow: true
                    )
                    Spacer()
                    BarChartView(
                        data: [8,23,54,32,12,37,7,23,43],
                        title: "Title",
                        form: ChartForm.small,
                        dropShadow: true
                    )
                }.padding()

                Spacer()
            }
            .navigationBarTitle("Statistics")
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
