//
//  AlbumViewController.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/4/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import UIKit
import RealmSwift


class AlbumViewController: CollectionViewController {
    
    var album: Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.readAlbums()
        self.title = self.album.artistName
        let albumSection = CollectionViewSection(items: [AlbumViewModel(self.album)])

        if let albumName = album.name {
            albumSection.header = HeaderViewModel(albumName)
        }
        
        let grid = Grid(columns: 1, margin: UIEdgeInsets(all: 8))

        if let tracks = album.albumTracks {
            
            let songs = Array<Track>(tracks)
            let items = songs.map { SongViewModel($0) }
            let newItems: [CollectionViewViewModelProtocol] = Array(items.map { [$0] }
                .joined(separator: [SeparatorViewModel(2)]))
            
            let songSection = CollectionViewSection(items: newItems)
            songSection.header = HeaderViewModel("Tracks")
            self.source = CollectionViewSource(grid: grid, sections: [albumSection, songSection])

        } else {
            self.source = CollectionViewSource(grid: grid, sections: [albumSection])
        }
        
        self.collectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func readAlbums() {
        
        do {
            var albums: Results<Album>
            let realm = try Realm()
            albums = realm.objects(Album.self)
            if let _ = albums.first(where: { (theAlbum) -> Bool in
                theAlbum.name == album.name && theAlbum.artistName == album.artistName
            }) {
                let remove = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeTapped))
                navigationItem.rightBarButtonItems = [remove]
            } else {
                let save = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(saveTapped))
                navigationItem.rightBarButtonItems = [save]
            }
        } catch let error as NSError {
            // handle error
            print("error \(error)")
        }
    }
    @objc func saveTapped() {
    
        print("save")
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(album)
                readAlbums()
            }
        } catch let error as NSError {
            // handle error
            print("error \(error)")
        }
    }
    
    @objc func removeTapped() {
        do {
            var albums: Results<Album>
            let realm = try Realm()
            albums = realm.objects(Album.self)
            if let albumToDelete = albums.first(where: { (theAlbum) -> Bool in
                theAlbum.name == album.name && theAlbum.artistName == album.artistName
            }) {
                try realm.write {
                    realm.delete(albumToDelete)
                    readAlbums()
                }
            }
            
            
           
        } catch let error as NSError {
            // handle error
            print("error \(error)")
        }
    }
}
