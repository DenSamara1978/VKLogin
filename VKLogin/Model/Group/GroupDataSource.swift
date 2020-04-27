//
//  GroupDataSource.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 27.04.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit


class GroupDataSource {
 
    private init () {
    }
    
    public static func receiveGroupList ( controller: UITableViewController? ) {
        let opq = OperationQueue ()
        
        let request = prepareRequest()
        let fetchDataOperation = FetchDataOperation(request: request)
        opq.addOperation(fetchDataOperation)
        
        let parser = GroupParser()
        parser.addDependency(fetchDataOperation)
        opq.addOperation(parser)
        
        let realmSaver = GroupRealm()
        realmSaver.addDependency(parser)
        OperationQueue.main.addOperation(realmSaver)

        let finalizator = FetchingFinalizator ( controller: controller )
        finalizator.addDependency(realmSaver)
        OperationQueue.main.addOperation ( finalizator )
    }
    
    private static func prepareRequest () -> URLRequest {
        var components = URLComponents ()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/groups.get"
        components.queryItems = [
            URLQueryItem ( name: "extended", value: "1" ),
            URLQueryItem ( name: "fields", value: "name, photo_200" ),
            URLQueryItem ( name: "access_token", value: NetSession.instance.token ),
            URLQueryItem ( name: "user_id", value: NetSession.instance.userId ),
            URLQueryItem ( name: "v", value: "5.68" )
        ]
        var request = URLRequest ( url: components.url! )
        request.httpMethod = "POST"
        return request
    }
}
