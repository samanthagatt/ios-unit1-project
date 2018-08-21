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
    convenience init(title: String, authors: String, summary: String, thumbnailString: String?, imageString: String?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.volumeInfo?.title = title
        self.volumeInfo?.authors = authors
        self.summary = summary
        self.imageStrings?.thumbnailString = thumbnailString
        self.imageStrings?.imageString = imageString
        
    }
    
    convenience init?(volumeRep: VolumeRepresentation, context: NSManagedObjectContext) {
        self.init(title: volumeRep.volumeInfo.title, authors: volumeRep.volumeInfo.authors, summary: volumeRep.summary, thumbnailString: volumeRep.imageStrings.thumbnailString, imageString: volumeRep.imageStrings.imageString, context: context)
    }
}
