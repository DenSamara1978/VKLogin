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

    private var friendsArray : [Friend] = []
    private var friends : [ String: [Friend]] = [:]
    private var filteredFriends : [ String: [Friend]] = [:]
    
    private let searchController : UISearchController = .init ()
    
    private var sections : [String] {
        return Array ( actuallyFriends.keys ).sorted ()
    }

    private var actuallyFriends : [ String: [Friend]] {
        return searchController.isActive ? filteredFriends : friends
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        
        loadData ()
        Session.instance.receiveFriendList ( completion: setFriendList )
    }

    private func getFriend ( section: Int, row: Int ) -> Friend? {
        let title = sections [section]
        return actuallyFriends [title]?[row]
    }
    
    private func buildFriendsDict () {
        friends = [:]
        for friend in friendsArray {
            let letter = String ( friend.firstName.first ?? "-" )
            friendsArray.append ( friend )
            if ( friends [letter] == nil ) {
                friends [letter] = [friend]
            }
            else {
                friends [letter]?.append(friend)
            }
        }
    }
    
    func setFriendList ( _ list: [Friend] ) {
        friendsArray = list
        buildFriendsDict()
        
        DispatchQueue.main.async {
            self.tableView.reloadData ()
            self.saveData ()
        }
    }
    
    private func saveData() {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration ( deleteRealmIfMigrationNeeded: true )
            let realm = try Realm()
            realm.beginWrite()
            realm.add ( friendsArray, update: .modified )
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
   
    private func loadData () {
        do {
            let realm = try Realm ()
            friendsArray = Array ( realm.objects ( Friend.self ))
            buildFriendsDict()
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
        
        if let image = friend?.img {
            cell.friendImageView.setImage ( image: image )
        } else {
            let url = friend?.photoUrl ?? ""
            DispatchQueue.global().async {
                let image = Session.instance.receiveImageByURL ( imageUrl: url )
                
                DispatchQueue.main.async {
                    friend?.img = image
                    self.tableView.reloadRows ( at: [indexPath], with: .automatic )
                }
            }
        }

//        DispatchQueue.global().async {
//            let image = Session.instance.receiveImageByURL ( imageUrl: url )
//
//            DispatchQueue.main.async {
//                cell.friendImageView.setImage ( image: image )
//                friend?.img = image
//            }
//        }
//        
        return cell
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Friend's Photos", let indexPath = tableView.indexPathForSelectedRow {
            let destinationViewController = segue.destination as? NewPhotoController
            let friend = getFriend ( section: indexPath.section, row: indexPath.row )
            destinationViewController?.friendName = (friend?.firstName ?? "") + " " + (friend?.lastName ?? "")
            destinationViewController?.friendImage = friend?.img
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
