//
//  Item.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/14.
//

import Foundation
struct Item {
    var id: String
    var href: String
    var mediaType: String
    
    init(id: String = "", href: String, mediaType: String) {
        self.id = id
        self.href = href
        self.mediaType = mediaType
    }
}
