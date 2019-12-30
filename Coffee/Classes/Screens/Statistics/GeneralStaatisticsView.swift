//
//  GeneralStaatisticsView.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/30/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct GeneralStaatisticsView: View {
    var body: some View {
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
    }
}

struct GeneralStaatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralStaatisticsView()
    }
}
