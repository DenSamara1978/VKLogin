//
//  FriendListCell.swift
//  OpenWeather
//
//  Created by Denis on 08.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendImageView: RoundImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        friendNameLabel.text = ""
        friendImageView.setImage(image: nil)
    }

    func configure ( friendViewModel: FriendViewModel?, image: UIImage? ) {
        guard let friendViewModel = friendViewModel else { return }
        friendNameLabel.text = friendViewModel.friendName
        friendImageView.setImage ( image: image )
    }
}
