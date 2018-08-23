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
    
    enum APIMethod: String {
        case add = "addVolume"
        case remove = "removeVolume"
    }
    
    // MARK: - CRUD
    
    func updateRating(for volume: Volume, with int: Int16) {
        
    }
    
    func updateReview(for volume: Volume, with string: String) {
        
    }
    
    func toggleHasRead(for volume: Volume) {
        volume.hasRead = !volume.hasRead
        if volume.hasRead {
//            add(volume: volume, to: "Has read")
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
    
    func checkForVolume(volumeRep: VolumeRepresentation, context: NSManagedObjectContext) -> Volume? {
        let volume = fetchVolumeFromPersistentStore(id: volumeRep.id, context: context)
        if let volume = volume {
            return volume
        } else {
            let newVolume = Volume(volumeRep: volumeRep, context: context)
            return newVolume
        }
    }
    
    func updateVolumes(for volumeReps: [VolumeRepresentation], in bookshelf: Bookshelf, context: NSManagedObjectContext) throws {
        context.performAndWait {
            
            // need clarification on the relationship aspect of core data
            if let volumes = bookshelf.volumes {
                for volume in volumes {
                    let thisVolume = volume as! Volume
                    bookshelf.removeFromVolumes(thisVolume)
                }
            }
            
            for volumeRep in volumeReps {
                let volume = fetchVolumeFromPersistentStore(id: volumeRep.id, context: context)
                if let volume = volume {
                        // shouldn't this add the inverse relationship to bookshelf??
                        volume.addToBookshelves(bookshelf)
                } else {
                    let newVolume = Volume(volumeRep: volumeRep, context: context)
                    newVolume?.addToBookshelves(bookshelf)
                }
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
    
    func addOrRemove(volume: Volume,
                     toOrfrom bookshelf: Bookshelf,
                     method: VolumeController.APIMethod,
                     context: NSManagedObjectContext,
                     presenter: UIViewController,
                     completion: @escaping (Error?) -> Void = { _ in }) {
        
        let url = BookshelfController.baseURL
            .appendingPathComponent(String(bookshelf.id))
            .appendingPathComponent(method.rawValue)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItem = URLQueryItem(name: "volumeID", value: volume.id)
        urlComponents.queryItems = [queryItem]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Error constructing url for \(volume.volumeInfo?.title ?? "volume")")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
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
                
                URLSession.shared.dataTask(with: request) { (_, _, error) in
                    if let error = error {
                        NSLog("Error performing data task: \(error)")
                        completion(error)
                        return
                    }
                    
                    switch method {
                    case .add:
                        volume.addToBookshelves(bookshelf)
                    case .remove:
                        volume.removeFromBookshelves(bookshelf)
                    }
                    
                    self.saveToPersistentStore(context: context)
                    completion(nil)
                    
                }.resume()
            }
        }
    }
}
