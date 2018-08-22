//
//  BookshelfController.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

class BookshelfController {
    
    init() {
        fetchBookshelves()
    }
    
    static let baseURL = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves")!
    
    // MARK: - Properties
    
//    var bookshelves: [Bookshelf] = []
    
    
    // MARK: - Persistence
    
    func saveToPersistentStore(context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            }
            catch {
                NSLog("Error saving entry: \(error)")
            }
        }
    }
    
    func fetchBookshelfFromPersistentStore(id: Int16, context: NSManagedObjectContext) -> Bookshelf? {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching entry with identifier \(id): \(error)")
            return nil
        }
    }
    
    // Does it need throws??
    func addNewBookshelves(for bookshelfReps: [BookshelfRepresentation], context: NSManagedObjectContext) throws {
        context.performAndWait {
            // Commented out for testing
//            for bookshelfRep in bookshelfReps {
//                let bookshelf = fetchBookshelfFromPersistentStore(id: bookshelfRep.id, context: context)
//                if let _ = bookshelf { continue } else {
//                    _ = Bookshelf(bookshelfRep: bookshelfRep, context: context)
//                }
//            }
        }
        saveToPersistentStore(context: context)
    }
    
    
    // MARK: - API
    
    func fetchBookshelves(completion: @escaping (Error?) -> Void = { _ in }) {
        
        
        let request = URLRequest(url: BookshelfController.baseURL)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            
            if let error = error {
                NSLog("Error authorizing request: \(error)")
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
                    let bookshelfRepsDict = try JSONDecoder().decode(BookshelfJSONBase.self, from: data)
                    let bookshelfReps = bookshelfRepsDict.items
                    let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                    try self.addNewBookshelves(for: bookshelfReps, context: backgroundContext)
                    completion(nil)
                } catch {
                    NSLog("Error decoding data: \(error)")
                    completion(error)
                    return
                }
            }.resume()
        }
    }
}
