//
//  MalaBaseLiveCourseCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/10/20.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class MalaBaseLiveCourseCell: UITableViewCell {
    
    // MARK: - Property
    /// 标题文字
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    
    // MARK: - Components
    /// container card
    lazy var cardContent: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    lazy var contentShadow: UIView = {
        let view = UIView(UIColor.clear)
        view.layer.shadowColor = UIColor(named: .themeShadowBlue).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1.0
        return view
    }()
    /// 标题标签
    lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "title",
            font: FontFamily.PingFangSC.Regular.font(16),
            textColor: UIColor(named: .labelBlack)
        )
        return label
    }()
    /// 分割线
    lazy var line: UIView = {
        let view = UIView(UIColor(named: .themeLightBlue))
        return view
    }()
    /// 布局容器
    lazy var content: UIView = {
        let view = UIView(UIColor.white)
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
        selectionStyle = .none
        contentView.backgroundColor = UIColor(named: .themeLightBlue)
        
        // SubViews
        contentView.addSubview(contentShadow)
        contentShadow.addSubview(cardContent)
        cardContent.addSubview(titleLabel)
        cardContent.addSubview(line)
        cardContent.addSubview(content)
        
        // Autolayout
        cardContent.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView).offset(12)
            maker.right.equalTo(contentView).offset(-12)
            maker.bottom.equalTo(contentView)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(cardContent).offset(15)
            maker.left.equalTo(cardContent).offset(10)
            maker.height.equalTo(16)
        }
        line.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(15)
            maker.height.equalTo(1)
            maker.left.equalTo(cardContent).offset(10)
            maker.right.equalTo(cardContent).offset(-10)
        }
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(line.snp.bottom).offset(10)
            maker.left.equalTo(cardContent).offset(10)
            maker.right.equalTo(cardContent).offset(-10)
            maker.bottom.equalTo(cardContent).offset(-10)
        }
    }
}
