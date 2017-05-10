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
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var contentShadow: UIView = {
        let view = UIView(UIColor.clear)
        view.layer.shadowColor = UIColor(named: .themeShadowBlue).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowOpacity = 1.0
        return view
    }()
    /// 标题标签
    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: L10n.member,
            font: FontFamily.PingFangSC.Regular.font(16),
            textColor: UIColor(named: .labelLightGray)
        )
        return label
    }()
    private lazy var line: UIView = {
        let view = UIView(UIColor(named: .themeLightBlue))
        return view
    }()
    /// 会员服务视图
    private lazy var collectionView: MemberSerivceCollectionView = {
        let view = MemberSerivceCollectionView(frame: CGRect.zero, collectionViewLayout: MemberSerivceFlowLayout())
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
        contentView.backgroundColor = UIColor(named: .themeLightBlue)
        
        // SubViews
        contentView.addSubview(contentShadow)
        contentShadow.addSubview(content)
        content.addSubview(titleLabel)
        content.addSubview(line)
        content.addSubview(collectionView)
        
        // Autolayout
        contentShadow.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(10)
            maker.left.equalTo(contentView).offset(10)
            maker.right.equalTo(contentView).offset(-10)
            maker.height.equalTo(266)
            maker.bottom.equalTo(contentView)
            
        }
        content.snp.makeConstraints { (maker) in
            maker.center.equalTo(contentShadow)
            maker.size.equalTo(contentShadow)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(content).offset(18)
            maker.left.equalTo(content).offset(10)
            maker.height.equalTo(22)
        }
        line.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(12)
            maker.height.equalTo(1)
            maker.left.equalTo(content).offset(10)
            maker.right.equalTo(content).offset(-10)
        }
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(line.snp.bottom)
            maker.bottom.equalTo(content)
            maker.left.equalTo(content).offset(12)
            maker.right.equalTo(content).offset(-12)
        }
    }
}
