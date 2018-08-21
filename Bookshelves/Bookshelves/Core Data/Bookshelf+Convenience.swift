//
//  Bookshelf+Convenience.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

extension Bookshelf {
    convenience init(id: Int16, title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = id
        self.title = title
    }
    convenience init?(bookshelfRep: BookshelfRepresentation, context: NSManagedObjectContext) {
        self.init(id: bookshelfRep.id, title: bookshelfRep.title, context: context)
    }
}
