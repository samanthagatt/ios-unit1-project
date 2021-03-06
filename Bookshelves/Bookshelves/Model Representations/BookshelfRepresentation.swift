//
//  BookshelfRepresentation.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct BookshelfJSONBase: Decodable, Equatable {
    let items: [BookshelfRepresentation]
}

struct BookshelfRepresentation: Decodable, Equatable {
    let id: Int16
    var title: String
    let selfLink: String
}
