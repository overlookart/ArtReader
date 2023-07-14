//
//  Metadata.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/14.
//

import Foundation
import SwiftSoup
struct Metadata {
    /// 书名
    var title: String = ""
    /// 作者
    var creators: String = ""
    
    var contributor: String = ""
    /// 出版方
    var publisher: String = ""
    /// uuid
    var identifier: [[String:String]] = []
    /// 日期
    var date: String = ""
    /// 版权
    var rights: String = ""
    /// 描述
    var description: String = ""
    /// 语言
    var language: String = ""
    
    var cover: String = ""
    
    init(element: Element){
        /// 书名
        if let t = try? element.getElementsByTag("dc:title").first()?.text() {
            title = t
        }
        
        /// 作者
        if let creatorElement = try? element.getElementsByTag("dc:creator") {
            var c: [String] = []
            for element in creatorElement {
                if let cre = try? element.text() {
                    c.append(cre)
                }
            }
            creators = c.joined(separator: ",")
        }
        
        /// 出版方
        if let p = try? element.getElementsByTag("dc:publisher").first()?.text() {
            publisher = p
        }
        
        /// 日期
        if let d = try? element.getElementsByTag("dc:date").first()?.text() {
            date = d
        }
        
        /// 版权
        if let r = try? element.getElementsByTag("dc:rights").first()?.text() {
            rights = r
        }
        
        /// 描述
        if let des = try? element.getElementsByTag("dc:description").first()?.text() {
            description = des
        }
        
        /// 语言
        if let lan = try? element.getElementsByTag("dc:language").first()?.text() {
            language = lan
        }
        
        /// identifiers
        if let identifiers = try? element.getElementsByTag("dc:identifier") {
            for ide in identifiers {
                if let scheme = try? ide.attr("opf:scheme"), let idd = try? ide.text() {
                    identifier.append([scheme:idd])
                }
            }
        }
        
    }
}

