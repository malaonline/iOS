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
    /// 卡片布局容器
    lazy var cardContent: UIView = {
        let view = UIView(UIColor.white)
        view.addShadow(color: UIColor(named: .ShadowGray))
        return view
    }()
    /// 标题标签
    lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "title",
            font: FontFamily.PingFangSC.Light.font(15),
            textColor: UIColor(named: .LiveDetailCardTitle)
        )
        return label
    }()
    /// 分割线
    lazy var line: UIView = {
        let view = UIView(UIColor(named: .CardBackground))
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
        contentView.backgroundColor = UIColor(named: .RegularBackground)
        
        // SubViews
        contentView.addSubview(cardContent)
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
            maker.top.equalTo(cardContent).offset(11.5)
            maker.left.equalTo(cardContent).offset(12)
            maker.height.equalTo(15)
        }
        line.snp.makeConstraints { (maker) in
            maker.top.equalTo(cardContent).offset(36)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.left.equalTo(cardContent).offset(6)
            maker.right.equalTo(cardContent).offset(-6)
        }
        content.snp.makeConstraints { (maker) in
            maker.top.equalTo(line.snp.bottom).offset(12)
            maker.left.equalTo(cardContent).offset(12)
            maker.right.equalTo(cardContent).offset(-12)
            maker.bottom.equalTo(cardContent).offset(-12)
        }
    }
}
