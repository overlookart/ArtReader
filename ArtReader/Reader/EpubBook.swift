//
//  EpubModel.swift
//  ArtReader
//
//  Created by xzh on 2023/7/15.
//

import Foundation
struct EpubBook {
    /// 书籍名称
    var name: String = ""
    
    /// 作者
    var creators: String = ""
    
    /// 描述
    var description: String = ""
    
    /// 封面图
    var coverImgStr: String = ""
    
    /// 出版方
    var publisher: String = ""
    
    /// 版权
    var rights: String = ""
    
    /// 出版时间
    var date: String = ""
    
    /// 章节
    var chapters: [Chapter] = []
    
    /// 书脊
    var spines: [Spine.SpineItem] = []
    
    var cssStyles: [Resource]?
    
    struct Chapter {
        /// 章节标题
        var title: String = ""
        
        var spine: Spine.SpineItem
        
        var items: [Chapter]?
    }
    
    
    /// 初始化
    /// - Parameter parserData: 解析器的数据
    init(parserData: ParserData){
        if let t = parserData.content?.metadata?.title {
            name = t
        }
        
        if let c = parserData.content?.metadata?.creators {
            creators = c
        }
        
        if let des = parserData.content?.metadata?.description {
            description = des
        }
        
        if let cover = parserData.content?.metadata?.cover {
            coverImgStr = cover
        }
        
        if let p = parserData.content?.metadata?.publisher {
            publisher = p
        }
        
        if let r = parserData.content?.metadata?.rights {
            rights = r
        }
        
        if let d = parserData.content?.metadata?.date {
            date = d
        }
        
        if let tocs = parserData.toc?.navItems, let spines = parserData.content?.spine?.items {
            self.spines = spines
            chapters = setupChapters(navItems: tocs, spines: spines)
        }
        
        cssStyles = parserData.content?.manifest?.filter({ $0.mediaType == .css })
    }
    
    /// 配置章节数据
    /// - Parameters:
    ///   - navItems: 原始数据
    ///   - spines: 要关联的 spine 数据
    /// - Returns: 章节数组
    private func setupChapters(navItems:[Toc.NavItem], spines:[Spine.SpineItem]) -> [Chapter] {
        var chapters: [Chapter] = []
        for item in navItems {
            if let s = spines.filter({$0.resource.href.contains(item.contentSrc ?? "")}).first {
                var chapter = Chapter(title: item.label ?? "", spine: s)
                if let ci = item.navItems {
                    chapter.items = setupChapters(navItems: ci, spines: spines)
                }
                chapters.append(chapter)
            }
        }
        return chapters
    }
}


