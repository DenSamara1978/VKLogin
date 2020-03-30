//
//  FavouriteGroupsController.swift
//  OpenWeather
//
//  Created by Denis on 07.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class FavouriteGroupsController: UITableViewController {

    private var searchController: UISearchController = .init ()
    
    private var groups: [Group] = []
    private var filteredGroups: [Group] = []
    
//    private var groups = [
//        Group ( _groupName : "My first", _image: UIImage ( named : "SampleImage" )! ),
//        Group ( _groupName : "My second", _image: UIImage ( named : "SampleImage" )! ),
//        Group ( _groupName : "My third", _image : UIImage ( named : "SampleImage" )! )
//    ]

    private var actuallyGroups : [Group] {
        return searchController.isActive ? filteredGroups : groups
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        Session.instance.receiveGroupList(completion: setGroupArray(_:) )
    }

    // MARK: - Table view data source

    public func setGroupArray ( _ groupArray: [Group] ) {
        groups = groupArray

        DispatchQueue.main.async {
            self.tableView.reloadData ()
            self.saveData ()
        }
    }
 
    func saveData() {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(groups)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actuallyGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            preconditionFailure ( "Can't dequeue GroupCell" )
        }
        cell.groupnameLabel.text = actuallyGroups [indexPath.row].groupName
        cell.groupImageView.setImage ( image: actuallyGroups [indexPath.row].img )
        return cell
    }
}

extension FavouriteGroupsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        filteredGroups = groups.reduce( [Group] (), { ( result, arg ) in
            var array = result
            if ( arg.groupName.lowercased().contains(text.lowercased())) {
                array.append ( arg )
            }
            return array
        })
        
        tableView.reloadData ()
    }
}
