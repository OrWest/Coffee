//
//  ShotsCMSVC.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/24/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate

class ShotsCMSVC: BaseTableVC {

    private var sections: [CMSShotSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        configureShots()
    }

    private func configureShots() {
        sections.removeAll()

        do {
            let shots = try Realm().objects(CoffeeShot.self).sorted(byKeyPath: "date", ascending: false)

            var lastDate: Date?
            var shotsInDay: [CoffeeShot] = []
            for shot in shots {
                if let date = lastDate, shot.date.isBeforeDate(date, granularity: .day) {
                    let newSection = CMSShotSection(
                        name: Formatter.formatCMSSectionDate(date),
                        shots: shotsInDay
                    )
                    sections.append(newSection)
                    shotsInDay.removeAll()
                }

                lastDate = shot.date
                shotsInDay.append(shot)
            }

            if !shotsInDay.isEmpty, let date = lastDate {
                sections.append(CMSShotSection(name: Formatter.formatCMSSectionDate(date), shots: shotsInDay))
            }

        } catch {
            print(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].shots.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shot", for: indexPath) as! CMSShotCell
        let shot = sections[indexPath.section].shots[indexPath.row]
        cell.configure(shot: shot)
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            let shot = sections[indexPath.section].shots.remove(at: indexPath.row)
            try! realm.write {
                realm.delete(shot)
            }

            if sections[indexPath.section].shots.isEmpty {
                sections.remove(at: indexPath.section)

                tableView.deleteSections([indexPath.section], with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

}
