//
//  CoffeeShot.swift
//  Coffee
//
//  Created by Alex Motor on 12/14/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation
import RealmSwift

class CoffeeShot: Object {
    @objc dynamic var coffee: CoffeeInfo!
    @objc dynamic var ml: Int = 0
    @objc dynamic var date: Date!

    var coffeinInside: Int {
        let value = Double(coffee.coffeineMgIn100ml * ml) / 100.0
        return Int(value.rounded(.down))
    }
}
