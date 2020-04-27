//
//  LoginViewController.swift
//  OpenWeather
//
//  Created by Denis on 15.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import WebKit
import FirebaseDatabase
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var components = URLComponents ()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem ( name: "client_id", value: "7359954" ),
            URLQueryItem ( name: "display", value: "mobile" ),
            URLQueryItem ( name: "redirect_uri", value: "https://oauth.vk.com/blank.html" ),
            URLQueryItem ( name: "scope", value: "270342" ),
            URLQueryItem ( name: "response_type", value: "token" ),
            URLQueryItem ( name: "v", value: "5.68" ),
        ]
        
        let request = URLRequest ( url: components.url! )
        webView.navigationDelegate = self
        webView.load ( request )
        
    }
}

extension LoginViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler ( .allow )
            return
        }
        
        let params = fragment.components ( separatedBy: "&" ).map { $0.components ( separatedBy: "=" )}
            .reduce ( [String: String] ()) { ( result, param ) in
                var dict = result
                let key = param [0]
                let value = param [1]
                dict [key] = value
                return dict
        }
        
        let token = params ["access_token"] ?? "-1"
        print ( "Token is : \(token)" )
        NetSession.instance.token = token
        
        let user_id = params ["user_id"] ?? "-1"
        print ( "User_id is : \(user_id)" )
        NetSession.instance.userId = user_id

        Realm.Configuration.defaultConfiguration = Realm.Configuration ( deleteRealmIfMigrationNeeded: true )

        let db = Database.database().reference()
        NetSession.instance.receiveGroupList() { ( groups ) in
            groups.forEach() { ( body ) in
                db.child ( "users" ).child ( user_id ).child ( "groups" ).updateChildValues( [ "\(body.id)" : body.groupName ] )
            }
        }
        
        decisionHandler ( .cancel )
        performSegue(withIdentifier: "LoginSegue", sender: nil )
    }
    
}
