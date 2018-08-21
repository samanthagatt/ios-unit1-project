//
//  VolumeRepresentation.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct VolumeRepresentation: Decodable, Equatable {
    
    let volumeInfo: VolumeInfo
    
    let summary: String
    
    let imageStrings: ImageStrings
    
    var review: Review?
    
    struct Review: Decodable, Equatable {
        var rating: Int16?
        var string: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case volumeInfo
        case summary = "description"
        case imageStrings = "imageLinks"
    }
    
    
    // MARK: - JSON parsing
    
    struct VolumeInfo: Decodable, Equatable {
        let title: String
        let authors: [String]
        
        enum CodingKeys: String, CodingKey {
            case title
            case authors
        }
    }
    
    struct ImageStrings: Decodable, Equatable {
        let thumbnailString: String?
        let imageString: String?
        
        enum CodingKeys: String, CodingKey {
            case thumbnailString = "thumbnail"
            case imageString = "medium"
        }
    }
}


// MARK: - Equatable to core data Volume

func == (lhs: VolumeRepresentation, rhs: Volume) -> Bool {
    return
        // Why is it making me force unwrap everything only sometimes???
        lhs.volumeInfo.title == rhs.volumeInfo?.title &&
        // Don't think this will work
        // Need to get an array of all the authors' name variables
        // Will the authors always be in the same order?
        // Maybe something like rhs.volumeInfo!.authors.map {$0.name}
            lhs.volumeInfo.authors == rhs.volumeInfo?.authors?.allObjects as? [String] &&
            lhs.summary == rhs.summary &&
            lhs.review?.rating == rhs.review?.rating &&
            lhs.review?.string == rhs.review?.string &&
            lhs.imageStrings.thumbnailString == rhs.imageStrings?.thumbnailString &&
            lhs.imageStrings.imageString == rhs.imageStrings?.imageString
}

func == (lhs: Volume, rhs: VolumeRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: VolumeRepresentation, rhs: Volume) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Volume, rhs: VolumeRepresentation) -> Bool {
    return rhs != lhs
}
