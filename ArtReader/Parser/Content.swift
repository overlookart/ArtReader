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
    /// 整本书的文件清单
    var manifest: [Item]?
    /// 书脊，所有xhtml文档的线性阅读顺序
    var spine: Spine?
    
    var guide: Guide?
    
    init(doc: Document){
        
        /// 获取 package 元素
        guard let packageElement = try? doc.getElementsByTag("package").first() else { return }
        
        /// 获取 metadata 元素
        if let metadataElement = try? packageElement.getElementsByTag("metadata").first() {
            metadata = Metadata(element: metadataElement)
        }
        
        /// 获取 manifest 的 item 元素
        if let manifestElement = try? packageElement.getElementsByTag("manifest").first(), let items = try? manifestElement.getElementsByTag("item") {
            manifest = []
            for i in items {
                if let id = try? i.attr("id"), let href = try? i.attr("href"), let type = try? i.attr("media-type") {
                    manifest?.append(Item(id: id, href: href, mediaType: type))
                }
            }
        }
        
        if let spineElement = try? packageElement.getElementsByTag("spine").first(){
            spine = Spine(element: spineElement)
        }
        
        if let guideElement = try? packageElement.getElementsByTag("guide").first() {
            guide = Guide(element: guideElement)
        }
    }
    
    func getTocFilePath() -> String? {
        guard let items = manifest else { return nil }
        return items.filter({ $0.mediaType == "application/x-dtbncx+xml" }).first?.href
    }
}
