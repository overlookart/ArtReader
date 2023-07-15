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
    var resourcePath: String = ""
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
            let footf = RootFile(fullPath: try? element.attr("full-path"), mediaType: try? element.attr("media-type"))
//            (footf.fullPath? as NSString).deletingLastPathComponent
            rootFiles?.append(footf)
        }
        if let content = getContentFile()?.fullPath {
            resourcePath = (content as NSString).deletingLastPathComponent
        }
    }
    
    
    /// 获取 content.opf
    /// - Returns: RootFile
    func getContentFile() -> RootFile? {
        guard let rootfs = rootFiles else { return nil }
        return rootfs.filter({ $0.fullPath?.range(of: "content.opf") != nil }).first
    }
}
