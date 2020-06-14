//
//  GroupCell.swift
//  OpenWeather
//
//  Created by Denis on 08.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    @IBOutlet weak var groupnameLabel: UILabel!
    @IBOutlet weak var groupImageView: RoundImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        groupnameLabel.text = ""
        groupImageView.setImage ( image: nil )
    }
    
    func configure ( groupViewModel: GroupViewModel, image: UIImage? ) {
        groupnameLabel.text = groupViewModel.groupName
        groupImageView.setImage ( image: image )
    }
}
