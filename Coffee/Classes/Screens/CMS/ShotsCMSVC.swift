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

    private var sections: [CMSShotSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureShots()
        updateNavigationItems()
    }
    
    private func updateNavigationItems() {
        if !sections.isEmpty {
            let deleteAllItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllAction))
            deleteAllItem.tintColor = .systemRed
            self.navigationItem.rightBarButtonItems = [self.editButtonItem, deleteAllItem]
        } else {
            self.navigationItem.rightBarButtonItems = []
        }
    }
    
    private func configureShots() {
        sections.removeAll()

        do {
            let shots = try Realm().objects(CoffeeShot.self).sorted(byKeyPath: "date", ascending: false)

            var lastDate: Date?
            var shotsInDay: [CoffeeShot] = []
            for shot in shots {
                if let date = lastDate, !isSameDate(shot.date, date) {
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
    
    private func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        let c1 = Calendar.current.dateComponents([.year, .month, .day], from: date1)
        let c2 = Calendar.current.dateComponents([.year, .month, .day], from: date2)
        
        return c1.year == c2.year && c1.month == c2.month && c1.day == c2.day
    }
    
    @objc
    private func deleteAllAction() {
        setEditing(false, animated: true)
        
        let alert = FeedbackAlertController(title: "Delete all", message: "This action will remove all shots. Do you really want to do that?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] _ in
            self.deleteAll()
        }))
        
        present(alert, animated: true)
    }
    
    private func deleteAll() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()

        do {
            let realm = try Realm()
            
            try realm.write {
                let shots = realm.objects(CoffeeShot.self)
                realm.delete(shots)
            }
            
            sections.removeAll()
            tableView.reloadData()
            generator.notificationOccurred(.success)
            updateNavigationItems()
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
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            
            let alert = FeedbackAlertController(title: "Delete shot", message: "You are trying to delete shot. Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [unowned self] _ in
                let realm = try! Realm()
                let shot = self.sections[indexPath.section].shots.remove(at: indexPath.row)
                try! realm.write {
                    realm.delete(shot)
                }

                if self.sections[indexPath.section].shots.isEmpty {
                    self.sections.remove(at: indexPath.section)

                    tableView.deleteSections([indexPath.section], with: .automatic)
                } else {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
                generator.notificationOccurred(.success)
                self.updateNavigationItems()
            })
            
            present(alert, animated: true)
        }
    }

}
