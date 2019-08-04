//
//  Track.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/4/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation
import RealmSwift

class Track: Object, Codable {
    
    let name: String?
    let duration: String?
}
