//
//  CMSShotCell.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/27/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit

class CMSShotCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coffeinCountLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var coffeeImageView: UIImageView!

    func configure(shot: CoffeeShot) {
        nameLabel.text = shot.coffee.name
        coffeinCountLabel.text = Formatter.formatMg(shot.coffeinInside)
        volumeLabel.text = Formatter.formatMl(shot.ml)
        timeLabel.text = Formatter.formatCMSTime(shot.date)
        coffeeImageView.image = shot.coffee.image
    }
}
