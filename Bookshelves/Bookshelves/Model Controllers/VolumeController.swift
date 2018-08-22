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
    
    static let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")!
    
    // MARK: - Properties
    
    
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
        var urlComponents = URLComponents(url: VolumeController.baseURL, resolvingAgainstBaseURL: true)!
        let queryItem = URLQueryItem(name: "q", value: searchTerm)
        urlComponents.queryItems = [queryItem]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Error constructing search for \(searchTerm)")
            completion(nil, NSError())
            return
        }
        
        // Creates request
        var request = URLRequest(url: requestURL)
        
        // Adds authorization to request
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (authorizedRequest, error) in
            if let error = error {
                NSLog("Error adding authorization to URLRequest: \(error)")
                completion(nil, error)
                return
            }
            
            guard let authorizedRequest = authorizedRequest else {
                completion(nil, error)
                return
            }
            
            request = authorizedRequest
            print(request)
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
