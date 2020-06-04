//
//  FriendController.swift
//  OpenWeather
//
//  Created by Denis on 07.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotoController: ASViewController<ASDisplayNode> {
    var friend: Friend?
    var photoUrls: [String] = []
    
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    
    init ( friend: Friend? ) {
        super.init(node: ASTableNode())
        
        self.friend = friend
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = ( friend?.firstName ?? "" ) + " " + ( friend?.lastName ?? "" )
        NetSession.instance.receiveUserPhotoList ( user: "\(friend?.id ?? -1)" ) { ( urls: [String] ) in
            self.photoUrls = urls
            DispatchQueue.main.async {
                self.tableNode.reloadData ()
            }
        }
    }

}

extension PhotoController: ASTableDelegate {
    
}

extension PhotoController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return photoUrls.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let url = photoUrls[indexPath.row]
        return PhotoCell(url: url)
    }
}
