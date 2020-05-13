//
//  FetchingFinalizator.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 28.04.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

class FetchingFinalizator : Operation {

    let controller : UITableViewController?
    
    init ( controller : UITableViewController? ) {
        self.controller = controller
    }
    
    override func main() {
        guard let realm = dependencies.first as? GroupRealm else { return }
        controller?.refreshControl?.endRefreshing()
    }

}
