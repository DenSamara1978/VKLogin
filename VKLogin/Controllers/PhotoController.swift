//
//  FriendController.swift
//  OpenWeather
//
//  Created by Denis on 07.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class PhotoController: UICollectionViewController {

    var friend: Friend?
    var photoUrls: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        title = ( friend?.firstName ?? "" ) + " " + ( friend?.lastName ?? "" )
        Session.instance.receiveUserPhotoList ( user: "\(friend?.id ?? -1)" ) { ( urls: [String] ) in
            self.photoUrls = urls
            if ( self.friend?.images.count != urls.count ) {
                self.friend?.images = Array ( repeating: nil, count: urls.count )
            }
            DispatchQueue.main.async () {
                self.collectionView.reloadData ()
            }
        }
    }

     // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            preconditionFailure( "Can't dequeue PhotoCell" )
        }
        
        let row = indexPath.row
        if let image = friend?.images [row] {
            cell.imageView.image = image
        } else {
            let url = photoUrls [row]
            DispatchQueue.global().async {
                let image = Session.instance.receiveImageByURL ( imageUrl: url )
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.friend?.images [row] = image
                }
            }
        }

        return cell
    }
}
