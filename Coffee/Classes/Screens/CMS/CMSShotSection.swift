//
//  CMSShotSection.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/27/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation

class CMSShotSection {
    let name: String
    var shots: [CoffeeShot]

    init(name: String, shots: [CoffeeShot]) {
        self.name = name
        self.shots = shots
    }
}
