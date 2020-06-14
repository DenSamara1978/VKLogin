//
//  FriendAdapter.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 14.06.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import Foundation
import RealmSwift

class FriendAdapter {
    private var realmNotificationToken: NotificationToken?
    
    func getFriends(then completion: @escaping ([Friend]) -> Void) {
        guard let realm = try? Realm () else { return }

        let friends = realm.objects ( RealmFriend.self )
        realmNotificationToken = friends.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .update(let realmFriends, _, _, _):
                fallthrough
            case .initial(let realmFriends):
                var friends: [Friend] = []
                for realmFriend in realmFriends {
                    friends.append(self.friend(from: realmFriend))
                }
                completion(friends)
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
    }
    
    private func friend(from rlmFriend: RealmFriend) -> Friend {
        return Friend (firstName: rlmFriend.firstName, lastName: rlmFriend.lastName, photoUrl: rlmFriend.photoUrl, images: rlmFriend.images, id: rlmFriend.id );
    }
}
