//
//  ReadHelp.swift
//  ArtReader
//
//  Created by CaiGou on 2024/8/1.
//

import Foundation
import UIKit
import DTCoreText
struct ReadHelper {
    
    /// 合并 html 和 css
    /// - Parameters:
    ///   - html: html 资源数据
    ///   - css: css 资源数据
    public static func merge(baseUrl: URL, html: Resource, css: [Resource]) -> String? {
        let htmlUrl = baseUrl.appendingPathComponent(html.href)
        guard let htmlStr = try? String(contentsOfFile: htmlUrl.path) else { return nil }
        debugPrint("----------合并前--------")
        debugPrint(htmlStr)
        debugPrint("-----------------------")
        var hs = htmlStr
        for style in css {
            if htmlStr.contains(style.href) {
                debugPrint(style)
                let pattern = "<link.*?href=\".*?\(style.href)\".*?\\/?>"
                debugPrint(pattern)
                let styleUrl = baseUrl.appendingPathComponent(style.href)
                if let styleStr = try? String(contentsOfFile: styleUrl.path, encoding: .utf8) {
                    hs = hs.replacingOccurrences(ofPattern: pattern, withTemplate: "<style>\(styleStr)</style>")
                }
            }
        }
        debugPrint("----------合并后--------")
        debugPrint(hs)
        debugPrint("-----------------------")
        return hs
    }
    
    public static func convert(htmlStr: String, attachAttrs: [NSAttributedString.Key : Any]? = nil) -> NSMutableAttributedString? {
        guard let data = htmlStr.data(using: .utf8) else { return nil }
        guard let aStr = try? NSMutableAttributedString(data: data, options: [.documentType:NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil) else { return nil }
        if let attrs = attachAttrs {
            aStr.addAttributes(attrs, range: NSRange(location: 0, length: aStr.length))
        }
        aStr.removeAttribute(.underlineStyle, range: NSRange(location: 0, length: aStr.length))
        guard let nStr = NSAttributedString(htmlData: data, documentAttributes: nil) else { return nil }
        return NSMutableAttributedString(attributedString: nStr)
        return aStr
    }
    
    
    
    public static func attachment(attrStr: NSAttributedString) -> NSAttributedString {
        debugPrint("attrStr:",attrStr.string)
        let attributedString = NSMutableAttributedString(attributedString: attrStr)
        let allrange = NSRange(location: 0, length: attributedString.length)
        attributedString.enumerateAttribute(.attachment, in: allrange, options: []) { value, range, stop in
            if let _ = value  {
                debugPrint("\n\n html image \n\n")
//                let image = attachment.image(forBounds: textView.bounds, textContainer: textView.textContainer, characterIndex: range.location)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(systemName: "photo")
                let imageString = NSAttributedString(attachment: imageAttachment)
                attributedString.replaceCharacters(in: range, with: imageString)
            }
        }
        return attributedString
    }

}
