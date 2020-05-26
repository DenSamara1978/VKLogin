//
//  NewsPostCell.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 21.04.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class NewsPhotoCell : UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func resetImage () {
        photoImageView.image = UIImage ()
    }
    
    func setImage ( image: UIImage? ) {
        guard let image = image else { return }
        photoImageView.image = image
    }
}
