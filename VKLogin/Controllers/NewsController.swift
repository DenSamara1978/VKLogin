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

    private var news: Results<News>?
    private var realmNotification: NotificationToken?
    lazy var photoManager = PhotoManager ( table: self.tableView )
    
    private var startFrom: String = ""
    private var loading = false
    private var expandableCells: Set<IndexPath> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl ()
        refreshControl?.addTarget(self, action: #selector ( refresh ), for: .valueChanged)
        tableView.separatorStyle = .none
        tableView.prefetchDataSource = self
        
        loadData ()
        refresh()
    }

    @objc func refresh () {
        loading = true
        NetSession.instance.receiveNewsList( startFrom: startFrom, completion: saveData )
    }

    // MARK: - Table view data source

    private func saveData( _ newsArray: [News], nextFrom: String ) {
        do {
            startFrom = nextFrom
            let realm = try Realm()
            realm.beginWrite()
            realm.add ( newsArray, update: .modified )
            try realm.commitWrite()
            refreshControl?.endRefreshing()
        } catch {
            print(error)
        }
        loading = false
    }
    
    private func loadData () {
        do {
            let realm = try Realm ()
            news = realm.objects ( News.self )
            realmNotification = news?.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.deleteSections( .init ( deletions ), with: .automatic )
                    tableView.insertSections( .init ( insertions ), with: .automatic )
                    tableView.reloadSections( .init ( modifications ), with: .automatic )
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
        return news?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news?[section] else { return 0 }
        return news.hasPhoto ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let news = news?[indexPath.section] else { return UITableView.automaticDimension }
        if (( indexPath.row == 1 ) && ( news.hasPhoto )) {
            return tableView.bounds.size.width * news.aspectRatio
        }
        if ( indexPath.row == 0 ) {
            if ( expandableCells.contains ( indexPath )) {
                let cell = tableView.cellForRow(at: indexPath) as! NewsTopCell
                return cell.textHeight + 102
            }
            else {
                return 40 + 102
            }
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = news![indexPath.section]
        
        if ( indexPath.row == 0 ) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTopCell", for: indexPath) as! NewsTopCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.ownerName.text = post.sourceName
            cell.ownerImage.setImage ( image: photoManager.image ( indexPath: indexPath, at: post.avatarUrl ))
            let text = post.text
            cell.postText.text = text
            cell.textHeight = cell.postText.sizeThatFits(CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
            cell.enableButton ( button: cell.textHeight > 50 )
            if ( expandableCells.contains(indexPath)) {
                cell.showButton.setTitle( "Show less", for: .normal )
            }
            else {
                cell.showButton.setTitle( "Show more", for: .normal )
            }
            
            return cell
        }
        else if (( indexPath.row == 2 ) || ( !post.hasPhoto )) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsBottomCell", for: indexPath) as! NewsBottomCell
            cell.likesCountLabel.text = "\(post.likesCount)"
            cell.viewsCountLabel.text = "\(post.viewsCount)"
            cell.repostsCountLabel.text = "\(post.repostsCount)"
            cell.commentsCountLabel.text = "\(post.commentsCount)"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell", for: indexPath) as! NewsPhotoCell
            cell.resetImage ()
            cell.setImage(image: photoManager.image(indexPath: indexPath, at: post.photoUrl))
            return cell
        }
    }
}

extension NewsController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxNews = indexPaths.map(\.section).max(),
            let news = news, !loading,
            maxNews > news.count - 3 else { return }
        refresh ()
    }
}

extension NewsController: NewsTopCellDelegate {
    func onShowMoreTapped(indexPath: IndexPath) {
        if ( expandableCells.contains ( indexPath )) {
            expandableCells.remove ( indexPath )
        } else {
            expandableCells.insert ( indexPath )
        }
        tableView.reloadRows ( at: [indexPath], with: .automatic )
    }
}
