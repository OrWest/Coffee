//
//  AddShotVC.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/24/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit
import RealmSwift

class AddShotVC: BaseVC {
    private let mg = "mg"

    @IBOutlet weak var coffeeImageView: UIImageView!
    @IBOutlet weak var coffeeLabel: UILabel!
    @IBOutlet weak var coffeinIn100Label: UILabel!
    @IBOutlet weak var sizeSegmented: UISegmentedControl!
    @IBOutlet weak var volumeField: UITextField!
    @IBOutlet weak var coffeinInsideLabel: UILabel!
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var darkView: UIView!
    
    weak var transition: MainToAddShotTransition?

    var coffee: Coffee!
    private var volume: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        coffeeLabel.text = coffee.name
        coffeeImageView.image = coffee.image

        coffeinIn100Label.text = Formatter.formatMg(coffee.coffeineMgIn100ml)
        volume = coffee.smallMl
        updateVolume()
    }

    private func updateCoffeinInside() {
        let value = Float(volume) / 100 * Float(coffee.coffeineMgIn100ml)
        let roundValue = Int(value.rounded(.down))
        coffeinInsideLabel.text = Formatter.formatMg(roundValue)
    }

    private func updateVolume() {
        volumeField.text = Formatter.formatMl(volume)
    }

    @IBAction func sizeSegmentedAction(_ sender: Any) {
        switch sizeSegmented.selectedSegmentIndex {
        case 0: // small
            volume = coffee.smallMl
        case 1: // Large
            volume = coffee.largeMl
        default:
            assertionFailure()
        }

        updateVolume()
        updateCoffeinInside()
    }

    @IBAction func addAction(_ sender: Any) {
        let shot = CoffeeShot()
        shot.coffee = coffee
        shot.ml = volume
        shot.date = Date()

        do {
            let realm = try Realm()
            try realm.write {
                realm.add(shot)
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }

        transition?.addedNewShot = true
        dismiss(animated: true)
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
