//
//  NewsPostCell.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 21.04.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class PostNewsCell : UITableViewCell {
    
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerImage: RoundImageView!
    @IBOutlet weak var postText: UILabel!
    
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
        
        ownerName.text = "Unknown"
        postText.text = "Post text."
    }
}
