//
//  Parser.swift
//  ArtReader
//
//  Created by xzh on 2023/7/13.
//

import Foundation
import SwiftSoup
class Parser {
    var epubUrl: URL?
    var parserData = ParserData()
    
    /// 解析 Epub 文件内容
    /// - Parameter epubUrl: 已经减压后 Epub 文件夹路径
    func parseEpub(epubUrl: URL){
        guard FileManager.default.fileExists(atPath: epubUrl.path) else {
            debugPrint("无效的 Epub 文件")
            return
        }
        self.epubUrl = epubUrl
        let META_INF_URL = epubUrl.appendingPathComponent("META-INF")
        let containerURL = META_INF_URL.appendingPathComponent("container.xml")
        
        parseContainer(fileUrl: containerURL)
    }
    
    /// 解析 container 文件
    /// - Parameter fileUrl: 文件地址
    func parseContainer(fileUrl: URL){
        guard FileManager.default.fileExists(atPath: fileUrl.path) else {
            debugPrint("未找到 META-INF/container.xml", fileUrl.path)
            return
        }
        guard let data = try? Data(contentsOf: fileUrl), let str = String(data: data, encoding: .utf8) else { return }
        parserData.setupContainer(doc: parseXml(xmlStr: str))
        guard let contentPath = parserData.container?.getContentFile()?.fullPath else { return }
        guard let epuburl = epubUrl else { return }
        let contentURL = epuburl.appendingPathComponent(contentPath)
        
        parseContent(fileUrl: contentURL)
    }
    
    /// 解析 content 文件
    /// - Parameter fileUrl: 文件地址
    func parseContent(fileUrl: URL){
        guard FileManager.default.fileExists(atPath: fileUrl.path) else {
            debugPrint("未找到 content 文件", fileUrl.path)
            return
        }
        guard let data = try? Data(contentsOf: fileUrl), let str = String(data: data, encoding: .utf8) else { return }
        parserData.setupContent(doc: parseXml(xmlStr: str))
    }
    
    func parseXml(xmlStr: String) -> Document? {
        guard let doc = try? SwiftSoup.parse(xmlStr, "", SwiftSoup.Parser.xmlParser()) else { return nil }
       return doc
    }
}
