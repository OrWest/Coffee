//
//  CoffeeInfo.swift
//  Coffee
//
//  Created by Alex Motor on 12/14/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation
import RealmSwift

class CoffeeInfo: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var smallMl: Int = 0
    @objc dynamic var largeMl: Int = 0
    @objc dynamic var caffeineMgIn100ml: Int = 0

    lazy var image: UIImage? = UIImage(named: "drink_" + name.lowercased())

    override static func ignoredProperties() -> [String] {
        return [
            "image",
            "imageForCell"
        ]
    }
}

