//
//  AppDelegate.swift
//  Coffee
//
//  Created by Alex Motor on 12/8/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        initializeServices()
        return true
    }
    
    private func initializeServices() {
        FirebaseApp.configure()

        addCoffee()
    }

    private func addCoffee() {
        do {
            let realm = try Realm()

            guard realm.objects(Coffee.self).count == 0 else { return }

            let cappuccino = Coffee()
            cappuccino.name = "Cappuccino"
            cappuccino.smallMl = 120
            cappuccino.largeMl = 240
            cappuccino.coffeineMgIn100ml = 60

            let latte = Coffee()
            latte.name = "Latte"
            latte.smallMl = 180
            latte.largeMl = 260
            latte.coffeineMgIn100ml = 44

            let espresso = Coffee()
            espresso.name = "Espresso"
            espresso.smallMl = 60
            espresso.largeMl = 120
            espresso.coffeineMgIn100ml = 89

            try realm.write {
                realm.add([cappuccino, latte, espresso])
            }

        } catch {
            print("Realm error: \(error)")
        }
    }
}

