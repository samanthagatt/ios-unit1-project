//
//  BookshelfRepresentation.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct BookshelfRepresentation: Decodable, Equatable {
    let id: Int16
    var title: String
}


// MARK: - Equatable to core data Bookshelf

func == (lhs: BookshelfRepresentation, rhs: Bookshelf) -> Bool {
    return
        lhs.id == rhs.id &&
            lhs.title == rhs.title
}

func == (lhs: Bookshelf, rhs: BookshelfRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: BookshelfRepresentation, rhs: Bookshelf) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Bookshelf, rhs: BookshelfRepresentation) -> Bool {
    return rhs != lhs
}
