//
//  FriendCell.swift
//  OpenWeather
//
//  Created by Denis on 08.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
