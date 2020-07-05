//
//  NetProxy.swift
//  VKLogin
//
//  Created by Denis on 05.07.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class NetProxy : NetInteractionService {
    let service: NetInteractionService
        
    public init (service: NetInteractionService) {
        self.service = service
    }
    
    func receiveFriendList(completion: @escaping ([Friend]) -> Void) {
        service.receiveFriendList(completion: completion)
    }
    
    func receiveUserData(user_ids: String, completion: @escaping ([Friend]) -> Void) {
        service.receiveUserData(user_ids: user_ids, completion: completion)
    }
    
    func receiveGroupsData(group_ids: String, completion: @escaping ([Group]) -> Void) {
        service.receiveGroupsData(group_ids: group_ids, completion: completion)
    }
    
    func receiveGroupList(completion: @escaping ([Group]) -> Void) {
        service.receiveGroupList(completion: completion)
    }
    
    func receiveNewsList(startFrom: String, completion: @escaping ([News], String) -> Void) {
        service.receiveNewsList(startFrom: startFrom, completion: completion)
    }
    
    func receiveUserPhotoList(user: String, completion: @escaping ([String]) -> Void) {
        service.receiveUserPhotoList(user: user, completion: completion)
    }
    
    func receiveImageByURL(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        service.receiveImageByURL(imageUrl: imageUrl, completion: completion)
    }
    
    func receiveSearchedGroups(_ groupName: String, completion: @escaping ([Group]) -> Void) {
        service.receiveSearchedGroups(groupName, completion: completion)
    }
    
    
}
