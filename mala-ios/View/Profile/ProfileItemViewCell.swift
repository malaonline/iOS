//
//  ProfileItemViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 2016/11/18.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class ProfileItemViewCell: UITableViewCell {
    
    // MARK: - Property
    var model: [ProfileElementModel]? {
        didSet {
            collectionView.model = model
        }
    }
    
    
    // MARK: - Components
    private lazy var collectionView: ProfileItemCollectionView = {
        let collectionView = ProfileItemCollectionView(
            frame: CGRect(x: 0, y: 0, width: MalaScreenWidth, height: 114),
            collectionViewLayout: CommonFlowLayout(type: .profileItem)
        )
        return collectionView
    }()
    
    
    // MARK: - Instance Method
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) -> Void in
            maker.center.equalTo(contentView)
            maker.width.equalTo(MalaScreenWidth)
            maker.height.equalTo(114)
        }
    }
}
