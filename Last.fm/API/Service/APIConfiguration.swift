//
//  APIConfiguration.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/2/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    
    var method: HTTPMethod { get }
    var path: String { get }
}
