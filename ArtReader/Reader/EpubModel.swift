//
//  EpubModel.swift
//  ArtReader
//
//  Created by xzh on 2023/7/15.
//

import Foundation
struct EpubModel {
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
    var spines: [Spine] = []
    
    struct Chapter {
        /// 章节标题
        var title: String = ""
        /// 章节内容(或内容地址)
        var content: String = ""
        
        var items: [Chapter]?
    }
}


