//
//  DetailViewController.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/3/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import UIKit

class DetailViewController: CollectionViewController {

    var albums: [Album] = []
    var artistName: String = ""
    // Constants for Storyboard/ViewControllers.
    private static let storyboardName = "Main"
    private static let viewControllerIdentifier = "DetailViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = artistName
        let grid = Grid(columns: 4, margin: UIEdgeInsets(all: 8))

        let items = albums.map { album -> AlbumViewModel in
            let theAlbum = album
            theAlbum.artistName = artistName
            let viewModel = AlbumViewModel(theAlbum)
            viewModel.delegate = self
            return viewModel
        }
        
        let albumSection = CollectionViewSection(items: items)
        albumSection.header = HeaderViewModel("Top albums")
        
        self.source = CollectionViewSource(grid: grid, sections: [albumSection])
        self.collectionView.reloadData()
    }
    
    class func detailViewControllerForArtist(_ albums: [Album], artistName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: DetailViewController.storyboardName, bundle: nil)
        
        let viewController =
            storyboard.instantiateViewController(withIdentifier: DetailViewController.viewControllerIdentifier)
        
        if let detailViewController = viewController as? DetailViewController {
            detailViewController.albums = albums
            detailViewController.artistName = artistName
        }
        
        return viewController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension DetailViewController: AlbumViewModelDelegate {
    
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
