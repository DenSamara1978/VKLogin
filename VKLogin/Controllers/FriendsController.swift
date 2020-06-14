//
//  FriendsListController.swift
//  OpenWeather
//
//  Created by Denis on 07.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsController: UITableViewController {

    private let friendService = FriendAdapter ()
    lazy var photoManager = PhotoManager ( table: self.tableView )

    private let searchController : UISearchController = .init ()

    private var filteredFriendViewModels : [ String: [FriendViewModel]] = [:]
    private var friendViewModelsResult: [FriendViewModel] = []
    private var realmNotification: NotificationToken?
    
    private var sections : [String] {
        return Array ( actuallyFriendViewModels.keys ).sorted ()
    }
    
    private var friendViewModels : [String : [FriendViewModel]] {
        var result : [ String : [FriendViewModel]] = [:]
        for friend in friendViewModelsResult {
            let letter = String ( friend.friendName.first ?? "-" )
            if ( result [letter] == nil ) {
                result [letter] = [friend]
            }
            else {
                result [letter]?.append(friend)
            }
        }
        return result
    }

    private var actuallyFriendViewModels : [ String: [FriendViewModel]] {
        return searchController.isActive ? filteredFriendViewModels : friendViewModels
    }
    
    private func getFriend ( section: Int, row: Int ) -> FriendViewModel? {
        let title = sections [section]
        return actuallyFriendViewModels [title]?[row]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        refreshControl = UIRefreshControl ()
        refreshControl?.addTarget( self, action: #selector ( refresh ), for: .valueChanged)
        
        friendService.getFriends() { [ weak self] friends in
            guard let self = self else { return }
            let factory = FriendViewModelFactory ()
            self.friendViewModelsResult = factory.constructViewModels(from: friends)
            self.tableView.reloadData()
        }
        refresh ()
    }

    @objc func refresh () {
        NetSession.instance.receiveFriendList ( completion: saveData )
    }

    private func saveData( _ list: [RealmFriend] ) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add ( list, update: .modified )
            try realm.commitWrite()
            refreshControl?.endRefreshing()
        } catch {
            print(error)
        }
    }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = sections [section]
        return ( actuallyFriendViewModels [title] )?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections [section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            preconditionFailure( "Can't dequeue FriendCell" )
        }
        let friend = getFriend ( section: indexPath.section, row: indexPath.row )
        let image = photoManager.image(at: friend?.avatarUrl ?? "" )
        cell.configure(friendViewModel: friend, image: image )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PhotoController(friend: getFriend ( section: indexPath.section, row: indexPath.row ))
        tableView.deselectRow(at: indexPath, animated: false)
        present(vc, animated: true, completion: nil)
    }
}

extension FriendsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        filteredFriendViewModels = friendViewModels.reduce ( [String: [FriendViewModel]] (), { ( result, arg ) in
            let ( key, value ) = arg
            var dict = result
            
            let filtered = value.filter{
                $0.friendName.lowercased().contains(text.lowercased())
            }
            
            if ( !filtered.isEmpty ) {
                dict [key] = filtered
            }
            
            return dict
        })
        
        tableView.reloadData ()
    }
}
