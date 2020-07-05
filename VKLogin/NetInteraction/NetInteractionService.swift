//
//  NetInteractionService.swift
//  VKLogin
//
//  Created by Denis on 05.07.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

protocol NetInteractionService {
    func receiveFriendList ( completion: @escaping ( [Friend] ) -> Void )
    func receiveUserData ( user_ids: String, completion: @escaping ( [Friend] ) -> Void )
    func receiveGroupsData ( group_ids: String, completion: @escaping ( [Group] ) -> Void )
    func receiveGroupList ( completion: @escaping ( [Group] ) -> Void )
    func receiveNewsList ( startFrom: String, completion: @escaping ( [News], String ) -> Void )
    func receiveUserPhotoList ( user: String, completion: @escaping ( [String] ) -> Void )
    func receiveImageByURL ( imageUrl: String, completion: @escaping ( UIImage? ) -> Void )
    func receiveSearchedGroups ( _ groupName: String, completion: @escaping ( [Group] ) -> Void  )
}
