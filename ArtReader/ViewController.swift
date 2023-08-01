//
//  ViewController.swift
//  ArtReader
//
//  Created by xzh on 2023/7/8.
//

import UIKit
import SSZipArchive
class ViewController: UIViewController {
    let bookName = "小说现代中国"
    let unpacker = Unpacker()
    let parser = Parser()
    let reader = Reader()
    var bookFileUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        parser.delegate = self
        
    }
    
    @IBAction func unEpubPackAction(_ sender: Any) {
        if let url = Bundle.main.url(forResource: bookName, withExtension: "epub") {
            guard let appDocumentUrl = FileManager.default.documentsURL else { return }
            let bookDocumentUrl = appDocumentUrl.appendingPathComponent(bookName)
            let unpacker = Unpacker()
            
            if unpacker.unPackage(epubFileURL: url, unPackageURL: bookDocumentUrl) {
                bookFileUrl = bookDocumentUrl
            }
        }
    }
    
    @IBAction func parserEpubFileAction(_ sender: Any) {
        guard let url = bookFileUrl else { return }
        parser.parseEpub(epubUrl: url)
    }
    
    @IBAction func readEpubBookAction(_ sender: Any) {
        guard let url = bookFileUrl else { return }
        reader.openBook(vc: self, book: EpubBook(parserData: parser.parserData), fileUrl: url)
    }
}

extension ViewController: ParserDelegate {
    func beginParserEpub(url: URL) {
        debugPrint("开始解析 epub")
    }
    
    func didParserContainer() {
        debugPrint("已解析 container")
    }
    
    func didParserContent() {
        debugPrint("已解析 content")
    }
    
    func didParserToc() {
        debugPrint("已解析 toc")
    }
    
    func endedParserEpub() {
        
        let ebook = EpubBook(parserData: parser.parserData)
        debugPrint("解析 epub 完成", ebook)
    }
    
    func errorParserEpub(error: ParserError) {
        debugPrint("解析 epub 出错:", error)
    }
    
    
}

