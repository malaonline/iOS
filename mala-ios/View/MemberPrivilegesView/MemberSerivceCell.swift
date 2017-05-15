//
//  MemberSerivceCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/17.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class MemberSerivceCell: MalaBaseMemberCardCell {

    // MARK: - Components
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
        // SubViews
        content.addSubview(titleLabel)
        content.addSubview(line)
        content.addSubview(collectionView)
        
        // Autolayout
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
            maker.height.equalTo(192)
            maker.left.equalTo(content).offset(12)
            maker.right.equalTo(content).offset(-12)
            maker.bottom.equalTo(content).offset(-20)
        }
    }
}
