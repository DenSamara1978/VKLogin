//
//  FriendCell.swift
//  OpenWeather
//
//  Created by Denis on 08.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotoCell: ASCellNode {
    private let photoUrl: String
    private let imageNode = ASNetworkImageNode ()
    
    init ( url: String ) {
        photoUrl = url
        super.init()
        setupSubnodes()
    }
    
    private func setupSubnodes () {
        imageNode.url = URL(string: photoUrl)
        imageNode.cornerRadius = 10
        addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageWithInset = ASInsetLayoutSpec(insets: .init(top: 5, left: 5, bottom: 5, right: 5), child: imageNode)
        let imageRatioSpec = ASRatioLayoutSpec(ratio: 1, child: imageWithInset)
        let spec = ASStackLayoutSpec()
        spec.direction = .vertical
        spec.child = imageRatioSpec
        return spec
    }
    
}
