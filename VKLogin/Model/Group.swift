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
    var img : UIImage?

    convenience required init ( _groupName: String )
    {
        self.init ()
        self.groupName = _groupName
    }
}
