//
//  ReadPageVC.swift
//  ArtReader
//
//  Created by xzh on 2023/7/22.
//

import UIKit
import LAWebView
import ZMarkupParser
class ReadPageVC: UIViewController {
    let webView: LAWebView = LAWebView(config: WebConfigComponent())
    var spine: Spine.SpineItem?
    var baseURL: URL?
//    let parser = ZHTMLParserBuilder.initWithDefault().build()
//    let lab = UITextView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
//        lab.backgroundColor = .white
//        lab.numberOfLines = 0
//        view.addSubview(lab)
//        lab.snp.makeConstraints { make in
//            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
//        }
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
//        webView.loadHTMLString(htmlStr, baseURL: baseURL)
    }
    
    public func loadContent(){
        guard let href = spine?.resource.href, let url = baseURL?.appendingPathComponent(href) else { return }
        guard let htmlStr = try? String(data: Data(contentsOf: url), encoding: .utf8) else { return }
        webView.loadHTMLString(htmlStr, baseURL: baseURL)

//        debugPrint(htmlStr)
//        lab.setHtmlString(htmlStr, with: parser)
        
    }
}
