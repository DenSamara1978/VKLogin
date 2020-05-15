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
    
    private var filteredGroups: [Group] = []
    
    private var groups: Results<Group>?
    private var realmNotification: NotificationToken?

    lazy var photoManager = PhotoManager ( table: self.tableView )

    private var groupsArray : [Group] {
        guard let gr = groups else { return [] }
        return Array ( gr )
    }
    
    private var actuallyGroups : [Group] {
        return searchController.isActive ? filteredGroups : groupsArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        refreshControl = UIRefreshControl ()
        refreshControl?.addTarget(self, action: #selector ( refresh ), for: .valueChanged)
        
        loadData ()
        GroupDataSource.receiveGroupList(controller: self)
    }
    
    @objc func refresh () {
        GroupDataSource.receiveGroupList(controller: self)
    }

    private func loadData () {
        do {
            let realm = try Realm ()
            groups = realm.objects ( Group.self )
            realmNotification = groups?.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        } catch {
            print ( error.localizedDescription )
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
        cell.groupImageView.setImage ( image: photoManager.image ( indexPath: indexPath, at: actuallyGroups [indexPath.row].photoUrl ))
        return cell
    }
}

extension FavouriteGroupsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        filteredGroups = groupsArray.reduce( [Group] (), { ( result, arg ) in
            var array = result
            if ( arg.groupName.lowercased().contains(text.lowercased())) {
                array.append ( arg )
            }
            return array
        })
        
        tableView.reloadData ()
    }
}
