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

    @IBSegueAction func addSwiftUI(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: statisticsView)
    }
}
