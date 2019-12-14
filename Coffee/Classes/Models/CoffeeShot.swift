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
    @objc dynamic var coffee: Coffee!
    @objc dynamic var ml: Int = 0
}
