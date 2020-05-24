//
//  Post.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 21.04.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class News : Object
{
    @objc dynamic var id : Int = 0
    @objc dynamic var text : String = ""
    @objc dynamic var commentsCount : Int = 0
    @objc dynamic var viewsCount : Int = 0
    @objc dynamic var repostsCount : Int = 0
    @objc dynamic var likesCount : Int = 0
    @objc dynamic var sourceName : String = ""
    @objc dynamic var avatarUrl : String = ""
    @objc dynamic var photoUrl : String = ""
    @objc dynamic var photoWidth : Double = 0.0
    @objc dynamic var photoHeight : Double = 0.0

     override class func primaryKey() -> String? {
        return "id"
    }
    
    var hasPhoto: Bool {
        return !photoUrl.trimmingCharacters ( in: .whitespacesAndNewlines ).isEmpty
    }
    
    var aspectRatio: CGFloat {
        return CGFloat ( photoHeight / photoWidth )
    }
}
