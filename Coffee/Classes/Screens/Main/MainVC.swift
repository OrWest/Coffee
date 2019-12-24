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

class MainVC: BaseVC {
    private let coffeeSelectedSegueId = "coffeeSelected"

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var coffeeActivity: ActivityRingView!

    private let coffeeList = try! Realm().objects(Coffee.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        coffeeActivity.ringWidth = 30
        coffeeActivity.animateProgress(to: 1.7, withDuration: 1.5)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == coffeeSelectedSegueId,
            let dest = segue.destination as? AddShotVC,
            let cell = sender as? UICollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell) else { return }

        let coffee = coffeeList[indexPath.item]
        dest.coffee = coffee

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
