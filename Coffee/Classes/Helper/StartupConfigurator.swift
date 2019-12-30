//
//  StartupConfigurator.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/30/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import Foundation
import FirebaseStorage

class StartupConfigurator {
    private let storageRef = Storage.storage().reference(withPath: "startup-coffee-info.json")

    func downloadStartupInfo(_ completion: (Result<[Coffee], Error>) -> Void) {

        // 1 MB (2^16)
        storageRef.getData(maxSize: 2 << 16) { data, error in
            if let data = data {

            } else if let error = error {
                completion(Result.failure(error))
            } else {
                completion(Result.failure(NSError(domain: "", code: 0)))
            }
        }
    }
}
