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
    var value: (percent: CGFloat, count: Int) = (0, 0)
    var image: Image
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Capsule()
                .fill(Color.pink)
                .frame(width: 30.0, height: value.percent * (height - 80), alignment: .bottom)
            Text(String(value.count))
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
        CoffeeDrinkVerticalCapsule(height: 250, value: (0.9, 9), image: Image("coffee"))
            .previewLayout(.fixed(width: 50, height: 250))
    }
}
