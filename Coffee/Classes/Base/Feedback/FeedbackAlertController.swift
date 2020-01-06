//
//  FeedbackAlertController.swift
//  Coffee
//
//  Created by Alex Motor on 1/7/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import UIKit

class FeedbackAlertController: UIAlertController {
    
    var feedbackType: UINotificationFeedbackGenerator.FeedbackType = .warning

    private let generator = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generator.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        generator.notificationOccurred(feedbackType)
    }
}
