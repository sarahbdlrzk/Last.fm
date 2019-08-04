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
    case getTopAlbums(name: String)
    case getAlbumInfo(albumName: String, artistName: String)

   
    // MARK: - HTTPMethod
    var method: HTTPMethod {
         return .get
    }
    
    // MARK: - Path
    var path: String {
        return "/2.0/"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchArtist(let name):
            return [URLQueryItem(name: K.APIParameterKey.method, value: "artist.search"),
            URLQueryItem(name: K.APIParameterKey.artist, value: name),
            URLQueryItem(name: K.APIParameterKey.apiKey, value: K.Client.apiKey),
            URLQueryItem(name: K.APIParameterKey.format, value: K.Client.json)]
        case .getTopAlbums(let name):
            return [URLQueryItem(name: K.APIParameterKey.method, value: "artist.gettopalbums"),
                    URLQueryItem(name: K.APIParameterKey.artist, value: name),
                    URLQueryItem(name: K.APIParameterKey.apiKey, value: K.Client.apiKey),
                    URLQueryItem(name: K.APIParameterKey.format, value: K.Client.json)]
        case .getAlbumInfo(let albumName, let artistName):
            return [URLQueryItem(name: K.APIParameterKey.method, value: "album.getinfo"),
                    URLQueryItem(name: K.APIParameterKey.album, value: albumName),
                    URLQueryItem(name: K.APIParameterKey.artist, value: artistName),
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
        print(url)
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        return urlRequest
    }
}
