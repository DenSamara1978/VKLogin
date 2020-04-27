//
//  GroupRealm.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 28.04.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import Foundation
import RealmSwift

class GroupRealm : Operation {

    override func main() {
        guard let parser = dependencies.first as? GroupParser else { return }
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add ( parser.groups, update: .modified )
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
