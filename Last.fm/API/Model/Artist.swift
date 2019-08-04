//
//  Artist.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/2/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation
import RealmSwift
/**
 Class that represent the Artist data.
 */
class Artist: Object, Codable {
    
    let name: String?
    let listeners: String?
    let mbid: String?
    let url: String?
    let streamable: String?
}
