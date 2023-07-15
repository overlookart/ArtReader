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
    func beginParserEpub(url: URL)
    
    /// 解析 container
    func didParserContainer()
    
    /// 解析 Content
    func didParserContent()
    
    /// 解析 TOC
    func didParserToc()
    
    /// 解析 epub 完成
    func endedParserEpub()
    
    /// 解析 Epub 出错
    func errorParserEpub(error: ParserError)
}


/// 解析器的错误
enum ParserError: Error {
    /// 无效的文件
    case FileInvalid(message: String, fileUrl: URL?)
    
    /// 转 String 失败
    case ToStrFailed(message: String, data: Data?)
    
    /// 转 XML 失败
    case ToXMLFailed(message: String, xmlStr: String)
}

class Parser {
    var epubUrl: URL?
    var parserData = ParserData()
    var delegate: ParserDelegate?
    /// 解析 Epub 文件内容
    /// - Parameter epubUrl: 已经减压后 Epub 文件夹路径
    func parseEpub(epubUrl: URL){
        
        do {
            try beginParserEpub(url: epubUrl)
        } catch {
            if let err = error as? ParserError {
                delegate?.errorParserEpub(error: err)
            }
        }
    }
    
    private func beginParserEpub(url: URL) throws {
        delegate?.beginParserEpub(url: url)
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw ParserError.FileInvalid(message: "未找到 Epub 文件", fileUrl: url)
        }
        self.epubUrl = url
        
        do {
            try parseContainer()
            try parseContent()
            try parseToc()
            delegate?.endedParserEpub()
        } catch {
            if let err = error as? ParserError {
                delegate?.errorParserEpub(error: err)
            }
        }
        
    }
    
    /// 解析 container 文件
    private func parseContainer() throws {
        guard let epuburl = epubUrl else { return }
        let META_INF_URL = epuburl.appendingPathComponent("META-INF")
        let containerURL = META_INF_URL.appendingPathComponent("container.xml")
        guard FileManager.default.fileExists(atPath: containerURL.path) else {
            throw ParserError.FileInvalid(message: "未找到 container 文件", fileUrl: containerURL)
        }
        guard let data = try? Data(contentsOf: containerURL)else {
            throw ParserError.FileInvalid(message: "无效的 container 文件", fileUrl: containerURL)
        }

        do {
            parserData.container = try parseContainer(data: data)
            delegate?.didParserContainer()
        } catch  {
            throw error
        }
    }
    
    
    /// 解析 container
    /// - Parameter data: container data
    /// - Returns: Container
    public func parseContainer(data: Data) throws  -> Container {
        guard let str = String(data: data, encoding: .utf8) else {
            throw ParserError.ToStrFailed(message: "container 数据转 string 失败", data: data)
        }
        guard let doc = parseXml(xmlStr: str) else {
            throw ParserError.ToXMLFailed(message: "container 解析 xml 失败", xmlStr: str)
        }
        return Container(doc: doc)
    }
    
    /// 解析 content 文件
    /// - Parameter fileUrl: 文件地址
    func parseContent() throws {
        guard let epuburl = epubUrl else { return }
        guard let contentPath = parserData.container?.getContentFile()?.fullPath else {
            throw ParserError.FileInvalid(message: "没有 content 文件地址", fileUrl: nil)
        }
        let contentURL = epuburl.appendingPathComponent(contentPath)
        guard FileManager.default.fileExists(atPath: contentURL.path) else {
            throw ParserError.FileInvalid(message: "未找到 content 文件", fileUrl: contentURL)
        }
        guard let data = try? Data(contentsOf: contentURL) else {
            throw ParserError.FileInvalid(message: "无效的 content 文件", fileUrl: contentURL)
        }
        
        do {
            parserData.content = try parseContent(data: data)
            delegate?.didParserContent()
        } catch {
            throw error
        }
        
        
    }
    
    /// 解析 content
    /// - Parameter data: content 数据
    /// - Returns: Content
    public func parseContent(data: Data) throws -> Content {
        guard let str = String(data: data, encoding: .utf8) else {
            throw ParserError.ToStrFailed(message: "content 数据转 string 失败", data: data)
        }
        guard let doc = parseXml(xmlStr: str) else {
            throw ParserError.ToXMLFailed(message: "content 解析 xml 失败", xmlStr: str)
        }
        return Content(doc: doc)
    }
    
    private func parseToc() throws {
        guard let epuburl = epubUrl else { return }
        guard let tocFilePath = parserData.content?.getTocFilePath(), let epuburl = epubUrl, let resourcePath = parserData.container?.resourcePath else {
            throw ParserError.FileInvalid(message: "没有 toc 文件地址", fileUrl: nil)
            
        }
        var tocUrl = epuburl.appendingPathComponent(resourcePath)
        tocUrl = tocUrl.appendingPathComponent(tocFilePath)
        guard FileManager.default.fileExists(atPath: tocUrl.path) else {
            throw ParserError.FileInvalid(message: "未找到 toc 文件", fileUrl: tocUrl)
        }
        guard let data = try? Data(contentsOf: tocUrl) else {
            throw ParserError.FileInvalid(message: "无效的 toc 文件", fileUrl: tocUrl)
        }
        
        do {
            parserData.toc = try parseToc(data: data)
            delegate?.didParserToc()
        } catch {
            throw error
        }
        
    }
    
    public func parseToc(data: Data) throws -> Toc {
        guard let str = String(data: data, encoding: .utf8) else {
            throw ParserError.ToStrFailed(message: "toc 数据转 string 失败", data: data)
        }
        guard let doc = parseXml(xmlStr: str) else {
            throw ParserError.ToXMLFailed(message: "toc 解析 xml 失败", xmlStr: str)
        }
        return Toc(doc: doc)
    }
    
    private func parseXml(xmlStr: String) -> Document? {
        guard let doc = try? SwiftSoup.parse(xmlStr, "", SwiftSoup.Parser.xmlParser()) else { return nil }
       return doc
    }
}
