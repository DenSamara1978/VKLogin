//
//  LikeControl.swift
//  OpenWeather
//
//  Created by Denis on 14.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

@IBDesignable class LikeControl: UIControl {

    var likes : Int = 0
    {
        didSet
        {
            self.updateControl()
        }
    }
    var hasMyLike : Bool = false
    {
        didSet
        {
            self.updateControl ()
        }
    }
    
    private var button : UIButton?
    private var imageView : UIImageView?
    private var stackView : UIStackView!
    
   
    override func layoutSubviews() {
        super.layoutSubviews()
        button?.frame = CGRect ( x: bounds.midX, y: 0, width: 40, height: 40 )
    }

    override init(frame: CGRect) {
        super.init ( frame: frame )
        setupControl ()
    }
    
    required init? ( coder: NSCoder ) {
        super.init ( coder: coder )
        setupControl ()
    }
    
    private func setupControl () {
        imageView = UIImageView (image: UIImage ( named : "Heart" ))
        imageView?.frame = CGRect ( x: 100, y: 0, width: 40, height: 30 )
        imageView?.alpha = 0.2
        
        let btn = UIButton (type: .system )
        //button.setImage ( image, for: .normal )
        btn.setTitle ( String ( likes ), for: .normal )
        btn.setTitleColor ( .lightGray, for: .normal )
        btn.addTarget ( self, action: #selector ( toggleLike (_:)), for: .touchUpInside )
        button = btn
        
        addSubview ( button! )
        addSubview ( imageView! )
    }
    
    private func updateControl () {
        if likes == 0 {
            button?.setTitleColor ( .lightGray, for: .normal )
        } else {
            button?.setTitleColor ( .red, for: .normal )
        }
        
        let alpha: Float = Float ( imageView?.alpha ?? 0.0 )
        
        if hasMyLike && alpha < 1.0 {
            UIView.animate ( withDuration: 0.5, animations: {
                self.imageView?.alpha = 1.0
            })
        }
        
        if !hasMyLike && alpha > 0.2 {
            UIView.animate ( withDuration: 0.5, animations: {
                self.imageView?.alpha = 0.2
            })
        }
        
        button!.setTitle ( String ( likes ), for: .normal )
    }
    
    @objc func toggleLike ( _ sender: UIButton ) {
        hasMyLike = !hasMyLike
        if hasMyLike {
            likes += 1;
        } else {
            likes -= 1;
        }
    }
}
