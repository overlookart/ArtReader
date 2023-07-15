//
//  Parser.swift
//  ArtReader
//
//  Created by xzh on 2023/7/13.
//

import Foundation
import SwiftSoup

protocol ParserDelegate {
    
    /// 开始解析 epub
    func beginParserEpub()
    
    /// 解析 container
    func didParserContainer()
    
    /// 解析 Content
    func didParserContent()
    
    /// 解析 TOC
    func didParserToc()
    
    /// 解析 epub 完成
    func endedParserEpub()
    
    /// 解析 Epub 出错
    func errorParserEpub()
}

class Parser {
    var epubUrl: URL?
    var parserData = ParserData()
    var delegate: ParserDelegate?
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
            debugPrint("未找到 content.opf 文件", fileUrl.path)
            return
        }
        guard let data = try? Data(contentsOf: fileUrl), let str = String(data: data, encoding: .utf8) else { return }
        parserData.setupContent(doc: parseXml(xmlStr: str))
        if let tocFilePath = parserData.content?.getTocFilePath(), let epuburl = epubUrl, let resourcePath = parserData.container?.resourcePath {
            var tocUrl = epuburl.appendingPathComponent(resourcePath)
            tocUrl = tocUrl.appendingPathComponent(tocFilePath)
            parseToc(fileUrl: tocUrl)
        }
        
    }
    
    func parseToc(fileUrl: URL){
        guard FileManager.default.fileExists(atPath: fileUrl.path) else {
            debugPrint("未找到 toc.ncx 文件", fileUrl.path)
            return
        }
        guard let data = try? Data(contentsOf: fileUrl), let str = String(data: data, encoding: .utf8) else { return }
        parserData.setupToc(doc: parseXml(xmlStr: str))
    }
    
    func parseXml(xmlStr: String) -> Document? {
        guard let doc = try? SwiftSoup.parse(xmlStr, "", SwiftSoup.Parser.xmlParser()) else { return nil }
       return doc
    }
}
