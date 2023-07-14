//
//  ParserData.swift
//  ArtReader
//
//  Created by xzh on 2023/7/13.
//

import Foundation
import SwiftSoup
struct ParserData {
    
    var container: Container?
    
    var content: Content?
    
    var toc: Toc?
    
    mutating func setupContainer(doc: Document?){
        guard let d = doc else { return }
        self.container = Container(doc: d)
    }
    
    mutating func setupContent(doc: Document?){
        guard let d = doc else { return }
        content = Content(doc: d)
    }
    
    mutating func setupToc(doc: Document?){
        guard let d = doc else { return }
        toc = Toc(doc: d)
    }
}
