//
//  VolumeController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class VolumeController {
    
    init(shelf: Bookshelf? = nil, presenter: UIViewController? = nil) {
        if let shelf = shelf, let presenter = presenter {
            fetchFromShelf(bookshelf: shelf, presenter: presenter)
        }
    }
    
    static let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")!
    
    
    // MARK: - CRUD
    
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
    
    
    // MARK: - Persistence
    
    func saveToPersistentStore(context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            }
            catch {
                NSLog("Error saving volume: \(error)")
            }
        }
    }
    
    func fetchVolumeFromPersistentStore(id: String, context: NSManagedObjectContext) -> Volume? {
        let fetchRequest: NSFetchRequest<Volume> = Volume.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching volume with identifier \(id): \(error)")
            return nil
        }
    }
    
    func updateVolumes(for volumeReps: [VolumeRepresentation], in bookshelf: Bookshelf, context: NSManagedObjectContext) throws {
        context.performAndWait {
            for volumeRep in volumeReps {
                let volume = fetchVolumeFromPersistentStore(id: volumeRep.id, context: context)
                if let volume = volume {
                    if let bookshelves = volume.bookshelves, bookshelves.contains(bookshelf) {
                        continue
                    } else {
                        volume.addToBookshelves(bookshelf)
                    }
                } else {
                    let newVolume = Volume(volumeRep: volumeRep, context: context)
                    newVolume?.addToBookshelves(bookshelf)
                }
                print(volume?.bookshelves?.allObjects)
            }
        }
        saveToPersistentStore(context: context)
    }
    
    
    // MARK: - API
    
    // Returns volume representations | doesn't add volumes to core data
    func search(for searchTerm: String, presenter: UIViewController, completion: @escaping ([VolumeRepresentation]?, Error?) -> Void) {
        
        var urlComponents = URLComponents(url: VolumeController.baseURL, resolvingAgainstBaseURL: true)!
        let queryItem = URLQueryItem(name: "q", value: searchTerm)
        urlComponents.queryItems = [queryItem]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Error constructing search for \(searchTerm)")
            completion(nil, NSError())
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: presenter) { (error) in
            if let error = error {
                NSLog("Error getting authorization: \(error)")
                completion(nil, error)
                return
            }
            
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
    
    func fetchFromShelf(bookshelf: Bookshelf, presenter: UIViewController, completion: @escaping (Error?) -> Void = { _ in }) {
        
        let requestURL = BookshelfController.baseURL.appendingPathComponent(String(bookshelf.id)).appendingPathComponent("volumes")
        
        let request = URLRequest(url: requestURL)
        
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: presenter) { (error) in
            if let error = error {
                NSLog("Error getting authorization: \(error)")
                completion(error)
                return
            }
        
            GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
                if let error = error {
                    NSLog("Error adding authorization to request: \(error)")
                    completion(error)
                    return
                }
                
                guard let request = request else {
                    completion(NSError())
                    return
                }
                
                URLSession.shared.dataTask(with: request) { (data, _, error) in
                    if let error = error {
                        NSLog("Error performing data task: \(error)")
                        completion(error)
                        return
                    }
                    
                    guard let data = data else {
                        completion(NSError())
                        return
                    }
                    
                    do {
                        let volumeRepsFromJSON = try JSONDecoder().decode(VolumeJSONBase.self, from: data)
                        let volumeReps = volumeRepsFromJSON.items
                        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                        try self.updateVolumes(for: volumeReps, in: bookshelf, context: backgroundContext)
                        
                    } catch {
                        NSLog("Error decoding data: \(error)")
                        print("this is it")
                        completion(error)
                        return
                    }
                }.resume()
            }
        }
    }
}
