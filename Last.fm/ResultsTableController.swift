//
//  ResultsTableController.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/3/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import UIKit

class ResultsTableController: UITableViewController {

    static let tableViewCellIdentifier = "cellID"
    private static let nibName = "TableCell"
  
    var artists: [Artist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: ResultsTableController.nibName, bundle: nil)        
        tableView.register(nib, forCellReuseIdentifier: ResultsTableController.tableViewCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

    }
}


// MARK: - UITableViewDelegate

extension ResultsTableController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArtist = self.artists[indexPath.row]
        // Set up the detail view controller to show.
        
        if let artistName = selectedArtist.name {
            APIClient.getTopAlbums(name: artistName) { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        let detailViewController = DetailViewController.detailViewControllerForArtist(
                            data, artistName: artistName)
                        self.navigationController?.pushViewController(detailViewController, animated: true)
                        tableView.deselectRow(at: indexPath, animated: false)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
   
    }
     
}

// MARK: - UITableViewDataSource

extension ResultsTableController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultsTableController.tableViewCellIdentifier,
                                                 for: indexPath)
        
        let artist = artists[indexPath.row]
        self.configureCell(cell, artist: artist)
        return cell
    }
    
    // MARK: - Configuration
    
    func configureCell(_ cell: UITableViewCell, artist: Artist) {
        cell.textLabel?.text = artist.name
    }
}
