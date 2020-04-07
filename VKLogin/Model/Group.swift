//
//  Group.swift
//  OpenWeather
//
//  Created by Denis on 08.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class Group : Object
{
    @objc dynamic var groupName : String = ""
    @objc dynamic var id : Int = 0
    @objc dynamic var photoUrl : String = ""
    var img : UIImage?

    convenience required init ( _id: Int, _groupName: String, _photoUrl: String ) {
        self.init ()
        self.id = _id
        self.groupName = _groupName
        self.photoUrl = _photoUrl
        
        DispatchQueue.global().async {
            self.img = Session.instance.receiveImageByURL ( imageUrl: _photoUrl )
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
