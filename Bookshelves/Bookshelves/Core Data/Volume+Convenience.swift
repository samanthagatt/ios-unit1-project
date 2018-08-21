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
    convenience init(id: String, title: String, authors: String, summary: String?, thumbnailString: String?, imageString: String?, hasRead: Bool = false, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.volumeInfo?.title = title
        self.volumeInfo?.authors = authors
        self.volumeInfo?.summary = summary
        self.volumeInfo?.imageStrings?.thumbnailString = thumbnailString
        self.volumeInfo?.imageStrings?.imageString = imageString
        self.hasRead = hasRead
        // When it's first being initialized it won't have a review (the user makes that later)
    }
    
    convenience init?(volumeRep: VolumeRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: volumeRep.id, title: volumeRep.volumeInfo.title, authors: volumeRep.volumeInfo.authors, summary: volumeRep.volumeInfo.summary, thumbnailString: volumeRep.volumeInfo.imageStrings?.thumbnailString, imageString: volumeRep.volumeInfo.imageStrings?.imageString, context: context)
    }
}
