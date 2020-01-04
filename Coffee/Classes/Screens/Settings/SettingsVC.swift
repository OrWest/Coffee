//
//  SettingsVC.swift
//  Coffee
//
//  Created by Alex Motor on 12/8/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftUI

class SettingsVC: BaseTableVC {
    private let dailyCaffeineSelection = "dailyCaffeineSelection"

    @IBOutlet weak var shotCountLabel: UILabel!
    @IBOutlet weak var currentDailyCaffeineMg: UILabel!

    private let shotResults = try! Realm().objects(CoffeeShot.self)
    private var shotResultsObserver: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        shotResultsObserver = shotResults.observe { [unowned self] change in
            self.shotCountLabel.text = String(self.shotResults.count)
        }
        currentDailyCaffeineMg.text = Formatter.formatMg(CoffeeRate.default.rateInMg)
    }

    deinit {
        shotResultsObserver?.invalidate()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 1 {
            let envObj = DailyCaffeineViewVC()
            let view = DailyCaffeineView(model: DailyCaffeinViewModel())
                .environmentObject(envObj)
            let vc = UIHostingController(rootView: view)
            envObj.vc = vc
            envObj.newRateAction = { [weak self] newRate in
                self?.currentDailyCaffeineMg.text = Formatter.formatMg(newRate)
            }
            present(vc, animated: true)
        }
    }
}
