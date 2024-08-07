//
//  ReaderCenterNVC.swift
//  ArtReader
//
//  Created by xzh on 2023/7/22.
//

import UIKit

class ReaderCenterNVC: UINavigationController {
    let readerCenter: ReaderCenter = ReaderCenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.setNavigationBarHidden(true, animated: true)
        self.setToolbarHidden(true, animated: true)
        overrideUserInterfaceStyle = .dark
    }
    
    init() {
        super.init(navigationBarClass: RCNavigationBar.self, toolbarClass: RCToolBar.self)
        self.setViewControllers([readerCenter], animated: true)
        //配置工具栏
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let toolbar = self.toolbar as? RCToolBar {
            readerCenter.setToolbarItems([toolbar.backBtnItem], animated: false)
            setToolbarHidden(false, animated: false)
        }
        UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .white
            }else{
                return .black
            }
        }
        self.hidesBarsOnTap = false
        self.hidesBarsOnSwipe = false
        self.barHideOnTapGestureRecognizer.addTarget(self, action: #selector(barHideOnTap))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc private func barHideOnTap(){
        debugPrint("barHideOnTap")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            
        }
    }
    
}
