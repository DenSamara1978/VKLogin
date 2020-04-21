//
//  Session.swift
//  OpenWeather
//
//  Created by Denis on 13.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 Use
 
 Session.instance.token & Session.instance.userId to access the class fields
 
 */


class Session
{
    var token: String = "-1"
    var userId: String = "-1"
    
    static let instance = Session ()
    
    private init () {
    }
    
    public func receiveFriendList ( completion: @escaping ( [Friend] ) -> Void ) {
        post ( method: "friends.get", queries: [] ) {[completion] ( json ) in
            if ( json.count > 0 )
            {
                let userArray = json["items"].arrayValue
                var user_ids : String = ""
                for item in userArray {
                    if ( !user_ids.isEmpty ) {
                        user_ids += ","
                    }
                    user_ids += String ( item.intValue )
                }
                let queries = [
                    URLQueryItem ( name: "user_ids", value: user_ids ),
                    URLQueryItem ( name: "fields", value: "first_name, last_name, photo_200_orig" )
                ]
                self.post ( method: "users.get", queries: queries ) { [completion] ( json ) in
                    var friends : [Friend] = []
                    for item in json.arrayValue {
                        let id = item ["id"].intValue
                        let firstName = item ["first_name"].stringValue
                        let lastName = item ["last_name"].stringValue
                        let photoUrl = item ["photo_200_orig"].stringValue
                        let friend = Friend ( _id: id, _firstName: firstName, _lastName: lastName, _photoUrl: photoUrl )
                        friends.append ( friend )
                    }
                    completion ( friends )
                }
            }
            else {
                completion ( [] )
            }
        }
    }
    
    public func receiveGroupList ( completion: @escaping ( [Group] ) -> Void ) {
        let queries = [
            URLQueryItem ( name: "extended", value: "1" ),
            URLQueryItem ( name: "fields", value: "name, photo_200" )
        ]
        post ( method: "groups.get", queries: queries ) {[completion] ( json ) in
            var groups: [Group] = []
            if ( json.count > 0 ) {
                let groupArray = json ["items"].arrayValue
                for item in groupArray {
                    groups.append ( Group ( _id: item ["id"].intValue, _groupName: item ["name"].stringValue, _photoUrl: item ["photo_200"].stringValue ))
                }
            }
            completion ( groups )
        }
    }
    
    public func receiveNewsList ( completion: @escaping ( [PostNews] ) -> Void ) {
        let queries = [
            URLQueryItem ( name: "filters", value: "post" )
        ]
        post ( method: "newsfeed.get", queries: queries ) {[completion] ( json ) in
            var postNews : [PostNews] = []
            for item in json ["items"].arrayValue {

                let id = item["post_id"].intValue
                let text = item["text"].stringValue
                let comments = item["comments"]["count"].intValue
                let reposts = item["reposts"]["count"].intValue
                let likes = item["likes"]["count"].intValue
                let views = item["views"]["count"].intValue
 
                postNews.append ( PostNews ( id: id, source: "...", text: text, comments: comments, views: views, reposts: reposts, likes: likes ))
            }
            completion ( postNews )
        }
    }
    
    public func receiveUserPhotoList ( user: String, completion: @escaping ( [String] ) -> Void ) {
        let queries = [
            URLQueryItem ( name: "owner_id", value: user ),
            URLQueryItem ( name: "album_id", value: "profile" )
        ]
        post ( method: "photos.get", queries: queries ) {[completion] ( json ) in
            var urls : [String] = []
            for item in json ["items"].arrayValue {
                urls.append( item ["photo_130"].stringValue )
            }
            completion ( urls )
        }
    }
    
    public func receiveImageByURL ( imageUrl: String ) -> UIImage? {
        guard let url = URL(string: imageUrl) else { return nil }
        
        if let imageData: Data = try? Data(contentsOf: url) {
            return UIImage(data: imageData)
        }
        
        return nil
    }

    public func receiveSearchedGroups ( _ groupName: String, completion: @escaping ( [Group] ) -> Void  ) {
        post ( method: "groups.search", queries: [URLQueryItem ( name: "q", value: groupName )]) { [completion] ( json ) in
            var groups: [Group] = []
            if ( json.count > 0 ) {
                let groupArray = json ["items"].arrayValue
                for item in groupArray {
                    groups.append ( Group ( _id: item ["id"].intValue, _groupName: item ["name"].stringValue, _photoUrl: item ["photo_200"].stringValue ))
                }
            }
            completion ( groups )
        }
    }
    
    private func post ( method: String, queries: [URLQueryItem], completion: @escaping ( JSON ) -> Void  ) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)

        var components = URLComponents ()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/" + method
        components.queryItems = [
            URLQueryItem ( name: "access_token", value: token ),
            URLQueryItem ( name: "user_id", value: userId ),
            URLQueryItem ( name: "v", value: "5.68" )
        ]
        components.queryItems?.append(contentsOf: queries)
        
        var request = URLRequest ( url: components.url! )
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { [completion] (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSON(data: data)
                print ( json )
                completion ( json["response"] )
            } catch {
                print ( error.localizedDescription )
            }
        }
        task.resume()
    }
}
