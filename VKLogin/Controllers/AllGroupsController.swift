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
    
    private var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - Table view data source

    public func setGroupArray ( _ groupArray: [Group] ) {
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

        let group = groups [indexPath.row]
        if let image = group.img {
            cell.groupImageView.setImage ( image: image )
        } else {
            let url = group.photoUrl
            NetSession.instance.receiveImageByURL ( imageUrl: url ) { [weak self, weak group, url] ( image ) in
                guard let group = group else { return }
                if group.photoUrl == url {
                    group.img = image
                    self?.tableView.reloadRows ( at: [indexPath], with: .automatic )
                }
            }
        }

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
