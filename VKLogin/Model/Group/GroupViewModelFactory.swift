//
//  GroupViewModelFactory.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 14.06.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

final class GroupViewModelFactory {

    func constructViewModels(from groups: [Group]) -> [GroupViewModel] {
        var vms: [GroupViewModel] = []
        var indexPath = IndexPath (row: 0, section: 0)
        groups.forEach { [weak self] (group) in
            guard let self = self else { return }
            indexPath.row += 1
            vms.append ( self.viewModel ( from: group, indexPath: indexPath ))
        }
        return vms
    }
    
    private func viewModel(from group: Group, indexPath: IndexPath) -> GroupViewModel {
        let groupName = group.groupName
        let avatarUrl =  group.photoUrl
        return GroupViewModel (groupName: groupName, avatarUrl: avatarUrl )
    }
}
