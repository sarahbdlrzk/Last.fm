//
//  Album.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/3/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation
import RealmSwift

class Image: Object, Codable {
    
    let url: String?
    let size: String?
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
}


class Album: Object, Codable {
    @objc dynamic var name: String?
    let image: [Image]?
    @objc dynamic var artistName: String?
    var albumTracks: [Track]? 
    @objc dynamic var imageUrl: String?

}
