//
//  PostNewsBottomCell.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 23.05.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class NewsBottomCell : UITableViewCell {
    
    @IBOutlet weak var commentsCountLabel : UILabel!
    @IBOutlet weak var viewsCountLabel : UILabel!
    @IBOutlet weak var repostsCountLabel : UILabel!
    @IBOutlet weak var likesCountLabel : UILabel!
    @IBOutlet weak var likeImageView : UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        commentsCountLabel.text = "0"
        viewsCountLabel.text = "0"
        repostsCountLabel.text = "0"
        likesCountLabel.text = "0"
    }
}
