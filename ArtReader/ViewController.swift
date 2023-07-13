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
    var bookFileUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
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
}

