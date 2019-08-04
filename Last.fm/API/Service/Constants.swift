//
//  Constants.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/2/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation

struct K {
    struct Client {
        static let scheme = "http"
        static let baseURL = "ws.audioscrobbler.com"
        static let apiKey = "47b578897e70196c0f98df0d3f21faee"
        static let json = "json"
    }
    
    struct APIParameterKey {
        static let artist = "artist"
        static let apiKey = "api_key"
        static let format = "format"
        static let method = "method"
        static let album = "album"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
