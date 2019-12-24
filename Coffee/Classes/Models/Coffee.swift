//
//  Coffee.swift
//  Coffee
//
//  Created by Alex Motor on 12/14/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation
import RealmSwift

class Coffee: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var smallMl: Int = 0
    @objc dynamic var largeMl: Int = 0
    @objc dynamic var coffeineMgIn100ml: Int = 0

    lazy var image: UIImage? = UIImage(named: "drink_" + name.lowercased())
    lazy var imageForCell: UIImage? = {
        guard let image = self.image else { return nil }

        let itemSize = CGSize(width: 40.0, height: 40.0)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
        let imageRect = CGRect(x: 0.0, y: 0.0, width: itemSize.width, height: itemSize.height)
        image.draw(in: imageRect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resultImage
    }()

    override static func ignoredProperties() -> [String] {
        return [
            "image",
            "imageForCell"
        ]
    }
}

