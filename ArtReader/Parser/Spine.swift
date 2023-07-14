//
//  Spine.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/14.
//

import Foundation
import SwiftSoup
struct Spine {
    struct SpineItem {
        var idref: String
    }
    var toc: String?
    var items: [SpineItem]?
    
    init(element: Element) {
        guard let items = try? element.getElementsByTag("itemref") else { return }
        self.items = []
        for item in items {
            if let idref = try? item.attr("idref") {
                self.items?.append(SpineItem(idref: idref))
            }
        }
    }
}
