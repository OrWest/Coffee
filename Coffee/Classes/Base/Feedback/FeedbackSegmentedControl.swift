//
//  FeedbackSegmentedControl.swift
//  Coffee
//
//  Created by Alex Motor on 1/7/20.
//  Copyright © 2020 Alexander Motarykin. All rights reserved.
//

import UIKit

class FeedbackSegmentedControl: UISegmentedControl {

    override func didMoveToWindow() {
        super.didMoveToWindow()
           
        addTarget(self, action: #selector(switchAction), for: .valueChanged)
    }
       
    @objc
    private func switchAction() {
        let generator = UISelectionFeedbackGenerator()
       
        generator.selectionChanged()
    }

}
