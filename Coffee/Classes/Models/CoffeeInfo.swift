//
//  CoffeeInfo.swift
//  Coffee
//
//  Created by Alex Motor on 12/14/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation
import RealmSwift

class CoffeeInfo: Object, Decodable {
    @objc dynamic var name: String = ""
    @objc dynamic var smallMl: Int = 0
    @objc dynamic var largeMl: Int = 0
    @objc dynamic var caffeineMgIn100ml: Int = 0

    lazy var image: UIImage? = UIImage(named: "drink_" + name.lowercased()) ?? UIImage(named: "coffee")

    override static func ignoredProperties() -> [String] {
        return [
            "image",
            "imageForCell"
        ]
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let second = object as? Self else { return false }
        
        return second.name == name
    }
    
    // MARK: - Decoding
    
    enum CodingKeys: String, CodingKey {
        case name
        case smallMl
        case largeMl
        case caffeineMgIn100ml
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.caffeineMgIn100ml = try values.decode(Int.self, forKey: .caffeineMgIn100ml)
        
        if let smallMl = try? values.decode(Int.self, forKey: .smallMl) {
            self.smallMl = smallMl
        }
        if let largeMl = try? values.decode(Int.self, forKey: .largeMl) {
            self.largeMl = largeMl
        }
    }
    
    required init() {
        super.init()
    }
}

