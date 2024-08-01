//
//  BookCell.swift
//  ArtReader
//
//  Created by CaiGou on 2024/7/31.
//

import UIKit

class BookCell: UICollectionViewCell {
    private lazy var nameLab: UILabel = {
        let lab = UILabel(frame: .zero)
        lab.numberOfLines = 0
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupData(data: Any) {
        if let str = data as? String {
            nameLab.text = str
        }
    }
}
