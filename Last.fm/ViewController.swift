//
//  ViewController.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/2/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: CollectionViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var albums: [Album] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.isHidden = true
        self.collectionView.isHidden = false
        self.readAlbums()
        let grid = Grid(columns: 4, margin: UIEdgeInsets(all: 8))
        
        let items = albums.map { album -> AlbumViewModel in
            let theAlbum = album
            let viewModel = AlbumViewModel(theAlbum)
            viewModel.delegate = self
            return viewModel
        }
        
        let albumSection = CollectionViewSection(items: items)
        albumSection.header = HeaderViewModel("Saved albums")
        
        self.source = CollectionViewSource(grid: grid, sections: [albumSection])
        self.collectionView.reloadData()

    }
    
    @IBAction func openSearch(_ sender: Any) {
        if searchBar.isHidden == true {
            searchBar.isHidden = false
            self.collectionView.isHidden = true
        } else {
            searchBar.isHidden = true
            self.collectionView.isHidden = false
        }
    }
    
    
    func readAlbums() {
        
        do {
            var theSavedAlbums: Results<Album>
            let realm = try Realm()
            theSavedAlbums = realm.objects(Album.self)
            self.albums.removeAll()
            for album in theSavedAlbums {
                self.albums.append(album)
            }
        } catch let error as NSError {
            // handle error
            print("error \(error)")
        }
    }
}


// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            APIClient.searchArtist(name: searchText) { (result) in
                switch result {
                case .success(let data):
                    let resultsTableController = ResultsTableController()
                    resultsTableController.artists = data
                    self.navigationController?.pushViewController(resultsTableController, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension ViewController: AlbumViewModelDelegate {
    
    func didSelect(album: Album) {
        if let albumName = album.name, let artistName = album.artistName {
            APIClient.getAlbumInfo(albumName: albumName, artistName: artistName) { (result) in
                switch result {
                case .success(let album):
                    DispatchQueue.main.async {
                        let viewController = AlbumViewController(nibName: nil, bundle: nil)
                        viewController.album = album
                        self.show(viewController, sender: nil)
                    }
                case .failure(let error):
                    print("error \(error)")
                }
            }
            
        }
        
    }
}



