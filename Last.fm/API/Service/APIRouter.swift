//
//  APIRouter.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/2/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: Error {
    case invalidURL
    case responseParseError
}

enum APIRouter: APIConfiguration {
    
    case searchArtist(name: String)
   
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .searchArtist:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .searchArtist:
            return "/2.0/"
   
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .searchArtist(let name):
            return [K.APIParameterKey.artist: name, K.APIParameterKey.apiKey: K.Client.apiKey,
                    K.APIParameterKey.format: K.Client.json]
     
        }
    }
  
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchArtist(let name):
            return [URLQueryItem(name: K.APIParameterKey.method, value: "artist.search"),
            URLQueryItem(name: K.APIParameterKey.artist, value: name),
            URLQueryItem(name: K.APIParameterKey.apiKey, value: K.Client.apiKey),
            URLQueryItem(name: K.APIParameterKey.format, value: K.Client.json)]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        var components = URLComponents()
        components.scheme = K.Client.scheme
        components.host = K.Client.baseURL
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        return urlRequest
    }
}
