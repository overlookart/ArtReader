//
//  Content.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/14.
//

import Foundation
import SwiftSoup
struct Content {
    var xmlns: String?
    var version: String?
    var unique_identifier: String?
    /// 元数据
    var metadata: Metadata?
    /// 文件清单
    var manifest: [Item]?
    
    var spine: Spine?
    
    var guide: Guide?
    
    init(doc: Document){
        /// 获取 package 元素
        guard let packageElement = try? doc.getElementsByTag("package").first() else { return }
        /// 获取 metadata 元素
        if let metadataElement = try? packageElement.getElementsByTag("metadata").first() {
            metadata = Metadata(element: metadataElement)
            debugPrint(metadata)
        }
        
        /// 获取 manifest 的 item 元素
        if let manifestElement = try? packageElement.getElementsByTag("manifest").first(), let items = try? manifestElement.getElementsByTag("item") {
            manifest = []
            for i in items {
                if let id = try? i.attr("id"), let href = try? i.attr("href"), let type = try? i.attr("media-type") {
                    manifest?.append(Item(id: id, href: href, mediaType: type))
                }
            }
            debugPrint(manifest)
        }
    }
}
