//
//  VolumeRepresentation.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct VolumeJSONBase: Decodable, Equatable {
    let items: [VolumeRepresentation]
}

struct VolumeRepresentation: Decodable, Equatable {
    
    let id: String
    let volumeInfo: VolumeInfo
    var review: Review?
    var hasRead: Bool?
    var bookshelves: [BookshelfRepresentation]?
    
    struct Review: Decodable, Equatable {
        var rating: Int16?
        var string: String?
    }
    
    struct VolumeInfo: Decodable, Equatable {
        let title: String?
        let authorsArray: [String]?
        let summary: String?
        let imageStrings: ImageStrings?
        
        var authors: String? {
            var scratch = ""
            guard let authorArray = self.authorsArray else { return nil }
            
            for author in authorArray {
                scratch += author
            }
            return scratch
        }
        
        struct ImageStrings: Decodable, Equatable {
            let thumbnailString: String?
            let imageString: String?
            
            enum CodingKeys: String, CodingKey {
                case thumbnailString = "thumbnail"
                case imageString = "medium"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case title
            case authorsArray = "authors"
            case summary = "description"
            case imageStrings = "imageLinks"
        }
    }
    
}
