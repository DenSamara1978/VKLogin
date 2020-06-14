//
//  FriendDataSource.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 14.05.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON

class FriendDataSource {
 
    private init () {
    }
    
    public static func receiveFriendList ( controller: UITableViewController? ) -> Promise<[RealmFriend]> {
        let request = prepareRequest()
        return URLSession.shared.dataTask ( .promise, with: request )
            .then(on: DispatchQueue.global ()) { response -> Promise<[RealmFriend]> in
                var friends : [RealmFriend] = []
                do {
                    let json = try JSON(data: response.data)
                    print ( json )
                    if ( json.count > 0 )
                    {
                        let userArray = json["response"]["items"].arrayValue
                        var user_ids : String = ""
                        for item in userArray {
                            if ( !user_ids.isEmpty ) {
                                user_ids += ","
                            }
                            user_ids += String ( item.intValue )
                        }
                        for item in json["response"]["items"].arrayValue {
                            let id = item ["id"].intValue
                            let firstName = item ["first_name"].stringValue
                            let lastName = item ["last_name"].stringValue
                            let photoUrl = item ["photo_200_orig"].stringValue
                            let friend = RealmFriend ( _id: id, _firstName: firstName, _lastName: lastName, _photoUrl: photoUrl )
                            friends.append ( friend )
                        }
                    }
                }
                return Promise.value ( friends )
        }
    }

    private static func prepareRequest () -> URLRequest {
        var components = URLComponents ()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/friends.get"
        components.queryItems = [
            URLQueryItem ( name: "access_token", value: NetSession.instance.token ),
            URLQueryItem ( name: "user_id", value: NetSession.instance.userId ),
            URLQueryItem ( name: "fields", value: "photo_50" ),
            URLQueryItem ( name: "v", value: "5.68" )
        ]
        var request = URLRequest ( url: components.url! )
        request.httpMethod = "GET"
        return request
    }
    
    private static func prepareUserDataRequest ( user_ids: String ) -> URLRequest {
        var components = URLComponents ()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/users.get"
        components.queryItems = [
            URLQueryItem ( name: "user_ids", value: user_ids ),
            URLQueryItem ( name: "fields", value: "first_name, last_name, photo_200_orig" ),
            URLQueryItem ( name: "access_token", value: NetSession.instance.token ),
            URLQueryItem ( name: "user_id", value: NetSession.instance.userId ),
            URLQueryItem ( name: "v", value: "5.68" )
        ]
        var request = URLRequest ( url: components.url! )
        request.httpMethod = "POST"
        return request
    }
}
