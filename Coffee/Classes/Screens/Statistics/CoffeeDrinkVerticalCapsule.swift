//
//  CoffeeDrinkVerticalCapsule.swift
//  Coffee
//
//  Created by Alex Motor on 1/3/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import SwiftUI

struct CoffeeDrinkVerticalCapsule: View {
    var height: CGFloat
    @State var percent: CGFloat = 1.0
    var image: Image
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Capsule()
                .fill(Color.pink)
                .frame(width: 30.0, height: percent * (height - 80), alignment: .bottom)
            Text(Formatter.formatPercent(Int(percent * 100)))
                .padding(.bottom, 5)
                .padding(.top, 5)
            image
                .resizable()
                .frame(width: 40.0, height: 40.0)
                .padding(Edge.Set.bottom, 8)
        }
    }
}

struct CoffeeDrinkVerticalCapsule_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeDrinkVerticalCapsule(height: 250, percent: 1.0, image: Image("coffee"))
            .previewLayout(.fixed(width: 50, height: 250))
    }
}
