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
    var addedNewShot = false
    var percentCenter: CGPoint?

    private var sourceImageView: UIImageView?

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let path = selectedIndexPath,
        let sourceVC = source as? MainVC,
        let selectedCell = sourceVC.collectionView.cellForItem(at: path) as? CoffeeCollectionViewCell else { return nil }

        let image = selectedCell.coffeeImageView!
        sourceImageView = image
        return OpenAddShotAnimator(sourceImageView: image)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let image = sourceImageView, let percentCenter = percentCenter else { return nil }

        return CloseAddShotAnimator(sourceImageView: image, percentCenter: addedNewShot ? percentCenter : nil)
    }

}
