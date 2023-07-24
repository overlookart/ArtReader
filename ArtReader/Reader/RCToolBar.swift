//
//  RCToolBar.swift
//  ArtReader
//
//  Created by xzh on 2023/7/22.
//

import UIKit

class RCToolBar: UIToolbar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private(set) var backBtnItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: nil, action: nil)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var items: [UIBarButtonItem]?{
        get{
            return [backBtnItem]
        }
        set{
            super.items = newValue
        }
    }
    
}
