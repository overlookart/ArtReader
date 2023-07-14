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
        var label: String?
        var content: String
        var navItems:[NavItem]?
    }
    var uid: String?
    var depth: String?
    var totalPageCount: String?
    var maxPageNumber: String?
    var title: String?
    var navItems: [NavItem]?
    init(doc: Document){
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
            if let childNodes = try? navMap.getChildNodes() {
                for (index, node) in childNodes.enumerated() {
                    debugPrint(node.nodeName(), index)
                }
                
            }
        }
        
    }
    
}
