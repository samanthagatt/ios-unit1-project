//
//  VolumeRepresentation.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct VolumeRepresentation: Decodable, Equatable {
    
    // struct VolumeInfo may or may not work?
    let title: VolumeInfo
    let authors: VolumeInfo
    
    let summary: String
    
    // May or may not work?
    let imageStrings: ImageStrings
    
    var review: Review?
    
    enum CodingKeys: String, CodingKey {
        
        // Will this work since the actual title and authors are in the struct VolumeInfo?
        // Might have to make them optional
        case title
        case authors
        
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
    
    struct Review: Decodable, Equatable {
        // does this have to be Int16?
        var rating: Int?
        var string: String?
    }
}
