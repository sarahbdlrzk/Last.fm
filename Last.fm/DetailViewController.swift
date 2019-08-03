//
//  DetailViewController.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/3/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var artist: Artist?
    
    // Constants for Storyboard/ViewControllers.
    private static let storyboardName = "Main"
    private static let viewControllerIdentifier = "DetailViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func detailViewControllerForArtist(_ artist: Artist) -> UIViewController {
        let storyboard = UIStoryboard(name: DetailViewController.storyboardName, bundle: nil)
        
        let viewController =
            storyboard.instantiateViewController(withIdentifier: DetailViewController.viewControllerIdentifier)
        
        if let detailViewController = viewController as? DetailViewController {
            detailViewController.artist = artist
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
