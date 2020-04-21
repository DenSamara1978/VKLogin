//
//  Post.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 21.04.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class PostNews : Object
{
    @objc dynamic var id : Int = 0
    @objc dynamic var text : String = ""
    @objc dynamic var commentsCount : Int = 0
    @objc dynamic var viewsCount : Int = 0
    @objc dynamic var repostsCount : Int = 0
    @objc dynamic var likesCount : Int = 0
    @objc dynamic var sourceName : String = ""
    
    convenience required init ( id: Int, source: String, text: String, comments: Int, views: Int, reposts: Int, likes: Int ) {
        self.init ()
        self.id = id
        sourceName = source
        self.text = text
        commentsCount = comments
        viewsCount = views
        repostsCount = reposts
        likesCount = likes
    }

    override class func primaryKey() -> String? {
        return "id"
    }
}
