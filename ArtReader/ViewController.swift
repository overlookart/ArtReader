//
//  ViewController.swift
//  ArtReader
//
//  Created by xzh on 2023/7/8.
//

import UIKit
import SSZipArchive
class ViewController: UIViewController {
    let unpacker = Unpacker()
    let parser = Parser()
    let reader = Reader()
    var bookFileUrl: URL?
    
    
    @IBOutlet var mainCollectionView: UICollectionView!{
        didSet{
            mainCollectionView.dataSource = self
            mainCollectionView.delegate = self
            mainCollectionView.register(BookCell.self, forCellWithReuseIdentifier: "BookCell")
        }
    }
    
    private var dataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        parser.delegate = self
        dataSource = FileManager.default.findResourceFile(ExtendName: "epub")
    }
    
    func unEpubPack(filePath: String) {
        if let path = Bundle.main.path(forResource: filePath, ofType: nil) {
            let fileName = filePath.replacingOccurrences(of: ".epub", with: "")
            guard let appDocumentUrl = FileManager.default.documentsURL else { return }
            let bookDocumentUrl = appDocumentUrl.appendingPathComponent(fileName)
            let unpacker = Unpacker()
            
            if unpacker.unPackage(epubFileURL: URL(string: path)!, unPackageURL: bookDocumentUrl) {
                bookFileUrl = bookDocumentUrl
                parserEpubFile()
            }
        }
    }
    
    func parserEpubFile() {
        guard let url = bookFileUrl else { return }
        parser.parseEpub(epubUrl: url)
        readEpubBook()
    }
    
    func readEpubBook() {
        guard let url = bookFileUrl else { return }
        reader.openBook(vc: self, book: EpubBook(parserData: parser.parserData), fileUrl: url)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath)
        if let c = cell as? BookCell {
            c.setupData(data: dataSource[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        var width = (screenWidth - (3 * 5)) / 4.0
        if screenHeight < screenWidth {
            width = (screenHeight - (3 * 5)) / 4.0
        }
        
        let height = width * 4 / 3.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filePath = dataSource[indexPath.item]
        unEpubPack(filePath: filePath)
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
        debugPrint("解析 epub 完成", ebook.cssStyles)
    }
    
    func errorParserEpub(error: ParserError) {
        debugPrint("解析 epub 出错:", error)
    }
    
    
}

