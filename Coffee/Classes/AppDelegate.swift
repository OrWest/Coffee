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

            let cappuccino = Coffee()
            cappuccino.name = "Cappuccino"

            let latte = Coffee()
            latte.name = "Latte"

            let espresso = Coffee()
            espresso.name = "Espresso"

            try realm.write {
                realm.add([cappuccino, latte, espresso])
            }

        } catch {
            print("Realm error: \(error)")
        }
    }
}

