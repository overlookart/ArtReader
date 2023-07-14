//
//  Container.swift
//  ArtReader
//
//  Created by xzh on 2023/7/14.
//

import Foundation
import SwiftSoup
struct Container {
    var version: String?
    var xmlns: String?
    var rootFiles: [RootFile]?
    struct RootFile {
        var fullPath: String?
        var mediaType: String?
    }
    
    init(doc: Document){
        guard let containerElement = try? doc.getElementsByTag("container").first() else { return }
        if let attrs = containerElement.getAttributes() {
            version = attrs.get(key: "version")
            xmlns = attrs.get(key: "xmlns")
        }
        guard let rootfs = try? doc.getElementsByTag("rootfile") else { return }
        rootFiles = []
        for element in rootfs {
            let footf = RootFile(fullPath: element.getAttributes()?.get(key: "full-path"), mediaType: element.getAttributes()?.get(key: "media-type"))
            rootFiles?.append(footf)
        }
    }
    
    
    /// 获取 content.opf
    /// - Returns: RootFile
    func getContentFile() -> RootFile? {
        guard let rootfs = rootFiles else { return nil }
        var contentFile: RootFile?
        for rootf in rootfs {
            if ((rootf.fullPath?.range(of: "content.opf")) != nil) {
                contentFile = rootf
            }
        }
        return contentFile
    }
}
