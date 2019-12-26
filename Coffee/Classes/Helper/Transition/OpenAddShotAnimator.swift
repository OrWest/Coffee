//
//  OpenAddShotAnimator.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/26/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit

class OpenAddShotAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let sourceImageView: UIImageView

    init(sourceImageView: UIImageView) {
        self.sourceImageView = sourceImageView
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) as? AddShotVC else { return }

        toViewController.imageContainerView.alpha = 0
        toViewController.contentContainerView.alpha = 0
        toViewController.addButton.alpha = 0
        toViewController.darkView.alpha = 0
        toViewController.coffeeLabel.alpha = 0

        transitionContext.containerView.addSubview(toViewController.view)

        toViewController.view.layoutIfNeeded()
        let destRect = toViewController.coffeeImageView.convert(toViewController.coffeeImageView.bounds, to: transitionContext.containerView)

        let sourceRect = sourceImageView.convert(sourceImageView.bounds, to: transitionContext.containerView)
        let imageView = UIImageView(frame: sourceRect)
        imageView.image = sourceImageView.image
        imageView.contentMode = .scaleAspectFit
        transitionContext.containerView.addSubview(imageView)

        sourceImageView.isHidden = true
        UIView.animate(withDuration: 0.6, animations: {
            toViewController.darkView.alpha = 1.0
            imageView.frame = destRect
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, animations: {
                toViewController.imageContainerView.alpha = 1.0
                toViewController.coffeeLabel.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    toViewController.addButton.alpha = 1.0
                    toViewController.contentContainerView.alpha = 1.0
                }, completion: { _ in
                    imageView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            })
        })
    }
}
