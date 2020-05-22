
//
//  PhotoManager.swift
//  VKLogin
//
//  Created by Denis Vlaskin on 15.05.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

fileprivate protocol Reloadable {
    func reloadRow( index: IndexPath )
}


class PhotoManager {
    private let cacheLifeTime: TimeInterval = 3600
    private var images = [String: UIImage]()
    
    private let container: Reloadable
    private let queue = DispatchQueue(label: "photo.cache.queue")

    private static let pathName: String = {
        let pathName = "images"
        guard let cacheDir = FileManager.default.urls ( for: .cachesDirectory, in: .userDomainMask ).first else { return pathName }
        
        let url = cacheDir.appendingPathComponent ( pathName )
        if ( !FileManager.default.fileExists ( atPath: url.path )) {
            do {
                try FileManager.default.createDirectory ( at: url, withIntermediateDirectories: true, attributes: nil )
            } catch {
                print ( error.localizedDescription )
            }
        }
        return pathName
    }()
    
    init( table: UITableView ) {
        container = Table(table: table)
    }
    
    init( collection: UICollectionView ) {
        container = Collection(collection: collection)
    }
  
    private func loadImage ( indexPath: IndexPath, url: String ) {
        queue.async {
            guard let dataUrl = URL(string: url) else { return }
            if let imageData: Data = try? Data(contentsOf: dataUrl) {
                guard let image = UIImage ( data: imageData ) else { return }
                self.images [url] = image
                self.saveImageToCache ( url: url, image: image )
                DispatchQueue.main.async { [weak self] in
                    self?.container.reloadRow ( index: indexPath )
                }
            }
        }
    }
    
    private func getFilePath ( url: String ) -> String? {
        guard let cacheDir = FileManager.default.urls ( for: .cachesDirectory, in: .userDomainMask ).first else { return nil }
        let fileName = url.split ( separator: "/" ).last ?? "default"
        return cacheDir.appendingPathComponent ( PhotoManager.pathName + fileName ).path
    }
    
    private func saveImageToCache ( url: String, image: UIImage ) {
        if let filePath = getFilePath ( url: url ) {
            FileManager.default.createFile ( atPath: filePath, contents: image.pngData(), attributes: nil )
        }
    }
    
    private func readImageFromCache ( url: String ) -> UIImage? {
        guard let filePath = getFilePath ( url: url ),
            let info = try? FileManager.default.attributesOfItem ( atPath: filePath ),
            let modificationDate = info [FileAttributeKey.modificationDate] as? Date else { return nil }
        
        if ( Date().timeIntervalSince(modificationDate) > cacheLifeTime ) { return nil }
        guard let image = UIImage(contentsOfFile: filePath) else { return nil }
        images[url] = image
        return image
    }
    
    func image ( indexPath: IndexPath, at url: String ) -> UIImage? {
        if let cached = images [url] {
            return cached
        }
        else if let cached = readImageFromCache ( url: url ) {
            return cached
        }
        else {
            loadImage ( indexPath: indexPath, url: url)
            return nil
        }
    }
}

extension PhotoManager {
    private class Table: Reloadable {
        let table: UITableView
        
        init( table: UITableView ) {
            self.table = table
        }
        
        func reloadRow ( index: IndexPath ) {
            table.reloadRows ( at: [index], with: .automatic )
        }
    }
    
    
    private class Collection: Reloadable {
        let collection: UICollectionView
        
        init( collection: UICollectionView ) {
            self.collection = collection
        }
        
        func reloadRow ( index: IndexPath ) {
            collection.reloadItems ( at: [index] )
        }
    }
    
}
