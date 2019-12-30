//
//  StatisticsVC.swift
//  Coffee
//
//  Created by Alex Motor on 12/8/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit
import SwiftUI

class StatisticsVC: BaseVC {

    @IBSegueAction func addSwiftUI(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: GeneralStatisticsView())
    }


}
