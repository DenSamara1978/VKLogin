//
//  GroupParser.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 28.04.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import Foundation
import SwiftyJSON

class GroupParser : Operation {
    
    var groups: [Group] = []
    
    override func main() {
        guard let fetchDataOperation = dependencies.first as? FetchDataOperation,
            let data = fetchDataOperation.data else { return }
       
        do {
            let fullJson = try JSON(data: data)
            print ( fullJson )
            let json = fullJson["response"]
            if ( json.count > 0 ) {
                let groupArray = json ["items"].arrayValue
                for item in groupArray {
                    groups.append ( Group ( _id: item ["id"].intValue, _groupName: item ["name"].stringValue, _photoUrl: item ["photo_200"].stringValue ))
                }
            }
        } catch {
            print ( error.localizedDescription )
        }
    }
}
