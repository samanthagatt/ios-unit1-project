//
//  VolumeRepresentation.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct Base: Decodable, Equatable {
    let items: [VolumeRepresentation]
}

struct VolumeRepresentation: Decodable, Equatable {
    
    let id: String
    let volumeInfo: VolumeInfo
    var review: Review?
    // Have to set hasRead to false before comparing to Volume object since Volume's hasRead will never be nil
    var hasRead: Bool?
    
    struct Review: Decodable, Equatable {
        var rating: Int16?
        var string: String?
    }
    
    struct VolumeInfo: Decodable, Equatable {
        let title: String
        let authorsArray: [String]
        let summary: String
        let imageStrings: ImageStrings?
        
        var authors: String {
            var scratch = ""
            for author in self.authorsArray {
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


// MARK: - Equatable to core data Volume

func == (lhs: VolumeRepresentation, rhs: Volume) -> Bool {
    return
        lhs.volumeInfo.title == rhs.volumeInfo?.title &&
            lhs.volumeInfo.authors == rhs.volumeInfo?.authors &&
            lhs.volumeInfo.summary == rhs.volumeInfo?.summary &&
            lhs.review?.rating == rhs.review?.rating &&
            lhs.review?.string == rhs.review?.string &&
            lhs.volumeInfo.imageStrings?.thumbnailString == rhs.volumeInfo?.imageStrings?.thumbnailString &&
            lhs.volumeInfo.imageStrings?.imageString == rhs.volumeInfo?.imageStrings?.imageString &&
            lhs.hasRead == rhs.hasRead
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


// MARK: - Volume object outline
/*
 Volume
    id
    volumeInfo
        title
        authors
    summary
    imageStrings?
        thumbnailString?
        imageString?
    review?
        rating?
        string?
 */
