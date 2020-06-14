//
//  GroupFactory.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 14.06.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import Foundation
import RealmSwift

class GroupAdapter {
    private var realmNotificationToken: NotificationToken?
    
    func getGroups(then completion: @escaping ([Group]) -> Void) {
        guard let realm = try? Realm () else { return }

        let groups = realm.objects ( RealmGroup.self )
        realmNotificationToken = groups.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .update(let realmGroups, _, _, _):
                fallthrough
            case .initial(let realmGroups):
                var groups: [Group] = []
                for realmGroup in realmGroups {
                    groups.append(self.group(from: realmGroup))
                }
                completion(groups)
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
    }
    
    private func group(from rlmGroup: RealmGroup) -> Group {
        return Group(groupName: rlmGroup.groupName, photoUrl: rlmGroup.photoUrl );
    }
}
