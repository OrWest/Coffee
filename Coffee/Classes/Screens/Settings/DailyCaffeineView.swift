//
//  DailyCaffeineView.swift
//  Coffee
//
//  Created by Alex Motor on 1/4/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import SwiftUI

private let minCaffeineValue = 200

struct DailyCaffeinViewModel {
    private let caffeineMgPerKg = 6
    
    var weightText: String = "" {
        didSet {
            weight = Int(weightText)
        }
    }
    var caffeineText: String = "" {
        didSet {
            caffeine = Int(caffeineText)
        }
    }
    var isValidCaffeineValue: Bool { caffeine != nil }
    
    private var weight: Int? {
        didSet {
            guard let weight = weight else { return }
            let caffeine = weight * caffeineMgPerKg
            caffeineText = String(caffeine)
            self.caffeine = caffeine
        }
    }
    private(set) var caffeine: Int?
        
    init() {
        let caffeine = CoffeeRate.default.rateInMg
        caffeineText = String(caffeine)
        self.caffeine = caffeine
    }
    
    init(caffeine: Int?) {
        if let caffeine = caffeine {
            caffeineText = String(caffeine)
        }
        self.caffeine = caffeine
    }
    
    func save() -> Bool {
        guard let caffeine = caffeine, caffeine >= minCaffeineValue else { return false }
        CoffeeRate.default.rateInMg = caffeine
        return true
    }
}

class DailyCaffeineViewVC: ObservableObject {
    @Published var vc: UIViewController?
    @Published var newRateAction: ((Int) -> Void)?
    
}

struct DailyCaffeineView: View {
    @EnvironmentObject var envObj: DailyCaffeineViewVC

    @State var model: DailyCaffeinViewModel
    @State var invalidValueShow = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Weight (kg)")) {
                    TextField("80", text: $model.weightText)
                        .keyboardType(.numberPad)

                }
                
                Section(header: Text("Daily caffeine (mg)")) {
                    TextField("400", text: $model.caffeineText)
                        .keyboardType(.numberPad)

                }
            }
            .listStyle(GroupedListStyle())
                
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(leading: CancelButton {
                self.envObj.vc?.dismiss(animated: true)
            }, trailing: SaveButton {
                if self.model.save() {
                    if let caffeine = self.model.caffeine {
                        self.envObj.newRateAction?(caffeine)
                    }
                    self.envObj.vc?.dismiss(animated: true)
                } else {
                    self.invalidValueShow = true
                }
            }.alert(isPresented: $invalidValueShow) {
                Alert(title: Text("Error"), message: Text("Incorrect caffeine value. Please enter value more than \(minCaffeineValue)."), dismissButton: .default(Text("OK")))
            })
        }
    }
}

private struct CancelButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Cancel")
        }
    }
}

private struct SaveButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Save")
        }
    }
}

private struct UpdateButton: View {
    @State var enabled: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 120, height: 50)
                        .foregroundColor(Color.green)
                    Text("Update")
                        .font(.body)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            
        }
        .opacity(enabled ? 1.0 : 0.5)
        .disabled(!enabled)
    }
}

struct DailyCaffeineView_Previews: PreviewProvider {    
    static var previews: some View {
        DailyCaffeineView(model: DailyCaffeinViewModel(caffeine: nil))
    }
}
