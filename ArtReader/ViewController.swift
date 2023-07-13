//
//  ViewController.swift
//  ArtReader
//
//  Created by xzh on 2023/7/8.
//

import UIKit
import SSZipArchive
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let bookName = "小说现代中国"
        if let url = Bundle.main.url(forResource: bookName, withExtension: "epub") {
            guard let appDocumentUrl = FileManager.default.documentsURL else { return }
            let bookDocumentUrl = appDocumentUrl.appendingPathComponent(bookName)
            
            
            let unpacker = Unpacker()
            unpacker.unPackage(epubFileURL: url, unPackageURL: bookDocumentUrl)
        }
        
    }


}

