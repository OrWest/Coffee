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
    @IBOutlet weak var caffeinIn100Label: UILabel!
    @IBOutlet weak var sizeSegmented: UISegmentedControl!
    @IBOutlet weak var volumeField: UITextField!
    @IBOutlet weak var caffeinInsideLabel: UILabel!
    @IBOutlet weak var volumeMaxLabel: UILabel!

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    weak var transition: MainToAddShotTransition?

    var coffee: CoffeeInfo!
    private var volume: Int!
    private lazy var healthManager = HealthManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        coffeeLabel.text = coffee.name
        coffeeImageView.image = coffee.image

        caffeinIn100Label.text = Formatter.formatMg(coffee.caffeineMgIn100ml)
        volume = coffee.smallMl
        updateCaffeineAndVolume()
        configureSegmented()
        updateAddButton()
    }
    
    private func configureSegmented() {
        if coffee.smallMl == 0 {
            sizeSegmented.setEnabled(false, forSegmentAt: 0)
        }
        if coffee.largeMl == 0 {
            sizeSegmented.setEnabled(false, forSegmentAt: 1)
        }
    }

    private func updateCaffeineInside() {
        let value = Float(volume) / 100 * Float(coffee.caffeineMgIn100ml)
        let roundValue = Int(value.rounded(.down))
        caffeinInsideLabel.text = Formatter.formatMg(roundValue)
    }
    
    private func updateAddButton() {
        addButton.isEnabled = volume > 0
    }

    private func updateVolume() {
        volumeField.text = Formatter.formatMl(volume)
        updateAddButton()
    }

    private func updateCaffeineAndVolume() {
        updateVolume()
        updateCaffeineInside()
    }

    private func updateSegmentedValue() {
        let index: Int?
        switch volume {
        case 0:
            index = nil
        case coffee.smallMl:
            index = 0
        case coffee.largeMl:
            index = 1
        default:
            index = nil
        }

        sizeSegmented.selectedSegmentIndex = index ?? UISegmentedControl.noSegment
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

        updateCaffeineAndVolume()
    }

    @IBAction func addAction(_ sender: Any) {
        
        let shot = CoffeeShot()
        shot.coffee = coffee
        shot.ml = volume
        shot.date = Date()
        
        let addShowBlock = { [unowned self] in
            self.addNewShot(shot)
            self.transition?.addedNewShot = true
            self.dismiss(animated: true)
        }
        
        // User didn't decline integration (hasn't been asked or allowed) -> should request if needed
        if case .shouldRequest = healthManager.status, healthManager.userAllowedIntegration != false {
            offerHealthShare {
                DispatchQueue.main.async { [weak self] in
                    self?.healthManager.addCaffeine(shot: shot)
                    addShowBlock()
                }
            }
        } else {
            healthManager.addCaffeine(shot: shot)
            addShowBlock()
        }
    }
    
    private func addNewShot(_ shot: CoffeeShot) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(shot)
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    private func offerHealthShare(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Health app", message: "Application can share caffeine consumption with your Health app. But need permitions first. Do you want to do this now?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
            self.healthManager.requestAuthorization { error in
                if let error = error {
                    print(error)
                }
                completion()
            }
        })
        alert.addAction(UIAlertAction(title: "Later", style: .cancel, handler: { [unowned self] _ in
            self.healthManager.userDeclineHealthSharing()
            completion()
        }))
        
        present(alert, animated: true)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func backgroundTapAction(_ sender: Any) {
        if volumeField.isEditing {
            volumeField.resignFirstResponder()
        } else {
            dismiss(animated: true)
        }
    }

    @IBAction func volumeFieldChanged(_ textField: UITextField) {
        if let text = textField.text, let newValue = Int(text) {
            if newValue > 10000 {
                volumeMaxLabel.textColor = .red
                textField.text = String(volume)

                textField.transform = CGAffineTransform(translationX: -5, y: 0)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    textField.transform = .identity
                }, completion: nil)
            } else {
                volumeMaxLabel.textColor = .lightGray
                volume = newValue
            }
        }

        updateCaffeineInside()
    }
}

extension AddShotVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = String(volume)

        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -100)
        }

        sizeSegmented.isEnabled = false
        volumeMaxLabel.isHidden = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.contentView.transform = .identity
        }

        updateCaffeineAndVolume()
        updateSegmentedValue()
        sizeSegmented.isEnabled = true
        volumeMaxLabel.isHidden = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

}
