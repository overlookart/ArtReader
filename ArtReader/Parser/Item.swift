//
//  Item.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/14.
//

import Foundation
struct Item {
    var id: String
    /// 文件相对路径
    var href: String
    /// 文件的 MIME 类型
    var mediaType: String
    
    init(id: String = "", href: String, mediaType: String) {
        self.id = id
        self.href = href
        self.mediaType = mediaType
    }
}
