//
//  ExerciseMistakeViewCell.swift
//  mala-ios
//
//  Created by 王新宇 on 15/05/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import UIKit

class ExerciseMistakeViewCell: UICollectionViewCell {
    
    // MARK: - Components
    /// container card
    lazy var content: UIView = {
        let view = UIView(UIColor.white)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    lazy var contentShadow: UIView = {
        let view = UIView(UIColor.clear)
        view.layer.shadowColor = UIColor(named: .themeShadowBlue).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowOpacity = 1.0
        return view
    }()
    /// index
    private lazy var indexLabel: UILabel = {
        let label = UILabel(
            text: "1/5",
            font: FontFamily.PingFangSC.Regular.font(16),
            textColor: UIColor(named: .indexBlue),
            textAlignment: .right
        )
        return label
    }()
    /// exercise-group title
    private lazy var groupTitle: UILabel = {
        let label = UILabel(
            text: "2016中考 - 关系代词",
            font: FontFamily.PingFangSC.Regular.font(12),
            textColor: UIColor(named: .groupTitleGray),
            textAlignment: .center,
            opacity: 0.9,
            borderColor: UIColor(named: .protocolGary),
            borderWidth: 1.0,
            cornerRadius: 12
        )
        return label
    }()
    /// exercise-group description
    private lazy var groupDesc: UILabel = {
        let label = UILabel(
            text: "Sweet wormwood 青蒿是我国常见的植物．屠呦呦是用植物的特殊力量拯救数百万生命的女人．",
            font: FontFamily.PingFangSC.Regular.font(14),
            textColor: UIColor(named: .protocolGary),
            textAlignment: .justified
        )
        label.numberOfLines = 0
        return label
    }()
    private lazy var separator1: UIView = {
        let line = UIView(UIColor(named: .themeLightBlue))
        return line
    }()
    private lazy var separator2: UIView = {
        let line = UIView(UIColor(named: .themeLightBlue))
        return line
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
        contentView.backgroundColor = UIColor(named: .themeLightBlue)
        
        // SubViews
        contentView.addSubview(contentShadow)
        contentShadow.addSubview(content)
        content.addSubview(indexLabel)
        content.addSubview(groupTitle)
        content.addSubview(groupDesc)
        content.addSubview(separator1)
        
        
        // Autolayout
        contentShadow.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(10)
            maker.left.equalTo(contentView).offset(10)
            maker.right.equalTo(contentView).offset(-10)
            maker.bottom.equalTo(contentView).offset(-10)
            
        }
        content.snp.makeConstraints { (maker) in
            maker.center.equalTo(contentShadow)
            maker.size.equalTo(contentShadow)
        }
        indexLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(32)
            maker.height.equalTo(22)
            maker.top.equalTo(content).offset(18)
            maker.right.equalTo(content).offset(-13)
        }
        let width = (groupTitle.text! as NSString).size(attributes: [NSFontAttributeName : FontFamily.PingFangSC.Regular.font(12)]).width + (12*2)
        groupTitle.snp.makeConstraints { (maker) in
            maker.width.equalTo(width)
            maker.height.equalTo(24)
            maker.top.equalTo(content).offset(20)
            maker.left.equalTo(content).offset(15)
        }
        groupDesc.snp.makeConstraints { (maker) in
            maker.top.equalTo(groupTitle.snp.bottom).offset(10)
            maker.left.equalTo(content).offset(15)
            maker.right.equalTo(content).offset(-15)
        }
        separator1.snp.makeConstraints { (maker) in
            maker.height.equalTo(1)
            maker.left.equalTo(content).offset(10)
            maker.right.equalTo(content).offset(-10)
            maker.top.equalTo(groupDesc.snp.bottom).offset(18)
        }
    }
    
}
