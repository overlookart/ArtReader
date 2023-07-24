//
//  Item.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/14.
//

import Foundation
struct Resource: Equatable {
    
    enum MediaType: String, CaseIterable {
        case xhtml = "application/xhtml+xml"
        case epub = "application/epub+zip"
        case ncx = "application/x-dtbncx+xml"
        case opf = "application/oebps-package+xml"
        case javaScript = "text/javascript"
        case css = "text/css"
        case jpg = "image/jpeg"
        case png = "image/png"
        case gif = "image/gif"
        case svg = "image/svg+xml"
        case ttf = "application/x-font-ttf"
        case ttf1 = "application/x-font-truetype"
        case ttf2 = "application/x-truetype-font"
        case otf = "application/vnd.ms-opentype"
        case woff = "application/font-woff"
        case mp3 = "audio/mpeg"
        case mp4 = "audio/mp4"
        case ogg = "audio/ogg"
        case smil = "application/smil+xml"
        case xpgt = "application/adobe-page-template+xml"
        case pls = "application/pls+xml"
        case other
    }
    
    
    
    var id: String
    /// 文件相对路径
    var href: String
    /// 文件的 MIME 类型
    var mediaType: MediaType
    
    var rootPath: String
    
    init(id: String = "", href: String, mediaType: String, rootPath: String) {
        self.id = id
        self.href = rootPath + "/" + href
        self.mediaType = MediaType(rawValue: mediaType) ?? .other
        self.rootPath = rootPath
    }
}
