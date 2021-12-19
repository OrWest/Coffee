//
//  StatisticsVC.swift
//  Coffee
//
//  Created by Alex Motor on 12/8/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit
import SwiftUI
import RealmSwift

class StatisticsVC: BaseVC {

    private let statisticsData = StatisticsData()
    private lazy var statisticsView: some View = StatisticsView()
        .environmentObject(statisticsData)

    private let shots = try! Realm().objects(CoffeeShot.self)
    private var shotsNotifToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        shotsNotifToken = shots.observe { [weak self] changes in
            self?.calculateStatisitcs()
        }
    }

    private func calculateStatisitcs() {
        calculateAvarageCaffeinPerDay()
        calculateDrinkStatistics()
        calculateTotals()
    }
    
    private func calculateTotals() {
        let totalMl = shots.map { $0.ml }.reduce(0, +)
        let totalCaffein = shots.map { $0.caffeinInside }.reduce(0, +)
        
        statisticsData.totalMl = totalMl
        statisticsData.totalCoffein = totalCaffein
    }

    private func calculateAvarageCaffeinPerDay() {
        guard !shots.isEmpty else {
            statisticsData.averageCaffeinPerDay = 0
            return
        }

        let sum = shots.map { $0.caffeinInside }.reduce(0, +)
        let daysCount = Set(shots.map { Formatter.formatCMSSectionDate($0.date) }).count

        statisticsData.averageCaffeinPerDay = sum / daysCount
    }
    
    private func calculateDrinkStatistics() {
        let allShots = shots.compactMap { $0.coffee }
        
        var drinkCount: [String: Int] = [:]

        for shot in allShots {
            drinkCount[shot.name] = (drinkCount[shot.name] ?? 0) + 1
        }
        
        let ordered = drinkCount.map { $0 }.sorted { $0.value > $1.value }
        let sum = ordered.map { $0.value }.reduce(0, +)
        
        statisticsData.coffeeDrinks.removeAll()
        for (i, (key, value)) in ordered.enumerated() {
            let coffee = allShots.first { $0.name == key }!
            let stat = (
                id: i,
                percent: CGFloat(value) / CGFloat(sum),
                count: value,
                image: Image(uiImage: coffee.image ?? UIImage(named: "coffee")!)
            )
            statisticsData.coffeeDrinks.append(stat)
        }
    }

    @IBSegueAction func addSwiftUI(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: statisticsView)
    }
}
