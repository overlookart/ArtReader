//
//  Reader.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/13.
//

import Foundation
import UIKit

protocol ReaderDelegate {
    
}

protocol ReaderDataSource {
    
}

class Reader {
    
     var delegate: ReaderDelegate?
     var dataSource: ReaderDataSource?
    
    func openBook(vc: UIViewController, book: EpubBook, fileUrl: URL? = nil) {
        let nav = ReaderCenterNVC()
        nav.modalPresentationStyle = .fullScreen
        nav.hidesBottomBarWhenPushed = false
        nav.readerCenter.epubBook = book
        nav.readerCenter.baseURL = fileUrl
        vc.present(nav, animated: true)
    }
    
    func read(chapter: EpubBook.Chapter){
        
    }
}
