//
//  MalaBaseReportCardCell.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/23.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

class MalaBaseReportCardCell: MalaBaseCardCell {

    // MARK: - Components
    /// 标题标签
    lazy var titleLabel: UILabel = {
        let label = UILabel(
            text: "报告标题",
            fontSize: 16,
            textColor: MalaColor_5E5E5E_0
        )
        return label
    }()
    /// 分割线
    lazy var separatorLine: UIView = {
        let view = UIView(MalaColor_EDEDED_0)
        return view
    }()
    /// 描述视图
    lazy var descView: UIView = {
        let view = UIView(MalaColor_F8FAFD_0)
        view.addShadow(color: MalaColor_D7D7D7_0)
        return view
    }()
    /// 曲别针图标
    private lazy var pinIcon: UIImageView = {
        let imageView = UIImageView(imageName: "pin_icon")
        return imageView
    }()
    /// 解读标签
    lazy var descTitleLabel: UILabel = {
        let label = UILabel(
            text: "解读：",
            fontSize: 12,
            textColor: MalaColor_363B4E_0
        )
        return label
    }()
    /// 解读详情标签
    lazy var descDetailLabel: UILabel = {
        let label = UILabel(
            text: "解读内容",
            fontSize: 10,
            textColor: MalaColor_5E5E5E_0
        )
        label.numberOfLines = 0
        return label
    }()
    
    
    // MARK: - Instance Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func setupUserInterface() {
        // Style
        
        // SubViews
        layoutView.addSubview(titleLabel)
        layoutView.addSubview(separatorLine)
        layoutView.addSubview(descView)
        layoutView.addSubview(pinIcon)
        descView.addSubview(descTitleLabel)
        descView.addSubview(descDetailLabel)
        
        
        // Autolayout
        titleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(20)
            maker.centerX.equalTo(layoutView)
            maker.top.equalTo(layoutView.snp.bottom).multipliedBy(0.05)
        }
        separatorLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(layoutView.snp.bottom).multipliedBy(0.13)
            maker.height.equalTo(MalaScreenOnePixel)
            maker.centerX.equalTo(layoutView)
            maker.width.equalTo(layoutView).multipliedBy(0.84)
        }
        descView.snp.makeConstraints { (maker) in
            maker.top.equalTo(layoutView.snp.bottom).multipliedBy(0.74)
            maker.left.equalTo(layoutView).offset(12)
            maker.right.equalTo(layoutView).offset(-12)
            maker.bottom.equalTo(layoutView).multipliedBy(0.92)
        }
        pinIcon.snp.makeConstraints { (maker) in
            maker.height.equalTo(19)
            maker.width.equalTo(19)
            maker.centerY.equalTo(descView.snp.top)
            maker.right.equalTo(descView).offset(-11)
        }
        descTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(descView.snp.bottom).multipliedBy(0.17)
            maker.height.equalTo(12)
            maker.left.equalTo(descView).offset(16)
            maker.right.equalTo(descView).offset(-16)
        }
        descDetailLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(descView.snp.bottom).multipliedBy(0.32)
            maker.left.equalTo(descView).offset(16)
            maker.right.equalTo(descView).offset(-16)
            maker.bottom.equalTo(descView).multipliedBy(0.82)
        }
    }
    
    func hideDescription() {
        // descView.hidden = true
        // pinIcon.hidden = true
    }
}
