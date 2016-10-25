//
//  MemberSerivceCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class MemberSerivceCell: UITableViewCell {

    // MARK: - Components
    /// 父布局容器（白色卡片）
    private lazy var content: UIView = {
        let view = UIView()
        return view
    }()
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "会员专享",
            fontSize: 15,
            textColor: MalaColor_333333_0
        )
        return label
    }()
    /// 会员服务视图
    private lazy var collectionView: MemberSerivceCollectionView = {
        let view = MemberSerivceCollectionView(frame: CGRect.zero, collectionViewLayout: MemberSerivceFlowLayout(frame: CGRect.zero))
        return view
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
        // Style
        contentView.backgroundColor = MalaColor_EDEDED_0
        content.backgroundColor = UIColor.white
        
        // SubViews
        contentView.addSubview(content)
        content.addSubview(titleLabel)
        content.addSubview(collectionView)
        
        // Autolayout
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(8)
            maker.left.equalTo(contentView)
            maker.right.equalTo(contentView)
            maker.height.equalTo(229)
            maker.bottom.equalTo(contentView)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(16)
            maker.left.equalTo(content).offset(12)
            maker.height.equalTo(15)
        }
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(16)
            maker.bottom.equalTo(content)
            maker.left.equalTo(content).offset(12)
            maker.right.equalTo(content).offset(-12)
        }
    }
}
