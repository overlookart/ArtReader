//
//  ReadPageVC.swift
//  ArtReader
//
//  Created by xzh on 2023/7/22.
//

import UIKit
import LAWebView
import WebKit
import DTCoreText
class ReadPageVC: UIViewController {
    let webView: ReadWebView = ReadWebView()
    var spine: Spine.SpineItem?
    var baseURL: URL?
    var cssResourse:[Resource] = []
    var isTest: Bool = false {
        didSet{
            textView.isHidden = !isTest
        }
    }
    lazy var textView: DTAttributedTextView = {
        let view = DTAttributedTextView(frame: .zero)
        view.backgroundColor = .white
        view.textDelegate = self
//        view.isEditable = false
        view.isHidden = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        
        do {
            try webView.configuration.addUserScript(fileName: "Reader", injectionTime: .atDocumentStart, forMainFrameOnly: true)
        } catch  {
            debugPrint(error)
        }
        
        
        webView.navigationDelegates = (DecidePolicyNavigationAction:{ action in
            return WKNavigationActionPolicy.allow
        },DidStartNavigation:{ action in
            
        },DecidePolicyNavigationResponse:{ response in
            self.navigationResponse(response: response.response)
            return WKNavigationResponsePolicy.allow
        },DidCommitNavigation:{ action in
            
        },DidReceiveServerRedirect: { nav in
            
        },DidReceiveAuthChallenge: {
            return (AuthChallenge:URLSession.AuthChallengeDisposition.rejectProtectionSpace,Credential: nil)
        },DidFinishNavigation: { nav in
            debugPrint("导航完成")
        },DidFailNavigation:{ nav, err in
            debugPrint("导航失败", err)
        },DidFailProvisional:{ nav, err in
            debugPrint("加载内容失败", err)
        },DidTerminate:{
            debugPrint("加载Terminate")
        })
        
        loadContent()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func loadHtmlFile(url: URL, baseURL: URL?){
        guard let htmlStr = try? String(data: Data(contentsOf: url), encoding: .utf8) else { return }
        webView.loadHTMLString(htmlStr, baseURL: baseURL)
    }
    
    func setupHighlights(){
        
    }
    
    public func loadContent(){
        guard let href = spine?.resource.href, let url = baseURL?.appendingPathComponent(href) else { return }
        guard var htmlStr = try? String(contentsOfFile: url.path, encoding: .utf8) else { return }
        
        if let cssFilePath = Bundle.main.path(forResource: "Style", ofType: "css") {
            if let style = try? String(contentsOfFile: cssFilePath, encoding: .utf8) {
                let styleTag = "<style>\(style)</style>"
                htmlStr = htmlStr.replacingOccurrences(of: "</head>", with: styleTag)
            }
//            let cssTag = "<link rel=\"stylesheet\" type=\"text/css\" href=\"\(cssFilePath)\">"
//            let toInject = "\n\(cssTag)\n</head>"
        }
        if let url = baseURL, let html = spine?.resource {
            if var html = ReadHelper.merge(baseUrl: url, html: html, css: cssResourse) {
                if let cssFilePath = Bundle.main.path(forResource: "Style", ofType: "css") {
                    if let style = try? String(contentsOfFile: cssFilePath, encoding: .utf8) {
                        let styleTag = "<style>\(style)</style></head>"
                        html = html.replacingOccurrences(of: "</head>", with: styleTag)
                    }
                }
                html = html.replacingOccurrences(of: "<image", with: "<img")
                html = html.replacingOccurrences(of: "image>", with: "img>")
                debugPrint(html)
                if let attrStr = ReadHelper.convert(htmlStr: html) {
                    textView.attributedString = attrStr
                    
//                    textView.attributedText = ReadHelper.attachment(attrStr: attrStr)
                }
               
            }
        }
        webView.loadHTMLString(htmlStr, baseURL: URL(fileURLWithPath: url.deletingLastPathComponent().path))
    }
    
    func navigationResponse(response: URLResponse){
        guard let url = response.url else { return }
        guard let scheme = response.url?.scheme else { return }
        if scheme == "file" {
            debugPrint(url.fragment,"\n",url)
        }
    }
    
}

extension ReadPageVC: DTAttributedTextContentViewDelegate {
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if let imgAttachment = attachment as? DTImageTextAttachment {
            if let url = attachment.contentURL {
                debugPrint("contentURL",url.absoluteString)
            }
            
            if let url = attachment.hyperLinkURL {
                debugPrint("hyperLinkURL:",url.absoluteString)
            }
            let imgView = DTLazyImageView()
            imgView.contentMode = .scaleAspectFit
            imgView.bounds = CGRect(origin: .zero, size: attachment.displaySize)
            imgView.backgroundColor = .orange
            return imgView
        }
        
        
        return UIView()
    }
}
