//
//  Volume+Convenience.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

extension Volume {
    convenience init(id: String, title: String?, authors: String?, summary: String?, thumbnailString: String?, imageString: String?, hasRead: Bool, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        
        self.volumeInfo = VolumeInfo(title: title, summary: summary, authors: authors, thumbnailString: thumbnailString, imageString: imageString, context: context)
        
        self.hasRead = hasRead
        // When it's first being initialized it won't have a review (the user makes that later)
    }
    
    convenience init?(volumeRep: VolumeRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: volumeRep.id, title: volumeRep.volumeInfo.title, authors: volumeRep.volumeInfo.authors, summary: volumeRep.volumeInfo.summary, thumbnailString: volumeRep.volumeInfo.imageStrings?.thumbnailString, imageString: volumeRep.volumeInfo.imageStrings?.imageString, hasRead: false, context: context)
    }
}

extension VolumeInfo {
    convenience init(title: String?, summary: String?, authors: String?, thumbnailString: String?, imageString: String?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.summary = summary
        self.authors = authors
        self.imageStrings = ImageStrings(thumbnailString: thumbnailString, imageString: imageString, context: context)
    }
}

extension ImageStrings {
    convenience init(thumbnailString: String?, imageString: String?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.thumbnailString = thumbnailString
        self.imageString = imageString
    }
}
