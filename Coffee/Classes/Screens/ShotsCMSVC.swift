//
//  ShotsCMSVC.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/24/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit
import RealmSwift

class ShotsCMSVC: BaseTableVC {

    private let shots = try! Realm().objects(CoffeeShot.self).sorted(byKeyPath: "date", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shots.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shot", for: indexPath)

        let shot = shots[indexPath.row]
        cell.textLabel?.text = shot.coffee.name
        cell.detailTextLabel?.text = Formatter.formatMl(shot.ml)
        cell.imageView?.image = shot.coffee.imageForCell

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            let shot = shots[indexPath.row]
            try! realm.write {
                realm.delete(shot)
            }
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

}
