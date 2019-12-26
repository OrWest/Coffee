//
//  MainToAddShotTransition.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/26/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit

class MainToAddShotTransition: NSObject, UIViewControllerTransitioningDelegate {

    var selectedIndexPath: IndexPath?

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let path = selectedIndexPath,
        let sourceVC = source as? MainVC,
        let selectedCell = sourceVC.collectionView.cellForItem(at: path) as? CoffeeCollectionViewCell else { return nil }

        return OpenAddShotAnimator(sourceImageView: selectedCell.coffeeImageView)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

}
