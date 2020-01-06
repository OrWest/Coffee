//
//  HealthManager.swift
//  Coffee
//
//  Created by Alex Motor on 1/4/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    enum Status {
        case unavailable
        case shouldRequest
        case granted
        case error(Error)
    }
    
    private let caffeineType = HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)!

    private var typesToWrite: Set<HKQuantityType> { [caffeineType] }
    
    private let UDHealthAllowedByUserKey = "HealthInfoAllowedByUser"
    
    static let shared = HealthManager()
    
    private(set) var status: Status = .unavailable
    private(set) var userAllowedIntegration: Bool? {
        didSet {
            UserDefaults.standard.set(userAllowedIntegration, forKey: UDHealthAllowedByUserKey)
        }
    }
    private let healthStore = HKHealthStore()
    
    var healthEnabled: Bool {
        guard let userAllowedIntegration = userAllowedIntegration else {
            return false
        }
        
        var enabled = userAllowedIntegration
        switch status {
            case .granted:
                break
            default:
                enabled = false
        }
        
        return enabled
    }
    
    private init() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        self.userAllowedIntegration = UserDefaults.standard.object(forKey: UDHealthAllowedByUserKey) as? Bool
        
        healthStore.getRequestStatusForAuthorization(toShare: typesToWrite, read: []) { status, error in
            switch status {
            case .unnecessary:
                self.status = .granted
            case .shouldRequest:
                self.status = .shouldRequest
            case .unknown:
                if let error = error {
                    self.status = .error(error)
                } else {
                    self.status = .unavailable
                }
            @unknown default:
                fatalError("Unknown status from HKHealthStore getRequestStatusForAuthorization")
            }
        }
    }
    
    func requestAuthorization(completion: ((Error?) -> Void)? = nil) {
        userAllowedIntegration = true
        
        if case .granted = status {
            // Do not need call this method with already granted access.
            return
        }
        
        healthStore.requestAuthorization(toShare: typesToWrite, read: []) { [unowned self] granted, error in
            if granted {
                self.status = .granted
            }
            completion?(error)
        }
    }
    
    func userDeclineHealthSharing() {
        userAllowedIntegration = false
    }
    
    func addCaffeine(shot: CoffeeShot) {
        guard healthEnabled, canAddCaffeineToHealth() else { return }
        
        let gram = Double(shot.caffeinInside) / 1000.0
        let quantity = HKQuantity(unit: HKUnit(from: .gram), doubleValue: gram)
        let sample = HKQuantitySample(type: caffeineType, quantity: quantity, start: shot.date, end: shot.date, metadata: [
            "Drink": shot.coffee.name,
            "Volume": Formatter.formatMl(shot.ml)
        ])
        
        healthStore.save(sample) { success, error in
            if let error = error {
                print(error)
            } else {
                print("Caffeine added to Health app.")
            }
        }
    }
    
    private func canAddCaffeineToHealth() -> Bool {
        switch healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)!) {
            case .sharingAuthorized:
                return true
            default:
                return false
        }
    }
}
