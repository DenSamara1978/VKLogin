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

    private var filteredFriends : [ String: [Friend]] = [:]
    
    private let searchController : UISearchController = .init ()
    
    private var friendsResult: Results<Friend>?
    private var realmNotification: NotificationToken?

    private var sections : [String] {
        return Array ( actuallyFriends.keys ).sorted ()
    }
    
    private var friends : [String : [Friend ]] {
        var result : [ String : [Friend]] = [:]
        guard let fr = friendsResult else { return [:] }
        let frs = Array ( fr )
        for friend in frs {
            let letter = String ( friend.firstName.first ?? "-" )
            if ( result [letter] == nil ) {
                result [letter] = [friend]
            }
            else {
                result [letter]?.append(friend)
            }
        }
        return result
    }

    private var actuallyFriends : [ String: [Friend]] {
        return searchController.isActive ? filteredFriends : friends
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        refreshControl = UIRefreshControl ()
        refreshControl?.addTarget( self, action: #selector ( refresh ), for: .valueChanged)
        
        loadData ()
        NetSession.instance.receiveFriendList ( completion: saveData )
    }

    @objc func refresh () {
        NetSession.instance.receiveFriendList ( completion: saveData )
    }

    private func getFriend ( section: Int, row: Int ) -> Friend? {
        let title = sections [section]
        return actuallyFriends [title]?[row]
    }
    
    private func saveData( _ list: [Friend] ) {
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
   
    private func loadData () {
        do {
            let realm = try Realm ()
            friendsResult = realm.objects ( Friend.self )
            realmNotification = friendsResult?.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    print ( "initial" )
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    print ( "reload" )
                    tableView.reloadData()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        } catch {
            print ( error.localizedDescription )
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
        return ( actuallyFriends [title] )?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections [section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            preconditionFailure( "Can't dequeue FriendCell" )
        }
        let friend = getFriend ( section: indexPath.section, row: indexPath.row )
        cell.friendNameLabel.text = ( friend?.firstName ?? "" ) + " " + (friend?.lastName ?? "")
        
        if let image = friend?.avatar {
            cell.friendImageView.setImage ( image: image )
        } else {
            let url = friend?.photoUrl ?? ""
            NetSession.instance.receiveImageByURL ( imageUrl: url ) { [ weak friend, weak cell] ( image ) in
                friend?.avatar = image
                cell?.friendImageView.setImage ( image: image )
            }
        }

        return cell
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Friend's Photos", let indexPath = tableView.indexPathForSelectedRow {
            let destinationViewController = segue.destination as? PhotoController
            if let friend = getFriend ( section: indexPath.section, row: indexPath.row ) {
                destinationViewController?.friend = friend
            }
        }
    }
    

}

extension FriendsController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        filteredFriends = friends.reduce ( [String: [Friend]] (), { ( result, arg ) in
            let ( key, value ) = arg
            var dict = result
            
            let filtered = value.filter{
                $0.firstName.lowercased().contains(text.lowercased()) ||
                    $0.lastName.lowercased().contains(text.lowercased())
            }
            
            if ( !filtered.isEmpty ) {
                dict [key] = filtered
            }
            
            return dict
        })
        
        tableView.reloadData ()
    }
}
