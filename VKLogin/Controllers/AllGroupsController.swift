//
//  AllGroupsController.swift
//  OpenWeather
//
//  Created by Denis on 07.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class AllGroupsController: UITableViewController {

    private var searchController: UISearchController = .init ()
    lazy var photoManager = PhotoManager ( table: self.tableView )

    private var groups: [RealmGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }

    public func setGroupArray ( _ groupArray: [RealmGroup] ) {
        groups = groupArray
        tableView.reloadData ()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            preconditionFailure( "Can't dequeue GroupCell" )
        }
        cell.groupnameLabel.text = groups [indexPath.row].groupName
        cell.groupImageView.setImage ( image: photoManager.image ( at: groups [indexPath.row].photoUrl ))
        return cell
    }
}

extension AllGroupsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count < 2 {
            setGroupArray ( [] )
        } else {
            NetSession.instance.receiveSearchedGroups( text.lowercased (), completion: setGroupArray ( _: ))
        }
    }
}
