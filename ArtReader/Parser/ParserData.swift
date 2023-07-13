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
    
    mutating func setupContainer(doc: Document?){
        guard let d = doc else { return }
        self.container = Container(doc: d)
    }
}
