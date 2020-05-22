//
//  Friend.swift
//  OpenWeather
//
//  Created by Denis on 12.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class Friend : Object
{
    @objc dynamic var firstName : String = ""
    @objc dynamic var lastName : String = ""
    @objc dynamic var photoUrl : String = ""
    @objc dynamic var id : Int = 0
    var images : [UIImage?] = []

    convenience required init ( _id: Int, _firstName: String, _lastName: String, _photoUrl: String ) {
        self.init ()
        self.id = _id
        firstName = _firstName
        lastName = _lastName
        photoUrl = _photoUrl
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
