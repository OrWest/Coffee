//
//  CoffeeRate.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/26/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation

protocol CoffeeRateDelegate: class {
    func rateUpdated(_ newValue: Int)
}

class CoffeeRate {
    static let `default` = CoffeeRate()
    private let rateKey = "coffeeRate"

    weak var delegate: CoffeeRateDelegate?

    var rateInMg: Int {
        didSet {
            delegate?.rateUpdated(rateInMg)
            UserDefaults.standard.setValue(rateInMg, forKey: rateKey)
        }
    }

    private init() {
        self.rateInMg = UserDefaults.standard.value(forKey: rateKey) as? Int ?? 500
    }

    init(rateInMg: Int) {
        self.rateInMg = rateInMg
    }
}
