//
//  MainVC.swift
//  Coffee
//
//  Created by Alex Motor on 12/8/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit
import RealmSwift
import ActivityRings
import SwiftDate

class MainVC: BaseVC {
    private let ringActivityInitialDuration = 2.0
    private let ringActivityUpdateDuration = 0.5
    private let coffeeSelectedSegueId = "coffeeSelected"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var coffeeActivity: ActivityRingView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityContainerView: UIView!

    private let coffeeList = try! Realm().objects(CoffeeInfo.self)
    private let todayShotsList = try! Realm().objects(CoffeeShot.self).filter("date >= %@", Date().dateAtStartOf(.day))
    private var todayShotsToken: NotificationToken?
    private let coffeeRate = CoffeeRate()

    private var addShotTransition: MainToAddShotTransition?

    deinit {
        todayShotsToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareActivity()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
            guard let self = self else { return }
            self.coffeeActivity.animateProgress(to: self.coffeeConsumedInPercent(), withDuration: self.ringActivityInitialDuration)
        }
    }

    private func prepareActivity() {
        coffeeActivity.ringWidth = 25
        coffeeActivity.startColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        coffeeActivity.endColor = #colorLiteral(red: 1, green: 0, blue: 0.4490005374, alpha: 1)
        coffeeActivity.progress = 0.0
        activityLabel.text = Formatter.formatPercent(Int(coffeeConsumedInPercent() * 100))

        todayShotsToken = todayShotsList.observe { [unowned self] change in
            guard case .update = change else { return }

            self.updateCoffeeAcitivity(value: self.coffeeConsumedInPercent())
        }
    }

    private func updateCoffeeAcitivity(value: Double) {
        coffeeActivity.animateProgress(to: value, withDuration: ringActivityInitialDuration)
        activityLabel.text = Formatter.formatPercent(Int(value * 100))
    }

    private func coffeeConsumedInPercent() -> Double {
        let rate = Double(coffeeRate.rateInMg)
        let consumed = todayShotsList.map { Double($0.coffee.caffeineMgIn100ml * $0.ml) / 100.0 }.reduce(0, +)

        return consumed / rate
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == coffeeSelectedSegueId,
            let dest = segue.destination as? AddShotVC,
            let cell = sender as? UICollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell) else { return }

        let coffee = coffeeList[indexPath.item]
        dest.coffee = coffee

        let transition = MainToAddShotTransition()
        transition.selectedIndexPath = indexPath
        transition.percentCenter = activityContainerView.superview!.convert(activityContainerView.center, to: view)
        dest.transitioningDelegate = transition
        dest.transition = transition

        addShotTransition = transition
        print("Selected coffee: \(coffee.name)")
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coffeeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coffee", for: indexPath) as! CoffeeCollectionViewCell

        let coffee = coffeeList[indexPath.item]
        cell.nameLabel.text = coffee.name
        cell.coffeeImageView.image = coffee.image

        return cell
    }
}

extension MainVC: CoffeeRateDelegate {
    func rateUpdated(_ newValue: Int) {
        let percent = coffeeConsumedInPercent()
        coffeeActivity.animateProgress(to: percent, withDuration: ringActivityUpdateDuration)
        activityLabel.text = Formatter.formatPercent(Int(percent * 100))
    }
}
