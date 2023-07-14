//
//  Guide.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/14.
//

import Foundation
import SwiftSoup
struct Guide {
    struct GuideItem {
        var type: String = ""
        var title: String = ""
        var href: String = ""
    }
    var items: [GuideItem]? = []
    
    init(element: Element) {
        guard let items = try? element.getElementsByTag("reference") else { return }
        for item in items {
            if let type = try? item.attr("type"), let title = try? item.attr("title"), let href = try? item.attr("href") {
                self.items?.append(GuideItem(type: type, title: title, href: href))
            }
        }
    }
}
