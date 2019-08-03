//
//  ViewController.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/2/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchBar.isHidden = true
    }
    
    @IBAction func openSearch(_ sender: Any) {
        if searchBar.isHidden == true {
            searchBar.isHidden = false
        } else {
            searchBar.isHidden = true
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




