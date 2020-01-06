//
//  PreloadViewController.swift
//  Coffee
//
//  Created by Alex Motor on 1/6/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import UIKit
import SwiftUI
import RealmSwift

class PreloadViewController: UIViewController {

    private lazy var startupConfig = StartupConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = HealthManager.shared
        configureRealm()
    }
    
    private func configureRealm() {
        // Migration
            #if DEBUG
    //        var config = Realm.Configuration()
    //
    //        // Use the default directory, but replace the filename with the username
    //        config.fileURL = URL(fileURLWithPath: "/Users/Motor/Documents/Coffee/default.realm")
    //
    //        // Set this as the configuration used for the default Realm
    //        Realm.Configuration.defaultConfiguration = config
            #endif
        
        DispatchQueue.global().async {
            let realm = try! Realm()
            
            // Don't have coffee info. Download it
            if realm.objects(CoffeeInfo.self).isEmpty {
                self.downloadCoffeeInfo { error in
                    DispatchQueue.main.async {
                        if let _ = error {
                            self.showError()
                        } else {
                            self.goToMain()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.goToMain()
                }
            }
        }
    }
    
    private func downloadCoffeeInfo(completion: @escaping (Error?) -> Void) {
        startupConfig.downloadStartupInfo { result in
            let realm = try! Realm()
            
            switch result {
                case .success(let info):
                    try! realm.write {
                        realm.add(info)
                    }
                    completion(nil)
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Error", message: "Cannot load start up info. Please, check internet connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Load again", style: .default) { [unowned self] _ in
            DispatchQueue.global().async {
                self.downloadCoffeeInfo { error in
                    if let _ = error {
                        DispatchQueue.main.async {
                            self.showError()
                        }
                    }
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    private func goToMain() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        let window = view.window!
        window.rootViewController = vc
        UIView.transition(with: window, duration: 1.0, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        }, completion: nil)
    }
    
    @IBSegueAction func prepareSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        let vc = UIHostingController(coder: coder, rootView: PreloaderView())
        vc?.view.backgroundColor = .clear
        return vc
    }
}
