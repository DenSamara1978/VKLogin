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
    var img : UIImage?

    convenience required init ( _firstName: String, _lastName: String )
    {
        self.init ()
        self.firstName = _firstName
        self.lastName = _lastName
    }
}
