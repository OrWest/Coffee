//
//  FeedbackButton.swift
//  Coffee
//
//  Created by Alex Motor on 1/6/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import UIKit

class FeedbackButton: UIButton {
    
    private let generator = UIImpactFeedbackGenerator(style: .soft)
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        generator.prepare()
        
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc
    private func didTap() {
        generator.impactOccurred()
    }
}
