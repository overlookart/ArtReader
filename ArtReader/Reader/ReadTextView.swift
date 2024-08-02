//
//  ReadTextView.swift
//  ArtReader
//
//  Created by CaiGou on 2024/8/1.
//

import UIKit

class ReadTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
//        self.textContainer.maximumNumberOfLines = 3
//        self.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
