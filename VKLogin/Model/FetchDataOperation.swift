//
//  FetchDataOperation.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 27.04.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import Foundation

class FetchDataOperation : AsyncOperation {
   
    private var request: URLRequest
    var data: Data?
    
    override func main() {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)

        let task = session.dataTask(with: request) { [weak self] ( data, response, error ) in
            self?.data = data
            self?.state = .finished
        }
        task.resume()

    }
    
    init(request: URLRequest) {
        self.request = request
    }
}
