//
//  SettingsVC.swift
//  Coffee
//
//  Created by Alex Motor on 12/8/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsVC: BaseTableVC {

    @IBOutlet weak var shotCountLabel: UILabel!

    private let shotResults = try! Realm().objects(CoffeeShot.self)
    private var shotResultsObserver: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        shotResultsObserver = shotResults.observe { [unowned self] change in
            self.shotCountLabel.text = String(self.shotResults.count)
        }
    }

    deinit {
        shotResultsObserver?.invalidate()
    }
}
