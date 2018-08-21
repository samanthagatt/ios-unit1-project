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
    
    let description: String
    
    // May or may not work?
    let imageStrings: ImageStrings
    
    enum CodingKeys: String, CodingKey {
        
        // Will this work since the actual title and authors are in the struct VolumeInfo?
        case title
        case authors
        
        case description
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
