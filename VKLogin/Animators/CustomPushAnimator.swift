//
//  CustomPushAnimator.swift
//  OpenWeather
//
//  Created by Denis on 02.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.frame = source.view.frame
        let translation = CGAffineTransform(translationX: ( source.view.frame.height - source.view.frame.width ) / 2,
                                            y: source.view.frame.width + source.view.frame.height / 2 )
        let rotation = CGAffineTransform (rotationAngle: -90 * .pi / 180)
        destination.view.transform = translation.concatenating(rotation)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        destination.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                                        source.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        destination.view.transform = .identity
                                    })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
}
