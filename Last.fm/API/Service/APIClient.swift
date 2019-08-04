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
    
    
    /**
     Get top albums for the given artist.
     - Parameters:
       - name: The name of the Artist to get his/her top albums
       - completion: The completion closure to be called after API result is returned and parsed.
     */
    static func getTopAlbums(name: String, completion:@escaping (Result<[Album], Error>)->Void) {
        
        AF.request(APIRouter.getTopAlbums(name: name)).response { (dataResposne) in
            if let data = dataResposne.data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                        let result = json["topalbums"] as? [String : Any],
                        let albums = result["album"] as? [[String : Any]] {
                        var model: [Album] = []
                        for album in albums {
                            guard album["name"] != nil, album["name"] as? String != "(null)" else { continue }
                            let data = try JSONSerialization.data(withJSONObject: album, options: [])
                            let decoder = JSONDecoder()
                            do {
                                let theAlbum = try decoder.decode(Album.self, from: data)
                                model.append(theAlbum)
                            } catch {
                                
                            }
                        }
                        completion(.success(model))

                    }
                } catch {
                    completion(.failure(APIError.responseParseError))
                }
            }
        }
    }


    /**
     Get Album info including the Album tracks.
     - Parameters:
       - albumName: The name of the album to get its info.
       - artistName: The name of the artist given album belongs to.
       - completion: The completion closure to be called after API result is returned and parsed.
     */
    static func getAlbumInfo(albumName: String, artistName: String, completion:@escaping (Result<Album, Error>)->Void) {
        
        AF.request(APIRouter.getAlbumInfo(albumName: albumName, artistName: artistName)).response { (dataResposne) in
            if let data = dataResposne.data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                        let album = json["album"] as? [String : Any],
                        let theTracks =  album["tracks"] as? [String : Any],
                        let tracks =  theTracks["track"] as? [[String : Any]] {
                        let data = try JSONSerialization.data(withJSONObject: album, options: [])
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(Album.self, from:
                            data) //Decode JSON Response Data
                        let tracksData = try JSONSerialization.data(withJSONObject: tracks, options: [])
                        let trackModel = try decoder.decode([Track].self, from:
                            tracksData) //Decode JSON Response Data
                        model.albumTracks = trackModel
                        model.artistName = artistName
                        completion(.success(model))
                    }
                } catch {
                    completion(.failure(APIError.responseParseError))
                }
            }
        }
    }

}

