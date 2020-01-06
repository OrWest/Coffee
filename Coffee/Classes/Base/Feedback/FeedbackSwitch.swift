//
//  FeedbackSwitch.swift
//  Coffee
//
//  Created by Alex Motor on 1/7/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import UIKit

class FeedbackSwitch: UISwitch {

    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        addTarget(self, action: #selector(switchAction), for: .valueChanged)
    }
    
    @objc
    private func switchAction() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        
        generator.impactOccurred()
    }

}
