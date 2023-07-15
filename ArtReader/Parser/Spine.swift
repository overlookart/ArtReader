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
        var resource: Resource
    }
    var toc: String?
    var items: [SpineItem]?
    
    init(element: Element, manifest: [Resource]) {
        guard let items = try? element.getElementsByTag("itemref") else { return }
        self.items = []
        for item in items {
            if let idref = try? item.attr("idref"), let res = manifest.filter({ $0.id == idref }).first {
                self.items?.append(SpineItem(idref: idref, resource: res))
            }
        }
    }
}
