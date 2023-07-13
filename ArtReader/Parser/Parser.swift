//
//  Parser.swift
//  ArtReader
//
//  Created by xzh on 2023/7/13.
//

import Foundation
import SwiftSoup
class Parser {
    
    var parserData = ParserData()
    
    /// 解析 Epub 文件内容
    /// - Parameter epubUrl: 已经减压后 Epub 文件夹路径
    func parseEpub(epubUrl: URL){
        guard FileManager.default.fileExists(atPath: epubUrl.path) else {
            debugPrint("无效的 Epub 文件")
            return
        }
        let META_INF_URL = epubUrl.appendingPathComponent("META-INF")
        let containerURL = META_INF_URL.appendingPathComponent("container.xml")
        guard FileManager.default.fileExists(atPath: containerURL.path) else {
            debugPrint("未找到 META-INF/container.xml", containerURL.path)
            return
        }
        parseContainer(fileUrl: containerURL)
    }
    
    func parseContainer(fileUrl: URL){
        guard let data = try? Data(contentsOf: fileUrl), let str = String(data: data, encoding: .utf8) else { return }
        parserData.setupContainer(doc: parseXml(xmlStr: str))
        debugPrint(parserData.container)
    }
    
    func parseXml(xmlStr: String) -> Document? {
        guard let doc = try? SwiftSoup.parse(xmlStr, "", SwiftSoup.Parser.xmlParser()) else { return nil }
       return doc
    }
}
