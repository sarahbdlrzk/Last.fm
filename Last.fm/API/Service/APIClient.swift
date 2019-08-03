//
//  APIClient.swift
//  Last.fm
//
//  Created by Sarah Abdelrazak on 8/2/19.
//  Copyright © 2019 Sarah. All rights reserved.
//

import Foundation
import Alamofire

/**
 `APIClient` class that provides static methods to call the different client APIs e.g. Search Artist, etc...
 */
class APIClient {
    
    /**
     Method that search for Artist with given name.
     - Parameters:
       - name: The name of the Artist to search for.
       - completion: The completion closure to be called after API result is returned and parsed.
     */
    static func searchArtist(name: String, completion:@escaping (Result<[Artist], Error>)->Void) {
    
        AF.request(APIRouter.searchArtist(name: name)).response { (dataResposne) in
            if let data = dataResposne.data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                        let result = json["results"] as? [String : Any],
                        let matches = result["artistmatches"] as? [String : Any],
                        let artists = matches["artist"] as? [[String : Any]] {
                        let data = try JSONSerialization.data(withJSONObject: artists, options: [])
                        let decoder = JSONDecoder()
                        let model = try decoder.decode([Artist].self, from:
                            data) //Decode JSON Response Data
                        completion(.success(model))
                    }
                } catch {
                    completion(.failure(APIError.responseParseError))
                }
            }
        }
    }
}
