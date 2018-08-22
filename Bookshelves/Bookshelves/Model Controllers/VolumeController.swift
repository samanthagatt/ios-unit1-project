//
//  VolumeController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

class VolumeController {
    
    static let baseURL = URL(string: "")!
    static let searchBaseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")!
    
    // MARK: - Properties
    
    var volumes: [Volume] = []
    
    
    // MARK: - CRUD
    
    func create(from volumeRep: VolumeRepresentation) {
        
    }
    
    func add(volume: Volume, to shelfTitle: String) {
        
    }
    
    func remove(volume: Volume, from shelfTitle: String) {
        
    }
    
    func updateRating(for volume: Volume, with int: Int16) {
        
    }
    
    func updateReview(for volume: Volume, with string: String) {
        
    }
    
    func toggleHasRead(for volume: Volume) {
        volume.hasRead = !volume.hasRead
        if volume.hasRead {
            add(volume: volume, to: "Has read")
        }
    }
    
    
    // MARK: - API
    
    // Returns volume representations | doesn't add volumes to core data
    func search(for searchTerm: String, completion: @escaping ([VolumeRepresentation]?, Error?) -> Void) {
        
        // Constructs url
        var urlComponents = URLComponents(url: VolumeController.searchBaseURL, resolvingAgainstBaseURL: true)!
        let queryItem = URLQueryItem(name: "q", value: searchTerm)
        urlComponents.queryItems = [queryItem]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Error constructing search for \(searchTerm)")
            completion(nil, NSError())
            return
        }
        
        // Creates request
        let request = URLRequest(url: requestURL)
        
        // Adds authorization to request
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to URLRequest: \(error)")
                completion(nil, error)
                return
            }
            
            guard let request = request else {
                completion(nil, error)
                return
            }
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                
                if let error = error {
                    NSLog("Error fetching data: \(error)")
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    completion(nil, NSError())
                    return
                }
                
                do {
                    let volumeRepsDict = try JSONDecoder().decode(VolumeJSONBase.self, from: data)
                    let volumeReps = volumeRepsDict.items
                    completion(volumeReps, nil)
                } catch {
                    NSLog("Error decoding data: \(error)")
                    completion(nil, error)
                    return
                }
            }.resume()
        }
    }
}
