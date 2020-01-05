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
        case declined
        case granted
        case error(Error)
    }
    
    private let caffeineType = HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)!

    private var typesToWrite: Set<HKQuantityType> { [caffeineType] }
    
    private let UDHealthDeclinedByUserKey = "HealthInfoDeclinedByUser"
    
    static let shared = HealthManager()
    
    private(set) var status: Status = .unavailable
    private let healthStore = HKHealthStore()
    
    private init() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        if UserDefaults.standard.bool(forKey: UDHealthDeclinedByUserKey) {
            self.status = .declined
        }
        
        healthStore.getRequestStatusForAuthorization(toShare: typesToWrite, read: []) { status, error in
            switch status {
            case .unnecessary:
                self.status = .granted
            case .shouldRequest:
                
                // If not declined, set this state. First state is .unavailable
                if case .unavailable = self.status {
                    self.status = .shouldRequest
                }
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
        healthStore.requestAuthorization(toShare: typesToWrite, read: []) { [unowned self] granted, error in
            if granted {
                self.status = .granted
            }
            completion?(error)
        }
    }
    
    func userDeclineHealthSharing() {
        status = .declined
        UserDefaults.standard.set(true, forKey: UDHealthDeclinedByUserKey)
    }
    
    func addCaffeine(shot: CoffeeShot) {
        guard canAddCaffeine() else { return }
        
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
    
    private func canAddCaffeine() -> Bool {
        switch healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .dietaryCaffeine)!) {
            case .sharingAuthorized:
                return true
            default:
                return false
        }
    }
}
