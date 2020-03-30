//
//  NewPhotoController.swift
//  OpenWeather
//
//  Created by Denis on 29.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class NewPhotoController: UIViewController {

    private var interactiveAnimator: UIViewPropertyAnimator!
    
    var friendName : String?
    var friendImage : UIImage?

    private let dotAnimator = DotAnimator (count: 3)
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = friendName
        imageView.image = friendImage
        
        view.addSubview(dotAnimator)
        NSLayoutConstraint.activate([
            dotAnimator.heightAnchor.constraint(equalToConstant: 50),
            dotAnimator.widthAnchor.constraint(equalToConstant: 150),
            dotAnimator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            dotAnimator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        
        dotAnimator.startAnimation() {}
        
        let gesture = UIPanGestureRecognizer ( target: self, action: #selector(onPan(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc func onPan ( _ gesture: UIPanGestureRecognizer ) {
        switch gesture.state{
        case .began:
            interactiveAnimator = UIViewPropertyAnimator (duration: 0.5, curve: .easeInOut, animations: {
                self.imageView.transform = .init( translationX: -320, y: 0)
            })
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = gesture.translation(in: view)
            interactiveAnimator.fractionComplete = translation.x / 320
        case .ended:
            interactiveAnimator.stopAnimation(true)
            self.imageView.transform = .init(scaleX: 0.8, y: 0.8)
            interactiveAnimator.addAnimations {
                self.imageView.transform = .identity
            }
            interactiveAnimator.startAnimation()
        default:
            return
        }
    }
}
