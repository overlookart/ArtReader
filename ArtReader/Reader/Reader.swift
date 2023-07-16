//
//  Reader.swift
//  ArtReader
//
//  Created by CaiGou on 2023/7/13.
//

import Foundation
import UIKit
class Reader {
    let readerCenter = ReaderCenter()
    func openBook(vc: UIViewController, book: EpubBook) {
        let nav = UINavigationController(rootViewController: readerCenter)
        nav.modalPresentationStyle = .fullScreen
        readerCenter.epubBook = book
        vc.present(nav, animated: true)
    }
}
