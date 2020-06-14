//
//  FriendViewModelFactory.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 14.06.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

final class FriendViewModelFactory {

    func constructViewModels(from friends: [Friend]) -> [FriendViewModel] {
        var vms: [FriendViewModel] = []
        friends.forEach { [weak self] (friend) in
            guard let self = self else { return }
            vms.append ( self.viewModel ( from: friend ))
        }
        return vms
    }
    
    private func viewModel(from friend: Friend) -> FriendViewModel {
        let friendName = friend.firstName + " " + friend.lastName
        let avatarUrl = friend.photoUrl
        let images = friend.images
        let id = friend.id
        return FriendViewModel (friendName: friendName, avatarUrl: avatarUrl, images: images, id: id)
    }
}

