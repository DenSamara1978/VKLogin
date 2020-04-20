//
//  ViewController.swift
//  OpenWeather
//
//  Created by Denis on 29.01.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().signInAnonymously() { ( result, error ) in
            if let error = error {
                print ( "Firebase error: \(error.localizedDescription)" )
            }
            else {
                print ( "Firebase connected" )
            }

        }
    }
    
}

