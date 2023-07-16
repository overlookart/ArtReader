//
//  TOC.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/14.
//

import Foundation
import SwiftSoup
struct Toc {
    struct NavItem {
        var id: String?
        var playOrder: String?
        var classStr: String?
        /// 章节标题
        var label: String?
        /// 章节内容资源
        var contentSrc: String?
        
        /// 子章节
        var navItems:[NavItem]?
    }
    var uid: String?
    /// 深度
    var depth: String?
    var totalPageCount: String?
    var maxPageNumber: String?
    var title: String?
    var navItems: [NavItem]?
    init(doc: Document) {
        guard let ncxElement = try? doc.getElementsByTag("ncx").first() else { return }
        /// meta
        if let metas = try? ncxElement.getElementsByTag("meta") {
            for meta in metas {
                if let name = try? meta.attr("name"), let content = try? meta.attr("content"){
                    if name == "dtb:uid" {
                        uid = content
                    }else if name == "dtb:depth" {
                        depth = content
                    }else if name == "dtb:totalPageCount" {
                        totalPageCount = content
                    }else if name == "dtb:maxPageNumber" {
                        maxPageNumber = content
                    }
                }
            }
        }
        
        /// title
        if let titleElement = try? ncxElement.getElementsByTag("docTitle").first(), let t = try? titleElement.getElementsByTag("text").first()?.text(){
            title = t
        }
        
        /// nav items
        if let navMap = try? ncxElement.getElementsByTag("navMap").first() {
            navItems = navPoint(elements: navMap.children())
        }
    }
    
    private func navPoint(elements: Elements) -> [NavItem]? {
        guard let _ = elements.filter({$0.tagName() == "navPoint"}).first else {
            return nil
        }
        var items: [NavItem] = []
        for element in elements {
            if element.tagName() == "navPoint" {
                var item = NavItem()
                item.id = try? element.attr("id")
                item.playOrder = try? element.attr("playOrder")
                item.classStr = try? element.attr("class")
                let childElements = element.children()
                item.label = try? childElements.filter({ $0.tagName() == "navLabel" }).first?.getElementsByTag("text").text()
                item.contentSrc = try? childElements.filter({ $0.tagName() == "content" }).first?.attr("src").split(separator: "#").map{String($0)}.first
                
                item.navItems = navPoint(elements: childElements)
                items.append(item)
            }
        }
        return items
    }
    
}
