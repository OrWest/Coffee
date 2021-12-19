//
//  CloseAddShotAnimator.swift
//  Coffee
//
//  Created by Aliaksandr Matarykin on 12/26/19.
//  Copyright © 2019 Alexander Motarykin. All rights reserved.
//

import UIKit

class CloseAddShotAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let sourceImageView: UIImageView
    let percentCenter: CGPoint?

    init(sourceImageView: UIImageView, percentCenter: CGPoint?) {
        self.sourceImageView = sourceImageView
        self.percentCenter = percentCenter
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? AddShotVC else { return }

        // Should show again image in cell if we animate image to activity
        if percentCenter != nil {
            sourceImageView.isHidden = false
        }

        UIView.animate(withDuration: 0.3, animations: {
            fromViewController.contentContainerView.alpha = 0
            fromViewController.addButton.alpha = 0
            fromViewController.darkView.alpha = 0
            fromViewController.coffeeLabel.alpha = 0
        })

        if let percentCenter = percentCenter {
            let view = fromViewController.imageContainerView!
            let transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(rotationAngle: CGFloat.pi * 1.9))
            UIView.animate(withDuration: 0.5, animations: {
                view.center = percentCenter
                view.transform = transform
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            let destRect = fromViewController.coffeeImageView.convert(fromViewController.coffeeImageView.bounds, to: transitionContext.containerView)

            let imageView = UIImageView(frame: destRect)
            imageView.image = fromViewController.coffeeImageView.image
            imageView.contentMode = .scaleAspectFit
            transitionContext.containerView.addSubview(imageView)

            fromViewController.imageContainerView.isHidden = true
            let sourceRect = sourceImageView.convert(sourceImageView.bounds, to: transitionContext.containerView)
            UIView.animate(withDuration: 0.5, animations: {
                imageView.frame = sourceRect
            }, completion: { [unowned self] _ in
                self.sourceImageView.isHidden = false
                imageView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
