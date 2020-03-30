//
//  RoungImageView.swift
//  OpenWeather
//
//  Created by Denis on 12.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

@IBDesignable class RoundImageView: UIView {

    @IBInspectable var shadowColor : UIColor = .black
    {
        didSet
        {
            self.update ()
        }
    }

    @IBInspectable var shadowOpacity : CGFloat = 1.0
    {
        didSet
        {
            self.update ()
        }
    }

    @IBInspectable var shadowWidth : CGFloat = 2.0
    {
        didSet
        {
            self.update ()
        }
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    } ()
    
    var imageView : UIImageView?
    var shadowView : UIImageView?
    
    override init ( frame: CGRect )
    {
        super.init ( frame: frame )
        configure ()
    }
    
    required init? ( coder: NSCoder )
    {
        super.init ( coder: coder )
        configure ()
    }

    public func setImage ( image: UIImage? )
    {
        imageView?.image = image
    }
    
    func configure ()
    {
        let _imageView = UIImageView ( frame: CGRect ( x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height) )
        let _shadowView = UIImageView ( frame: bounds )

        _imageView.layer.cornerRadius = bounds.width / 2
        _imageView.layer.masksToBounds = true
        
        _shadowView.layer.cornerRadius = bounds.width / 2
        _shadowView.backgroundColor = .white
        
        imageView = _imageView
        shadowView = _shadowView
        
        addSubview ( _shadowView )
        addSubview ( _imageView )
        
        addGestureRecognizer ( tapGestureRecognizer )
        update ()
    }
    
    func update ()
    {
        shadowView?.layer.shadowColor = shadowColor.cgColor
        shadowView?.layer.shadowOffset = .init ( width: shadowWidth, height: 0 )
        shadowView?.layer.shadowOpacity = Float ( shadowOpacity )
    }
    
    @objc func pickImage () {
        UIView.animate ( withDuration: 0.2, animations: {
            self.imageView?.frame = CGRect ( x: ( self.imageView?.frame.origin.x ?? 0.0 ) + 5,
                                             y: ( self.imageView?.frame.origin.y ?? 0.0 ) + 5,
                                             width: 40,
                                             height: 40)
        })
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 2.0, options: [], animations: {
            self.imageView?.frame = CGRect ( x: ( self.imageView?.frame.origin.x ?? 0.0 ) - 5,
                                             y: ( self.imageView?.frame.origin.y ?? 0.0 ) - 5,
                                             width: 50,
                                             height: 50)
        })
        UIView.animate ( withDuration: 0.2, animations: {
            self.shadowView?.frame = CGRect ( x: ( self.shadowView?.frame.origin.x ?? 0.0 ) + 5,
                                             y: ( self.shadowView?.frame.origin.y ?? 0.0 ) + 5,
                                             width: 40,
                                             height: 40)
        })
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 2.0, options: [], animations: {
            self.shadowView?.frame = CGRect ( x: ( self.shadowView?.frame.origin.x ?? 0.0 ) - 5,
                                             y: ( self.shadowView?.frame.origin.y ?? 0.0 ) - 5,
                                             width: 50,
                                             height: 50)
        })
    }

}
