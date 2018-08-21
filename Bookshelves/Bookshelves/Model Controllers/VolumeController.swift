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
    
    static let baseURL = "https://www.googleapis.com/books/v1/"
    
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
    
    func search(for searchTerm: String, completion: @escaping (Error?) -> Void) {
        
    }
}
