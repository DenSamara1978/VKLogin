//
//  PostNewsTopCell.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 23.05.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

protocol NewsTopCellDelegate: class {
    func onShowMoreTapped ( indexPath: IndexPath )
}

class NewsTopCell : UITableViewCell {
    
    weak var delegate: NewsTopCellDelegate?
    var indexPath: IndexPath?
    var textHeight: CGFloat = 0.0
    
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerImage: RoundImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var showButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ownerName.text = "Unknown"
        postText.text = "News text."
    }
    
    func enableButton ( button: Bool ) {
        showButton.isHidden = !button
    }
    
    @IBAction func showMoreButtonTapped ( _ sender: AnyObject ) {
        guard let index = indexPath else { return }
        delegate?.onShowMoreTapped ( indexPath: index )
    }
}
