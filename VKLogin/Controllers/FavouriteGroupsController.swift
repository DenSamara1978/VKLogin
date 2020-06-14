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

    private let groupService = GroupAdapter ()
    lazy var photoManager = PhotoManager ( table: self.tableView )
    
    private var searchController: UISearchController = .init ()
    
    private var filteredGroupViewModels: [GroupViewModel] = []
    
    private var groupViewModels: [GroupViewModel] = []
    private var realmNotification: NotificationToken?

    private var actuallyGroupViewModels : [GroupViewModel] {
        return searchController.isActive ? filteredGroupViewModels : groupViewModels
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        refreshControl = UIRefreshControl ()
        refreshControl?.addTarget(self, action: #selector ( refresh ), for: .valueChanged)
        
        groupService.getGroups(){ [weak self] groups in
            guard let self = self else { return }
            let factory = GroupViewModelFactory ()
            self.groupViewModels = factory.constructViewModels(from: groups)
            self.tableView.reloadData()
        }
        refresh ()
    }
    
    @objc func refresh () {
        GroupDataSource.receiveGroupList(controller: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actuallyGroupViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            preconditionFailure ( "Can't dequeue GroupCell" )
        }
        let group = actuallyGroupViewModels [indexPath.row]
        let image = photoManager.image(at: group.avatarUrl )
        cell.configure ( groupViewModel: group, image: image )
        return cell
    }
}

extension FavouriteGroupsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        filteredGroupViewModels = groupViewModels.reduce( [GroupViewModel] (), { ( result, arg ) in
            var array = result
            if ( arg.groupName.lowercased().contains(text.lowercased())) {
                array.append ( arg )
            }
            return array
        })
        
        tableView.reloadData ()
    }
}
