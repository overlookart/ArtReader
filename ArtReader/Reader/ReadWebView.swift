//
//  ReadWebView.swift
//  ArtReader
//
//  Created by xzh on 2023/7/31.
//

import Foundation
import LAWebView
import WebKit
class ReadWebView: LAWebView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        debugPrint(action.description)
        switch action.description {
        case "_lookup:":
            return true
        case "_translate:":
            return true
        case "highlight:":
            return true
        default:
            return false
        }
    }
    
    override init(config: WebConfig) {
        super.init(config: config)
    }
    
    init() {
        let config = WebConfig()
        super.init(config: config)
        let jsString = """
            var meta = document.createElement('meta');
            meta.setAttribute('name', 'viewport');
            meta.setAttribute('content', 'width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no');
            document.getElementsByTagName('head')[0].appendChild(meta);
        """
        config.addUserScript(script: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        config.dataDetectorTypes = .all
        config.addScriptMessageHandler(self, name: "__reader__")
        
        
        let menuItem = UIMenuItem(title: "高亮", action: #selector(highlight(_:)))
        UIMenuController.shared.menuItems = [menuItem]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func highlight(_ sender: UIMenuController?) {
        
        evaluateJavaScript("window.__reader__.highlightString('highlight-pink')") { result, error in
            debugPrint(result,error)
        }
    }
}

extension ReadWebView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        debugPrint(message.name,message.body)
    }
}

