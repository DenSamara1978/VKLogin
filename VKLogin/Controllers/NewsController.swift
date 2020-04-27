//
//  NewsControllerTableViewController.swift
//  OpenWeather
//
//  Created by Denis on 21.02.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class NewsController: UITableViewController {

    private var news: Results<PostNews>?
    private var realmNotification: NotificationToken?
    
    private var newsArray : [PostNews] {
        guard let news = news else { return [] }
        return Array ( news )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl ()
        refreshControl?.addTarget(self, action: #selector ( refresh ), for: .valueChanged)
        
        loadData ()
        NetSession.instance.receiveNewsList(completion: saveData )
    }

    @objc func refresh () {
        NetSession.instance.receiveNewsList(completion: saveData )
    }

    // MARK: - Table view data source

    private func saveData( _ newsArray: [PostNews] ) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add ( newsArray, update: .modified )
            try realm.commitWrite()
            refreshControl?.endRefreshing()
        } catch {
            print(error)
        }
    }
    
    private func loadData () {
        do {
            let realm = try Realm ()
            news = realm.objects ( PostNews.self )
            realmNotification = news?.observe { [weak self] (changes: RealmCollectionChange) in
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
        return newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostNewsCell", for: indexPath) as? PostNewsCell else {
            preconditionFailure ( "Can't dequeue PostNewsCell" )
        }
        
        let news = newsArray [indexPath.row]
        cell.postText.text = news.text
        cell.likesCountLabel.text = "\(news.likesCount)"
        cell.viewsCountLabel.text = "\(news.viewsCount)"
        cell.repostsCountLabel.text = "\(news.repostsCount)"
        cell.commentsCountLabel.text = "\(news.commentsCount)"
        cell.ownerName.text = news.sourceName
 
        if let image = news.avatar {
            cell.ownerImage.setImage ( image: image )
        } else {
            let url = news.photoUrl
            NetSession.instance.receiveImageByURL ( imageUrl: url ) { [ weak news, weak cell] ( image ) in
                news?.avatar = image
                cell?.ownerImage.setImage ( image: image )
            }
        }

        return cell
    }
}
